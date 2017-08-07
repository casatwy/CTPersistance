//
//  CTPersistanceQueryCommand+DataManipulations.m
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceQueryCommand+DataManipulations.h"

#import "CTPersistanceMarcos.h"

#import "NSMutableArray+CTPersistanceBindValue.h"

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
    return [self compileSqlString:sqlString bindValueList:bindValueList error:error];
}

- (CTPersistanceQueryCommand *)updateTable:(NSString *)tableName valueString:(NSString *)valueString whereString:(NSString *)whereString bindValueList:(NSArray <NSInvocation *> *)bindValueList error:(NSError * __autoreleasing *)error
{
    NSString *sqlString = [NSString stringWithFormat:@"UPDATE `%@` SET %@ WHERE %@;", tableName, valueString, whereString];
    return [self compileSqlString:sqlString bindValueList:bindValueList error:error];
}

- (CTPersistanceQueryCommand *)deleteTable:(NSString *)tableName whereString:(NSString *)whereString bindValueList:(NSArray<NSInvocation *> *)bindValueList error:(NSError *__autoreleasing *)error
{
    NSString *sqlString = [NSString stringWithFormat:@"DELETE FROM `%@` WHERE %@", tableName, whereString];
    return [self compileSqlString:sqlString bindValueList:bindValueList error:error];
}

@end
