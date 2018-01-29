//
//  CTPersistanceTable+Delete.m
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceTable+Delete.h"

#import "CTPersistanceQueryCommand+DataManipulations.h"
#import "NSMutableArray+CTPersistanceBindValue.h"
#import "NSString+Where.h"
#import "NSDictionary+KeyValueBind.h"

@implementation CTPersistanceTable (Delete)

- (void)deleteRecord:(NSObject<CTPersistanceRecordProtocol> *)record error:(NSError *__autoreleasing *)error
{
    [self deleteWithPrimaryKey:[record valueForKey:[self.child primaryKeyName]] error:error];
}

- (void)deleteRecordList:(NSArray<NSObject<CTPersistanceRecordProtocol> *> *)recordList error:(NSError *__autoreleasing *)error
{
    NSMutableArray *primatKeyList = [[NSMutableArray alloc] init];
    [recordList enumerateObjectsUsingBlock:^(NSObject <CTPersistanceRecordProtocol> * _Nonnull record, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *primaryKeyValue = [record valueForKey:[self.child primaryKeyName]];
        if (primaryKeyValue != nil) {
            [primatKeyList addObject:primaryKeyValue];
        }
    }];
    [self deleteWithPrimaryKeyList:primatKeyList error:error];
}

- (void)deleteWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams error:(NSError *__autoreleasing *)error
{
    NSMutableArray *bindValueList = [[NSMutableArray alloc] init];
    NSString *whereString = [whereCondition whereStringWithConditionParams:conditionParams bindValueList:bindValueList];
    [[self.queryCommand deleteTable:self.child.tableName whereString:whereString bindValueList:bindValueList error:error] executeWithError:error];
}

- (void)deleteWithPrimaryKey:(NSNumber *)primaryKeyValue error:(NSError *__autoreleasing *)error
{
    if (primaryKeyValue != nil) {
        NSMutableArray *bindValueList = [[NSMutableArray alloc] init];

        NSString *whereKey = [NSString stringWithFormat:@":CTPersistanceWhere_%@", self.child.primaryKeyName];
        [bindValueList addBindKey:whereKey bindValue:primaryKeyValue];

        NSString *whereString = [NSString stringWithFormat:@"%@ = %@", self.child.primaryKeyName, whereKey];
        [[self.queryCommand deleteTable:self.child.tableName whereString:whereString bindValueList:bindValueList error:error] executeWithError:error];
    }
}

- (void)deleteWithPrimaryKeyList:(NSArray<NSNumber *> *)primaryKeyValueList error:(NSError *__autoreleasing *)error
{
    if ([primaryKeyValueList count] > 0) {
        NSMutableArray *bindValueList = [[NSMutableArray alloc] init];

        NSMutableArray *valueKeyList = [[NSMutableArray alloc] init];
        [primaryKeyValueList enumerateObjectsUsingBlock:^(id  _Nonnull value, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *valueKey = [NSString stringWithFormat:@":CTPersistanceWhere%lu", (unsigned long)idx];
            [valueKeyList addObject:valueKey];
            [bindValueList addBindKey:valueKey bindValue:value];
        }];
        NSString *whereString = [NSString stringWithFormat:@"%@ IN (%@)", self.child.primaryKeyName, [valueKeyList componentsJoinedByString:@","]];

        [[self.queryCommand deleteTable:self.child.tableName whereString:whereString bindValueList:bindValueList error:error] executeWithError:error];
    }
}

- (void)truncate
{
    NSString *sqlString = [NSString stringWithFormat:@"DELETE FROM `%@`;", self.child.tableName];
    [[self.queryCommand compileSqlString:sqlString bindValueList:nil error:NULL] executeWithError:NULL];
    sqlString = [NSString stringWithFormat:@"UPDATE `sqlite_sequence` SET seq = 0 WHERE name = '%@';", self.child.tableName];
    [[self.queryCommand compileSqlString:sqlString bindValueList:nil error:NULL] executeWithError:NULL];
    sqlString = @"VACUUM;";
    [[self.queryCommand compileSqlString:sqlString bindValueList:nil error:NULL] executeWithError:NULL];
}

@end
