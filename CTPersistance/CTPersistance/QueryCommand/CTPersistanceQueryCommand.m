//
//  CTPersistanceQueryBuilder.m
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceQueryCommand.h"
#import "CTPersistanceDataBase.h"
#import "CTPersistanceDatabasePool.h"
#import "CTPersistanceConfiguration.h"
@interface CTPersistanceQueryCommand ()

@property (nonatomic, unsafe_unretained) sqlite3_stmt *statement;
@property (nonatomic, weak) CTPersistanceDataBase *database;
@property (nonatomic, strong) NSString *databaseName;

@property (nonatomic, assign) BOOL isInTransaction;

@end

@implementation CTPersistanceQueryCommand

#pragma mark - public methods
- (instancetype)initWithDatabase:(CTPersistanceDataBase *)database
{
    self = [super init];
    if (self) {
        self.database = database;
    }
    return self;
}

- (instancetype)initWithDatabaseName:(NSString *)databaseName
{
    self = [super init];
    if (self) {
        self.databaseName = databaseName;
    }
    return self;
}

- (BOOL)executeWithError:(NSError *__autoreleasing *)error
{
    if (error != NULL && *error != nil) {
        sqlite3_finalize(self.statement);
        self.statement = nil;
        return NO;
    }

    sqlite3_stmt *statement = self.statement;

    int result = sqlite3_step(statement);
    
    if (result != SQLITE_DONE && error) {
        const char *errorMsg = sqlite3_errmsg(self.database.database);
        NSError *generatedError = [NSError errorWithDomain:kCTPersistanceErrorDomain code:CTPersistanceErrorCodeQueryStringError userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"\n======================\nQuery Error: \n Origin Query is : %@\n Error Message is: %@\n======================\n", [NSString stringWithUTF8String:sqlite3_sql(statement)], [NSString stringWithCString:errorMsg encoding:NSUTF8StringEncoding]]}];
        *error = generatedError;
        sqlite3_finalize(statement);
        return NO;
    }
    
    sqlite3_finalize(statement);
    self.statement = nil;
    
    return YES;
}

- (NSArray <NSDictionary *> *)fetchWithError:(NSError *__autoreleasing *)error
{
    if (error != NULL && *error != nil) {
        sqlite3_finalize(self.statement);
        self.statement = nil;
        return nil;
    }

    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];

    sqlite3_stmt *statement = self.statement;
    while (sqlite3_step(statement) == SQLITE_ROW) {
        int columns = sqlite3_column_count(statement);
        NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:columns];
        
        for (int i = 0; i<columns; i++) {
            const char *name = sqlite3_column_name(statement, i);
            
            NSString *columnName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            
            int type = sqlite3_column_type(statement, i);
            
            switch (type) {
                case SQLITE_INTEGER:
                {
                    int64_t value = sqlite3_column_int64(statement, i);
                    [result setObject:@(value) forKey:columnName];
                    break;
                }
                case SQLITE_FLOAT:
                {
                    double value = sqlite3_column_double(statement, i);
                    [result setObject:@(value) forKey:columnName];
                    break;
                }
                case SQLITE_TEXT:
                {
                    const char *value = (const char*)sqlite3_column_text(statement, i);
                    [result setObject:[NSString stringWithCString:value encoding:NSUTF8StringEncoding] forKey:columnName];
                    break;
                }
                    
                case SQLITE_BLOB:
                {
                    int bytes = sqlite3_column_bytes(statement, i);
                    if (bytes > 0) {
                        const void *blob = sqlite3_column_blob(statement, i);
                        if (blob != NULL) {
                            [result setObject:[NSData dataWithBytes:blob length:bytes] forKey:columnName];
                        }
                    }
                    break;
                }
                    
                case SQLITE_NULL:
                    [result setObject:[NSNull null] forKey:columnName];
                    break;
                    
                default:
                {
                    const char *value = (const char *)sqlite3_column_text(statement, i);
                    [result setObject:[NSString stringWithCString:value encoding:NSUTF8StringEncoding] forKey:columnName];
                    break;
                }
            }
        }
        [resultsArray addObject:result];
    }

    sqlite3_finalize(statement);
    self.statement = nil;
    
    return resultsArray;
}

- (CTPersistanceQueryCommand *)compileSqlString:(NSString *)sqlString bindValueList:(NSArray<NSInvocation *> *)bindValueList error:(NSError *__autoreleasing *)error
{
#warning todo statement cache
    sqlite3_stmt *statement = nil;
    int result = sqlite3_prepare_v2(self.database.database, [sqlString UTF8String], (int)sqlString.length, &statement, NULL);

    if (result != SQLITE_OK) {
        self.statement = nil;
        NSString *errorMessage = [NSString stringWithUTF8String:sqlite3_errmsg(self.database.database)];
        NSError *generatedError = [NSError errorWithDomain:kCTPersistanceErrorDomain code:CTPersistanceErrorCodeQueryStringError userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"\n======================\nQuery Error: \n Origin Query is : %@\n Error Message is: %@\n======================\n", sqlString, errorMessage]}];
        *error = generatedError;
        NSLog(@"error is %@", errorMessage);
        sqlite3_finalize(statement);
        return nil;
    }
    self.statement = statement;

    [bindValueList enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull bindInvocation, NSUInteger idx, BOOL * _Nonnull stop) {
        [bindInvocation setArgument:(void *)&statement atIndex:2];
        [bindInvocation invoke];
    }];

    return self;
}

#pragma mark - getters and setters
- (CTPersistanceDataBase *)database
{
    if (_database == nil) {
        _database = [[CTPersistanceDatabasePool sharedInstance] databaseWithName:self.databaseName];
    }
    return _database;
}

@end
