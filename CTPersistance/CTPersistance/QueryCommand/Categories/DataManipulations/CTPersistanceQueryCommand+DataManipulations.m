//
//  CTPersistanceQueryCommand+DataManipulations.m
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceQueryCommand+DataManipulations.h"

#import "CTPersistanceMarcos.h"
#import "CTPersistanceQueryCommand+ReadMethods.h"
#import "NSMutableArray+CTPersistanceBindValue.h"
#import "CTPersistanceConfiguration.h"

#import <sqlite3.h>

@implementation CTPersistanceQueryCommand (DataManipulations)

- (CTPersistanceQueryCommand *)insertTable:(NSString *)tableName columnInfo:(NSDictionary *)columnInfo dataList:(NSArray *)dataList error:(NSError *__autoreleasing *)error
{
    if (CTPersistance_isEmptyString(tableName) || dataList == nil) {
        return self;
    }

    NSMutableArray *valueItemList = [[NSMutableArray alloc] init];
    NSMutableArray *columnList = [[NSMutableArray alloc] init];
    NSMutableArray <NSInvocation *> *bindValueList = [[NSMutableArray alloc] init];

    [dataList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull recordData, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *valueList = [[NSMutableArray alloc] init];
        [recordData enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull columnName, NSString * _Nonnull columnValue, BOOL * _Nonnull stop) {
            if ([columnList containsObject:columnName] == NO) {
                [columnList addObject:columnName];
            }
            NSString *valueKey = [NSString stringWithFormat:@":%@%lu", columnName, (unsigned long)idx];
            [valueList addObject:valueKey];
            [bindValueList addBindKey:valueKey bindValue:columnValue columnDescription:columnInfo[columnName]];
        }];
        [valueItemList addObject:[NSString stringWithFormat:@"(%@)", [valueList componentsJoinedByString:@","]]];
    }];

    NSString *sqlString = [NSString stringWithFormat:@"INSERT INTO `%@` (%@) VALUES %@;", tableName, [columnList componentsJoinedByString:@","], [valueItemList componentsJoinedByString:@","]];
    sqlite3_stmt *statement = nil;
    int result = sqlite3_prepare_v2(self.database.database, [sqlString UTF8String], (int)sqlString.length, &statement, NULL);

    
    if (result != SQLITE_OK) {
        NSString *errorMessage = [NSString stringWithUTF8String:sqlite3_errmsg(self.database.database)];
        NSError *generatedError = [NSError errorWithDomain:kCTPersistanceErrorDomain code:CTPersistanceErrorCodeQueryStringError userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"\n======================\nQuery Error: \n Origin Query is : %@\n Error Message is: %@\n======================\n", sqlString, errorMessage]}];
        *error = generatedError;
        NSLog(@"error is %@", errorMessage);
        sqlite3_finalize(statement);
        return self;
    }
    self.statement = statement;

    [bindValueList enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull bindInvocation, NSUInteger idx, BOOL * _Nonnull stop) {
        [bindInvocation setArgument:(void *)&statement atIndex:2];
        [bindInvocation invoke];
    }];

    return self;
}

- (CTPersistanceQueryCommand *)updateTable:(NSString *)tableName valueString:(NSString *)valueString whereString:(NSString *)whereString bindValueList:(NSArray <NSInvocation *> *)bindValueList error:(NSError * __autoreleasing *)error
{
    NSString *sqlString = [NSString stringWithFormat:@"UPDATE `%@` SET %@ WHERE %@;", tableName, valueString, whereString];
    sqlite3_stmt *statement = nil;
    int result = sqlite3_prepare_v2(self.database.database, [sqlString UTF8String], (int)sqlString.length, &statement, NULL);

    if (result != SQLITE_OK) {
        self.statement = nil;
        NSString *errorMessage = [NSString stringWithUTF8String:sqlite3_errmsg(self.database.database)];
        NSError *generatedError = [NSError errorWithDomain:kCTPersistanceErrorDomain code:CTPersistanceErrorCodeQueryStringError userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"\n======================\nQuery Error: \n Origin Query is : %@\n Error Message is: %@\n======================\n", sqlString, errorMessage]}];
        *error = generatedError;
        NSLog(@"error is %@", errorMessage);
        sqlite3_finalize(statement);
        return self;
    }
    self.statement = statement;

    [bindValueList enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull bindInvocation, NSUInteger idx, BOOL * _Nonnull stop) {
        [bindInvocation setArgument:(void *)&statement atIndex:2];
        [bindInvocation invoke];
    }];

    return self;
}

- (CTPersistanceQueryCommand *)deleteTable:(NSString *)tableName whereString:(NSString *)whereString bindValueList:(NSArray<NSInvocation *> *)bindValueList error:(NSError *__autoreleasing *)error
{
    NSString *sqlString = [NSString stringWithFormat:@"DELETE FROM `%@` WHERE %@", tableName, whereString];
    sqlite3_stmt *statement = nil;
    int result = sqlite3_prepare_v2(self.database.database, [sqlString UTF8String], (int)sqlString.length, &statement, NULL);

    if (result != SQLITE_OK) {
        self.statement = nil;
        NSString *errorMessage = [NSString stringWithUTF8String:sqlite3_errmsg(self.database.database)];
        NSError *generatedError = [NSError errorWithDomain:kCTPersistanceErrorDomain code:CTPersistanceErrorCodeQueryStringError userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"\n======================\nQuery Error: \n Origin Query is : %@\n Error Message is: %@\n======================\n", sqlString, errorMessage]}];
        *error = generatedError;
        NSLog(@"error is %@", errorMessage);
        sqlite3_finalize(statement);
        return self;
    }
    self.statement = statement;

    [bindValueList enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull bindInvocation, NSUInteger idx, BOOL * _Nonnull stop) {
        [bindInvocation setArgument:(void *)&statement atIndex:2];
        [bindInvocation invoke];
    }];

    return self;
}

- (CTPersistanceQueryCommand *)truncateTable:(NSString *)tableName
{
    NSString *sqlString = [NSString stringWithFormat:@"DELETE FROM `%@`;", tableName];
    sqlite3_stmt *statement = nil;
    sqlite3_prepare_v2(self.database.database, [sqlString UTF8String], (int)sqlString.length, &statement, NULL);
    self.statement = statement;
    return self;
}

@end
