//
//  CTPersistanceSqlStatement.m
//  CTPersistance
//
//  Created by casa on 2017/8/13.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "CTPersistanceSqlStatement.h"
#import <SQLCipher/sqlite3.h>
#import "CTPersistanceConfiguration.h"

#import "CTPersistanceStatementCacheManager.h"

@interface CTPersistanceSqlStatement ()

@property (nonatomic, weak) CTPersistanceDataBase *database;

@property (nonatomic, copy) NSString *sqlString;

@property (nonatomic, strong) CTPersistanceStatementCacheManager *statementCacheManager;
@property (nonatomic, strong) CTPersistanceStatementCacheItem *statementItem;

@end

@implementation CTPersistanceSqlStatement

- (instancetype)initWithSqlString:(NSString *)sqlString bindValueList:(NSMutableArray <NSInvocation *> *)bindValueList database:(CTPersistanceDataBase *)database error:(NSError *__autoreleasing *)error
{
    self = [super init];
    
    if (self) {
        
        self.database = database;
        self.sqlString = sqlString;
        
        self.statementItem = [self.statementCacheManager getCachedStatementWithSQLString:sqlString atDatabase:self.database.databaseName];
        
        sqlite3_stmt *statement = self.statementItem.statement;
        
        if (!self.statementItem) {
            
            self.statementItem = [CTPersistanceStatementCacheItem new];
            
            int result = sqlite3_prepare_v2(database.database, [sqlString UTF8String], (int)sqlString.length, &statement, NULL);
            
            if (result != SQLITE_OK) {
                
                NSString *errorMessage = [NSString stringWithUTF8String:sqlite3_errmsg(database.database)];
                NSError *generatedError = [NSError errorWithDomain:kCTPersistanceErrorDomain code:CTPersistanceErrorCodeQueryStringError userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"\n======================\nQuery Error: \n Origin Query is : %@\n Error Message is: %@\n======================\n", sqlString, errorMessage]}];
                if (error != NULL) {
                    *error = generatedError;
                }
                NSLog(@"\n\n\n======================\n\n%@\n\n%s\n%s(%d):\n\n\terror is:\n\t\t %@ \n\n\t sqlString is %@\n\n======================\n\n\n", [NSThread currentThread], __FILE__, __FUNCTION__, __LINE__, errorMessage, sqlString);
                
                [self close];
                
                return nil;
            }
            
            self.statementItem.statement = statement;

        }
       
        [bindValueList enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull bindInvocation, NSUInteger idx, BOOL * _Nonnull stop) {
            [bindInvocation setArgument:(void *)&statement atIndex:2];
            [bindInvocation invoke];
        }];
        [bindValueList removeAllObjects];
        
    }
    return self;
}

- (void)close
{
    [self.statementCacheManager removeCachedStatement:self.statementItem forSQLString:self.sqlString atDatabase:self.database.databaseName];
    self.statementItem = nil;
}

- (BOOL)executeWithError:(NSError *__autoreleasing *)error
{
    if (error != NULL && *error != nil) {
        [self close];
        return NO;
    }

    self.statementItem.inUse = YES;
    
    sqlite3_stmt *statement = self.statementItem.statement;

    int result = sqlite3_step(statement);

    if (result != SQLITE_DONE && error) {
        
        [self close];
        
        const char *errorMsg = sqlite3_errmsg(self.database.database);
        NSError *generatedError = [NSError errorWithDomain:kCTPersistanceErrorDomain code:CTPersistanceErrorCodeQueryStringError userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"\n======================\nQuery Error: \n Origin Query is : %@\n Error Message is: %@\n======================\n", [NSString stringWithUTF8String:sqlite3_sql(statement)], [NSString stringWithCString:errorMsg encoding:NSUTF8StringEncoding]]}];
        *error = generatedError;
       
        
        return NO;
    }
    
   [self.statementCacheManager setCachedStatement:self.statementItem forSQLString:self.sqlString atDatabase:self.database.databaseName];
    
   return YES;
}


- (NSArray <NSDictionary *> *)fetchWithError:(NSError *__autoreleasing *)error
{
    if (error != NULL && *error != nil) {
        [self close];
        return nil;
    }

    self.statementItem.inUse = YES;
    
    
    NSMutableArray *resultsArray = [NSMutableArray array];

    sqlite3_stmt *statement = self.statementItem.statement;
    
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
                    // do nothing
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
    
   [self.statementCacheManager setCachedStatement:self.statementItem forSQLString:self.sqlString atDatabase:self.database.databaseName];
    
   
    return resultsArray;
}

#pragma mark - getter and setter
- (CTPersistanceStatementCacheManager *)statementCacheManager
{
    if (_statementCacheManager == nil) {
        _statementCacheManager = [CTPersistanceStatementCacheManager sharedInstance];
    }
    return _statementCacheManager;
}


@end
