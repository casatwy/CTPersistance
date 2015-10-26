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

@property (nonatomic, weak) CTPersistanceDataBase *database;
@property (nonatomic, strong) NSString *databaseName;
@property (nonatomic, strong) NSMutableString *sqlString;

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

- (CTPersistanceQueryCommand *)resetQueryCommand
{
    self.sqlString = nil;
    return self;
}

- (BOOL)executeWithError:(NSError *__autoreleasing *)error
{
    BOOL isSuccess = YES;
    
    sqlite3_stmt *statement;
    const char *query = [[NSString stringWithFormat:@"%@;", self.sqlString] UTF8String];
#ifdef DEBUG
    NSLog(@"\n\n\n\n\n=========================\n\nCTPersistance SQL String is:\n%@\n\n=========================\n\n\n\n\n", [NSString stringWithCString:query encoding:NSUTF8StringEncoding]);
#endif
    int result = sqlite3_prepare_v2(self.database.database, query, -1, &statement, NULL);
    
    if (result != SQLITE_OK && error) {
        const char *errorMsg = sqlite3_errmsg(self.database.database);
        NSError *generatedError = [NSError errorWithDomain:kCTPersistanceErrorDomain code:CTPersistanceErrorCodeQueryStringError userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"\n======================\nQuery Error: \n Origin Query is : %@\n Error Message is: %@\n======================\n", self.sqlString, [NSString stringWithCString:errorMsg encoding:NSUTF8StringEncoding]]}];
        *error = generatedError;
        sqlite3_finalize(statement);
        return NO;
    }
    
    result = sqlite3_step(statement);
    
    if (result != SQLITE_DONE && error) {
        const char *errorMsg = sqlite3_errmsg(self.database.database);
        NSError *generatedError = [NSError errorWithDomain:kCTPersistanceErrorDomain code:CTPersistanceErrorCodeQueryStringError userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"\n======================\nQuery Error: \n Origin Query is : %@\n Error Message is: %@\n======================\n", self.sqlString, [NSString stringWithCString:errorMsg encoding:NSUTF8StringEncoding]]}];
        *error = generatedError;
        sqlite3_finalize(statement);
        return NO;
    }
    
    sqlite3_finalize(statement);
    
    return isSuccess;
}

- (NSArray <NSDictionary *> *)fetchWithError:(NSError *__autoreleasing *)error
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    const char *query = [[NSString stringWithFormat:@"%@;", self.sqlString] UTF8String];
#ifdef DEBUG
    NSLog(@"\n\n\n\n\n=========================\n\nCTPersistance SQL String is:\n%@\n\n=========================\n\n\n\n\n", [NSString stringWithCString:query encoding:NSUTF8StringEncoding]);
#endif
    int returnCode = sqlite3_prepare_v2(self.database.database, query, -1, &statement, NULL);
    
    if (returnCode != SQLITE_OK && error) {
        const char *errorMsg = sqlite3_errmsg(self.database.database);
        *error = [NSError errorWithDomain:kCTPersistanceErrorDomain code:CTPersistanceErrorCodeQueryStringError userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"\n\n\n======================\nQuery Error: \n Origin Query is : %@\n Error Message is: %@\n======================\n\n\n", self.sqlString, [NSString stringWithCString:errorMsg encoding:NSUTF8StringEncoding]]}];
        sqlite3_finalize(statement);
        return resultsArray;
    }
    
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
                    int value = sqlite3_column_int(statement, i);
                    [result setObject:[NSNumber numberWithInt:value] forKey:columnName];
                    break;
                }
                case SQLITE_FLOAT:
                {
                    float value = sqlite3_column_double(statement, i);
                    [result setObject:[NSNumber numberWithFloat:value] forKey:columnName];
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
    
    return resultsArray;
}

#pragma mark - getters and setters
- (NSMutableString *)sqlString
{
    if (_sqlString == nil) {
        _sqlString = [[NSMutableString alloc] init];
    }
    return _sqlString;
}

- (CTPersistanceDataBase *)database
{
    if (_database == nil) {
        _database = [[CTPersistanceDatabasePool sharedInstance] databaseWithName:self.databaseName];
    }
    return _database;
}

@end
