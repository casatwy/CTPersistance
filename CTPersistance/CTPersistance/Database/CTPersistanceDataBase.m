//
//  CTPersistanceDataBase.m
//  CTPersistance
//
//  Created by casa on 15/10/4.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceDataBase.h"

#import "CTPersistanceConfiguration.h"
#import "CTPersistanceMigrator.h"
#import "CTPersistanceVersionTable.h"
#import <CTMediator/CTMediator.h>

#import "CTPersistanceStatementCacheManager.h"

extern SQLITE_API int sqlite3_key(sqlite3 *db, const void *pKey, int nKey);
extern SQLITE_API int sqlite3_rekey(sqlite3 *db, const void *pKey, int nKey);

NSString * const kCTPersistanceConfigurationParamsKeyDatabase = @"kCTPersistanceConfigurationParamsKeyDatabase";
NSString * const kCTPersistanceConfigurationParamsKeyDatabaseName = @"kCTPersistanceConfigurationParamsKeyDatabaseName";

@interface CTPersistanceDataBase ()

@property (nonatomic, unsafe_unretained) sqlite3 *database;
@property (nonatomic, copy) NSString *databaseName;
@property (nonatomic, copy) NSString *databaseFilePath;
@property (nonatomic, strong) CTPersistanceMigrator *migrator;
@property (nonatomic, strong) NSString *target;
@property (nonatomic, strong) NSString *swiftModuleName;

@end

@implementation CTPersistanceDataBase

#pragma mark - life cycle
- (instancetype)initWithDatabaseName:(NSString *)databaseName swiftModuleName:(NSString *)swiftModuleName error:(NSError *__autoreleasing *)error
{
    self = [super init];
    if (self) {
        
        self.target = [[[[databaseName componentsSeparatedByString:@"_"] firstObject] componentsSeparatedByString:@"."] firstObject];
        self.databaseName = databaseName;
        self.swiftModuleName = swiftModuleName;
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        params[kCTPersistanceConfigurationParamsKeyDatabaseName] = databaseName;
        params[kCTMediatorParamsKeySwiftTargetModuleName] = self.swiftModuleName;
        self.databaseFilePath = [[CTMediator sharedInstance] performTarget:self.target
                                                                    action:@"filePath"
                                                                    params:params
                                                         shouldCacheTarget:NO];
        if (self.databaseFilePath == nil) {
            self.databaseFilePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:databaseName];
        }
        
        NSString *checkFilePath = [self.databaseFilePath stringByDeletingLastPathComponent];
        NSFileManager *defaultFileManager = [NSFileManager defaultManager];
        if (![defaultFileManager fileExistsAtPath:checkFilePath]) {
            [defaultFileManager createDirectoryAtPath:checkFilePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        BOOL isFileExistsBefore = [defaultFileManager fileExistsAtPath:self.databaseFilePath];
        const char *path = [self.databaseFilePath UTF8String];
        int result = sqlite3_open_v2(path, &(_database),
                                     SQLITE_OPEN_CREATE |
                                     SQLITE_OPEN_READWRITE |
                                     SQLITE_OPEN_NOMUTEX |
                                     SQLITE_OPEN_SHAREDCACHE,
                                     NULL);

        if (result != SQLITE_OK && error) {
            CTPersistanceErrorCode errorCode = CTPersistanceErrorCodeOpenError;
            NSString *sqliteErrorString = [NSString stringWithCString:sqlite3_errmsg(self.database) encoding:NSUTF8StringEncoding];
            NSString *errorString = [NSString stringWithFormat:@"open database at %@ failed with error:\n %@", self.databaseFilePath, sqliteErrorString];
            BOOL isFileExists = [defaultFileManager fileExistsAtPath:self.databaseFilePath];
            if (isFileExists == NO) {
                errorCode = CTPersistanceErrorCodeCreateError;
                errorString = [NSString stringWithFormat:@"create database at %@ failed with error:\n %@", self.databaseFilePath, [NSString stringWithCString:sqlite3_errmsg(self.database) encoding:NSUTF8StringEncoding]];
            }

            *error = [NSError errorWithDomain:kCTPersistanceErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey:errorString}];
            [self closeDatabase];
            return nil;
        }
        
        [self decrypt:isFileExistsBefore];

        if (isFileExistsBefore == NO) {
            CTPersistanceQueryCommand *queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabase:self];
            [[queryCommand createTable:[CTPersistanceVersionTable tableName] columnInfo:[CTPersistanceVersionTable columnInfo] error:NULL] executeWithError:NULL];
            
            NSString *initVersion = [self.migrator databaseInitVersion];

            if (!initVersion) {
                initVersion = kCTPersistanceInitVersion;
            }
            
            [[queryCommand insertTable:[CTPersistanceVersionTable tableName] columnInfo:[CTPersistanceVersionTable columnInfo] dataList:@[@{@"databaseVersion":initVersion}] error:NULL] executeWithError:NULL];
        }
        
        if ([self.migrator databaseShouldMigrate:self]) {
            [self.migrator databasePerformMigrate:self];
        }
    }
    return self;
}

- (void)dealloc
{
    [self closeDatabase];
}

#pragma mark - public methods
- (void)closeDatabase
{
    if (@available(iOS 8.2, *)) {
        sqlite3_close_v2(_database);
    } else {
        sqlite3_close(_database);
    }
    
    _database = NULL;
    _databaseFilePath = nil;
    
    [[CTPersistanceStatementCacheManager sharedInstance] clearDatabaseStatementCache:self.databaseName];
}

#pragma mark - private methods
- (void)openDatabase {
    if (self.databaseFilePath == nil || self.databaseFilePath.length == 0) {
        return;
    }
    
    const char *path = [self.databaseFilePath UTF8String];
    int result = sqlite3_open_v2(path, &(_database),
                                 SQLITE_OPEN_CREATE |
                                 SQLITE_OPEN_READWRITE |
                                 SQLITE_OPEN_NOMUTEX |
                                 SQLITE_OPEN_SHAREDCACHE,
                                 NULL);
    if (result != SQLITE_OK) {
        CTPersistanceErrorCode errorCode = CTPersistanceErrorCodeOpenError;
        NSString *sqliteErrorString = [NSString stringWithCString:sqlite3_errmsg(self.database) encoding:NSUTF8StringEncoding];
        NSString *errorString = [NSString stringWithFormat:@"open database at %@ failed with error:\n %@", self.databaseFilePath, sqliteErrorString];
        NSFileManager *defaultFileManager = [NSFileManager defaultManager];
        BOOL isFileExists = [defaultFileManager fileExistsAtPath:self.databaseFilePath];
        if (isFileExists == NO) {
            errorCode = CTPersistanceErrorCodeCreateError;
            errorString = [NSString stringWithFormat:@"create database at %@ failed with error:\n %@", self.databaseFilePath, [NSString stringWithCString:sqlite3_errmsg(self.database) encoding:NSUTF8StringEncoding]];
        }
        
        [self closeDatabase];
    }
}

- (void)decrypt:(BOOL)isFileExistsBefore
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[kCTPersistanceConfigurationParamsKeyDatabaseName] = self.databaseName;
    params[kCTMediatorParamsKeySwiftTargetModuleName] = self.swiftModuleName;
    NSArray <NSString *> *secretKey = [[CTMediator sharedInstance] performTarget:self.target
                                                             action:@"secretKey"
                                                             params:params
                                                  shouldCacheTarget:NO];
    
    if ([secretKey isKindOfClass:[NSString class]]) {
        NSString *keyString = (NSString *)secretKey;
        if (keyString.length > 0) {
            sqlite3_key(_database, [keyString UTF8String], (int)keyString.length);
        }
        return;
    }
    
    if ([secretKey isKindOfClass:[NSArray class]]) {

        if (secretKey.count < 1) {
            return;
        }
        
        NSString *newestKeyString = secretKey.lastObject;
        
        if (isFileExistsBefore) {
            if ((secretKey.count == 1)) {// only one key
                if ([self isKeyAvailable:newestKeyString]) {// try the only key
                    return ;
                } else if ([self isExistingFileNotEncrypted]) {// not encrypted before
                    if (newestKeyString.length > 0) {
                        // encrypt plaintext database use the new key
                        [self encrptExistingPlaintextDatabaseUseKey:newestKeyString];
                        
                        // reopen database
                        [self openDatabase];
                        
                        sqlite3_key(_database, [newestKeyString UTF8String], (int)newestKeyString.length);
                    }
                } else {
                    // other error
                }
            } else {
                // try the newest key first
                if ([self isKeyAvailable:newestKeyString]) {
                    return;
                }
                
                // enumerate keys for correct key, and rekey with newest key.
                for (NSString *keyString in secretKey) {
                    if ([self isKeyAvailable:keyString]) {
                        sqlite3_rekey(_database, [newestKeyString UTF8String], (int)newestKeyString.length);
                        return;
                    }
                }
            }
        } else {// a brand new database
            if (newestKeyString.length > 0) {
                sqlite3_key(_database, [newestKeyString UTF8String], (int)newestKeyString.length);
                return;
            }
        }
    }
}

- (BOOL)isKeyAvailable:(NSString *)key
{
    sqlite3_key(_database, [key UTF8String], (int)key.length);
    CTPersistanceQueryCommand *queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabase:self];
    NSError *error = nil;
    [[queryCommand showTablesWithError:&error] fetchWithError:&error];
    
    if (error == nil) {
        return YES;
    }
    return NO;
}

- (BOOL)isExistingFileNotEncrypted
{
    // close and reopen database to remove key set by sqlite3_key
    // close database but reserve databaseFilePath
    [self closeDatabaseAndReserveDatabaseFilePath];
    
    // reopen
    [self openDatabase];
    
    CTPersistanceQueryCommand *queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabase:self];
    NSError *error = nil;
    [[queryCommand showTablesWithError:&error] fetchWithError:&error];
    
    if (error == nil) {
        return YES;
    }
    return NO;
}

- (void)encrptExistingPlaintextDatabaseUseKey:(NSString *)keyString {
    NSString *tempEncryptedFileName = @"encrypted";
    NSString *databaseFilePathExtension = [self.databaseFilePath pathExtension];
    NSString *directoryPath = [self.databaseFilePath stringByDeletingLastPathComponent];
    NSString *encryptedFilePath = [[directoryPath stringByAppendingPathComponent:tempEncryptedFileName] stringByAppendingPathExtension:databaseFilePathExtension];
    
    NSString *attachSqlQuery = [NSString stringWithFormat:@"ATTACH DATABASE '%@' AS encrypted KEY '%@';", encryptedFilePath, keyString];
    char *errorMsg = NULL;
    int attachResult = sqlite3_exec(_database, [attachSqlQuery UTF8String], NULL, NULL, &errorMsg);
    if (attachResult != SQLITE_OK) {
        printf("%s", errorMsg);
        return;
    }
    
    NSString *exportSqlQuery = [NSString stringWithFormat:@"SELECT sqlcipher_export('%@');", tempEncryptedFileName];
    int exportResult = sqlite3_exec(_database, [exportSqlQuery UTF8String], NULL, NULL, &errorMsg);
    if (exportResult != SQLITE_OK) {
        printf("%s", errorMsg);
        return;
    }
    
    NSString *detachSqlQuery = [NSString stringWithFormat:@"DETACH DATABASE %@;", tempEncryptedFileName];
    int detachResult = sqlite3_exec(_database, [detachSqlQuery UTF8String],NULL, NULL, &errorMsg);
    if (detachResult != SQLITE_OK) {
        printf("%s", errorMsg);
        return;
    }
    
    // close data but not set databaseFilePath to NULL
    [self closeDatabaseAndReserveDatabaseFilePath];
    
    // remove plaintext database
    NSFileManager *defaultFileManager = [NSFileManager defaultManager];
    NSError *removeFileError = nil;
    [defaultFileManager removeItemAtPath:self.databaseFilePath error:&removeFileError];
    if (removeFileError) {
        NSLog(@"remove plaintext database failed : %@", removeFileError);
        return;
    }
    
    // rename encrypted database
    if ([defaultFileManager fileExistsAtPath:encryptedFilePath]) {
        NSError *error = nil;
        BOOL moveResult = [defaultFileManager moveItemAtPath:encryptedFilePath toPath:self.databaseFilePath error:&error];
        if (moveResult) {
            NSLog(@"rename encrypted database success");
        } else {
            NSLog(@"rename encrypted database failed : %@", error);
            return;
        }
    }
}

- (void)closeDatabaseAndReserveDatabaseFilePath {
    if (@available(iOS 8.2, *)) {
        sqlite3_close_v2(_database);
    } else {
        sqlite3_close(_database);
    }
    
    _database = NULL;
}

#pragma mark - getters and setters
- (CTPersistanceMigrator *)migrator
{
    if (_migrator == nil) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        params[kCTPersistanceConfigurationParamsKeyDatabaseName] = self.databaseName;
        params[kCTMediatorParamsKeySwiftTargetModuleName] = self.swiftModuleName;
        _migrator = [[CTMediator sharedInstance] performTarget:self.target
                                                        action:@"fetchMigrator"
                                                        params:@{kCTPersistanceConfigurationParamsKeyDatabaseName:self.databaseName}
                                             shouldCacheTarget:NO];
    }
    return _migrator;
}

@end
