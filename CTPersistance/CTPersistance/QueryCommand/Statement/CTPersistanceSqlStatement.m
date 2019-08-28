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

@interface CTPersistanceSqlStatement ()

@property (nonatomic, unsafe_unretained) sqlite3_stmt *statement;
@property (nonatomic, weak) CTPersistanceDataBase *database;

@end

@implementation CTPersistanceSqlStatement

- (instancetype)initWithSqlString:(NSString *)sqlString bindValueList:(NSMutableArray <NSInvocation *> *)bindValueList database:(CTPersistanceDataBase *)database error:(NSError *__autoreleasing *)error
{
    self = [super init];
    if (self) {
        self.database = database;
#warning todo statement cache
        sqlite3_stmt *statement = nil;
        int result = sqlite3_prepare_v2(database.database, [sqlString UTF8String], (int)[sqlString lengthOfBytesUsingEncoding:NSUTF8StringEncoding], &statement, NULL);

        if (result != SQLITE_OK) {
            self.statement = nil;
            NSString *errorMessage = [NSString stringWithUTF8String:sqlite3_errmsg(database.database)];
            NSError *generatedError = [NSError errorWithDomain:kCTPersistanceErrorDomain code:CTPersistanceErrorCodeQueryStringError userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"\n======================\nQuery Error: \n Origin Query is : %@\n Error Message is: %@\n======================\n", sqlString, errorMessage]}];
            if (error != NULL) {
                *error = generatedError;
            }
            NSLog(@"\n\n\n======================\n\n%@\n\n%s\n%s(%d):\n\n\terror is:\n\t\t %@ \n\n\t sqlString is %@\n\n======================\n\n\n", [NSThread currentThread], __FILE__, __FUNCTION__, __LINE__, errorMessage, sqlString);
            sqlite3_finalize(statement);
            return nil;
        }
        self.statement = statement;

        [bindValueList enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull bindInvocation, NSUInteger idx, BOOL * _Nonnull stop) {
            [bindInvocation setArgument:(void *)&statement atIndex:2];
            [bindInvocation invoke];
        }];
        [bindValueList removeAllObjects];
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

    sqlite3_finalize(statement);
    self.statement = nil;

    return resultsArray;
}

@end
