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

extern SQLITE_API int sqlite3_key(sqlite3 *db, const void *pKey, int nKey);

NSString * const kCTPersistanceConfigurationParamsKeyDatabaseName = @"kCTPersistanceConfigurationParamsKeyDatabaseName";

@interface CTPersistanceDataBase ()

@property (nonatomic, unsafe_unretained) sqlite3 *database;
@property (nonatomic, copy) NSString *databaseName;
@property (nonatomic, copy) NSString *databaseFilePath;
@property (nonatomic, strong) CTPersistanceMigrator *migrator;

@end

@implementation CTPersistanceDataBase

#pragma mark - life cycle
- (instancetype)initWithDatabaseName:(NSString *)databaseName error:(NSError *__autoreleasing *)error
{
    self = [super init];
    if (self) {
        
        NSString *target = [[[[databaseName componentsSeparatedByString:@"_"] firstObject] componentsSeparatedByString:@"."] firstObject];

        self.databaseName = databaseName;
        
        self.databaseFilePath = [[CTMediator sharedInstance] performTarget:target
                                                                    action:@"filePath"
                                                                    params:@{kCTPersistanceConfigurationParamsKeyDatabaseName:databaseName}
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

        NSString *secretKey = [[CTMediator sharedInstance] performTarget:target
                                                                  action:@"secretKey"
                                                                  params:@{kCTPersistanceConfigurationParamsKeyDatabaseName:databaseName}
                                                       shouldCacheTarget:NO];

        if (secretKey && secretKey.length > 0) {
            sqlite3_key(_database, [secretKey UTF8String], (int)secretKey.length);
        }
        
        if (isFileExistsBefore == NO) {
            CTPersistanceQueryCommand *queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabase:self];
            [[queryCommand createTable:[CTPersistanceVersionTable tableName] columnInfo:[CTPersistanceVersionTable columnInfo]] executeWithError:NULL];
            [[queryCommand insertTable:[CTPersistanceVersionTable tableName] columnInfo:[CTPersistanceVersionTable columnInfo] dataList:@[@{@"databaseVersion":kCTPersistanceInitVersion}] error:NULL] executeWithError:NULL];
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
    sqlite3_close_v2(self.database);
    self.database = NULL;
    self.databaseFilePath = nil;
}

#pragma mark - getters and setters
- (CTPersistanceMigrator *)migrator
{
    if (_migrator == nil) {
        _migrator = [[CTMediator sharedInstance] performTarget:@"CTPersistanceConfiguration"
                                                        action:@"fetchMigrator"
                                                        params:@{kCTPersistanceConfigurationParamsKeyDatabaseName:self.databaseName}
                                             shouldCacheTarget:NO];
    }
    return _migrator;
}

@end
