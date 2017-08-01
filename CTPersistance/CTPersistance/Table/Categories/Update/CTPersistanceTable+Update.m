//
//  CTPersistanceTable+Update.m
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceTable+Update.h"
#import "CTPersistanceQueryCommand+DataManipulations.h"
#import "CTPersistanceQueryCommand+SchemaManipulations.h"
#import "NSMutableArray+CTPersistanceBindValue.h"
#import <UIKit/UIKit.h>

@implementation CTPersistanceTable (Update)

- (void)updateRecord:(NSObject <CTPersistanceRecordProtocol> *)record error:(NSError **)error
{
    [self updateKeyValueList:[record dictionaryRepresentationWithTable:self.child] primaryKeyValue:[record valueForKey:[self.child primaryKeyName]] error:error];
}

- (void)updateRecordList:(NSArray <NSObject <CTPersistanceRecordProtocol> *> *)recordList error:(NSError **)error
{
    [recordList enumerateObjectsUsingBlock:^(NSObject <CTPersistanceRecordProtocol> * _Nonnull record, NSUInteger idx, BOOL * _Nonnull stop) {
        [self updateRecord:record error:error];
        if (*error != nil) {
            *stop = YES;
        }
    }];
}

- (void)updateValue:(id)value forKey:(NSString *)key whereCondition:(NSString *)whereCondition whereConditionParams:(NSDictionary *)whereConditionParams error:(NSError **)error
{
    if (key) {
        [self updateKeyValueList:@{key:value} whereCondition:whereCondition whereConditionParams:whereConditionParams error:error];
    }
}

- (void)updateKeyValueList:(NSDictionary *)keyValueList whereCondition:(NSString *)whereCondition whereConditionParams:(NSDictionary *)whereConditionParams error:(NSError **)error
{
    CTPersistanceQueryCommand *queryCommand = self.queryCommand;
    if (self.isFromMigration == NO) {
        queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:[self.child databaseName]];
    }

    NSMutableArray *bindValueList = [[NSMutableArray alloc] init];
    
    NSMutableArray *valueList = [[NSMutableArray alloc] init];
    [keyValueList enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        NSString *valueKey = [NSString stringWithFormat:@":%@", key];
        [valueList addObject:[NSString stringWithFormat:@"%@ = %@", key, valueKey]];
        [bindValueList addBindKey:valueKey bindValue:value columnDescription:self.child.columnInfo[key]];
    }];

    NSMutableString *whereString = [whereCondition mutableCopy];
    [whereConditionParams enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        NSMutableString *valueKey = [key mutableCopy];
        [valueKey deleteCharactersInRange:NSMakeRange(0, 1)];
        [valueKey insertString:@":CTPersistanceWhere" atIndex:0];
        [whereString replaceOccurrencesOfString:key withString:valueKey options:0 range:NSMakeRange(0, whereString.length)];
        [bindValueList addBindKey:valueKey bindValue:value columnDescription:nil];
    }];

    [[queryCommand updateTable:self.child.tableName valueString:[valueList componentsJoinedByString:@","] whereString:whereString bindValueList:bindValueList error:error] executeWithError:error];
}

- (void)updateValue:(id)value forKey:(NSString *)key primaryKeyValue:(NSNumber *)primaryKeyValue error:(NSError **)error
{
    if (key && primaryKeyValue) {
        CTPersistanceQueryCommand *queryCommand = self.queryCommand;
        if (self.isFromMigration == NO) {
            queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:[self.child databaseName]];
        }

        NSMutableArray *bindValueArray = [[NSMutableArray alloc] init];

        NSString *whereKey = [NSString stringWithFormat:@":CTPersistanceWhere%@", self.child.primaryKeyName];
        NSString *whereString = [NSString stringWithFormat:@"%@ = %@", self.child.primaryKeyName, whereKey];
        [bindValueArray addBindKey:whereKey bindValue:primaryKeyValue columnDescription:self.child.columnInfo[self.child.primaryKeyName]];

        NSString *valueKey = [NSString stringWithFormat:@":%@", key];
        NSString *valueString = [NSString stringWithFormat:@"%@ = %@", key, valueKey];
        [bindValueArray addBindKey:valueKey bindValue:value columnDescription:self.child.columnInfo[key]];

        [[queryCommand updateTable:self.child.tableName valueString:valueString whereString:whereString bindValueList:bindValueArray error:error] executeWithError:error];
    }
}

- (void)updateValue:(id)value forKey:(NSString *)key primaryKeyValueList:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error
{
    if (key) {
        [self updateValue:value forKey:key whereKey:self.child.primaryKeyName inList:primaryKeyValueList error:error];
    }
}

- (void)updateValue:(id)value forKey:(NSString *)key whereKey:(NSString *)wherekey inList:(NSArray *)valueList error:(NSError *__autoreleasing *)error
{
    if (key && wherekey && valueList.count > 0) {
        CTPersistanceQueryCommand *queryCommand = self.queryCommand;
        if (self.isFromMigration == NO) {
            queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:[self.child databaseName]];
        }

        NSMutableArray *bindValueList = [[NSMutableArray alloc] init];

        NSString *valueKey = [NSString stringWithFormat:@":%@", key];
        NSString *valueString = [NSString stringWithFormat:@"%@ = %@", key, valueKey];
        [bindValueList addBindKey:valueKey bindValue:value columnDescription:self.child.columnInfo[key]];

        NSMutableArray *valueKeyList = [[NSMutableArray alloc] init];
        [valueList enumerateObjectsUsingBlock:^(id  _Nonnull value, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *valueKey = [NSString stringWithFormat:@":CTPersistanceWhere%lu", (unsigned long)idx];
            [valueKeyList addObject:valueKey];
            [bindValueList addBindKey:valueKey bindValue:value columnDescription:self.child.columnInfo[wherekey]];
        }];
        NSString *whereString = [NSString stringWithFormat:@"%@ IN (%@)", wherekey, [valueKeyList componentsJoinedByString:@","]];

        [[queryCommand updateTable:self.child.tableName valueString:valueString whereString:whereString bindValueList:bindValueList error:error] executeWithError:error];
    }
}

- (void)updateKeyValueList:(NSDictionary *)keyValueList primaryKeyValue:(NSNumber *)primaryKeyValue error:(NSError **)error
{
    if (primaryKeyValue == nil) {
        return;
    }
    CTPersistanceQueryCommand *queryCommand = self.queryCommand;
    if (self.isFromMigration == NO) {
        queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:[self.child databaseName]];
    }

    NSMutableArray *bindValueList = [[NSMutableArray alloc] init];

    NSMutableArray *valueList = [[NSMutableArray alloc] init];
    [keyValueList enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id _Nonnull value, BOOL * _Nonnull stop) {
        NSString *bindValueKey = [NSString stringWithFormat:@":%@", key];
        [valueList addObject:[NSString stringWithFormat:@"%@ = %@", key, bindValueKey]];
        [bindValueList addBindKey:bindValueKey bindValue:value columnDescription:self.child.columnInfo[key]];
    }];
    NSString *valueString = [valueList componentsJoinedByString:@","];

    NSString *whereKey = [NSString stringWithFormat:@":CTPersistanceWhere%@", self.child.primaryKeyName];
    NSString *whereCondition = [NSString stringWithFormat:@"%@ = %@", self.child.primaryKeyName, whereKey];
    [bindValueList addBindKey:whereKey bindValue:primaryKeyValue columnDescription:self.child.columnInfo[self.child.primaryKeyName]];

    [[queryCommand updateTable:self.child.tableName valueString:valueString whereString:whereCondition bindValueList:bindValueList error:error] executeWithError:error];
}

- (void)updateKeyValueList:(NSDictionary *)keyValueList primaryKeyValueList:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error
{
    CTPersistanceQueryCommand *queryCommand = self.queryCommand;
    if (self.isFromMigration == NO) {
        queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:[self.child databaseName]];
    }

    NSMutableArray *bindValueList = [[NSMutableArray alloc] init];

    NSMutableArray *valueList = [[NSMutableArray alloc] init];
    [keyValueList enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id _Nonnull value, BOOL * _Nonnull stop) {
        NSString *bindValueKey = [NSString stringWithFormat:@":%@", key];
        [valueList addObject:[NSString stringWithFormat:@"%@ = %@", key, bindValueKey]];
        [bindValueList addBindKey:bindValueKey bindValue:value columnDescription:self.child.columnInfo[key]];
    }];
    NSString *valueString = [valueList componentsJoinedByString:@","];

    NSMutableArray *valueKeyList = [[NSMutableArray alloc] init];
    [primaryKeyValueList enumerateObjectsUsingBlock:^(id  _Nonnull value, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *valueKey = [NSString stringWithFormat:@":CTPersistanceWhere%lu", (unsigned long)idx];
        [valueKeyList addObject:valueKey];
        [bindValueList addBindKey:valueKey bindValue:value columnDescription:self.child.columnInfo[self.child.primaryKeyName]];
    }];
    NSString *whereString = [NSString stringWithFormat:@"%@ IN (%@)", self.child.primaryKeyName, [valueKeyList componentsJoinedByString:@","]];
    
    [[queryCommand updateTable:self.child.tableName valueString:valueString whereString:whereString bindValueList:bindValueList error:error] executeWithError:error];
}

@end
