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
#import "NSDictionary+KeyValueBind.h"
#import "NSString+Where.h"

@implementation CTPersistanceTable (Update)

- (void)updateRecord:(NSObject <CTPersistanceRecordProtocol> *)record error:(NSError **)error
{
    [self updateKeyValueList:[record dictionaryRepresentationWithTable:self.child] primaryKeyValue:[record valueForKey:[self.child primaryKeyName]] error:error];
}

- (void)updateRecordList:(NSArray <NSObject <CTPersistanceRecordProtocol> *> *)recordList error:(NSError * __autoreleasing *)error
{
    for (id<CTPersistanceRecordProtocol> record in recordList) {
        [self updateRecord:record error:error];

        if (error != NULL && *error != nil) {
            return;
        }
    }
}

- (void)updateValue:(id)value forKey:(NSString *)key whereCondition:(NSString *)whereCondition whereConditionParams:(NSDictionary *)whereConditionParams error:(NSError **)error
{
    if (key) {
        [self updateKeyValueList:@{key:value} whereCondition:whereCondition whereConditionParams:whereConditionParams error:error];
    }
}

- (void)updateKeyValueList:(NSDictionary *)keyValueList whereCondition:(NSString *)whereCondition whereConditionParams:(NSDictionary *)whereConditionParams error:(NSError **)error
{
    NSMutableArray <NSInvocation *> *bindValueList = [[NSMutableArray alloc] init];

    // default value setting
    keyValueList = [self defaultValueProcessBeforeUpdate:keyValueList];
    NSString *valueString = [keyValueList bindToUpdateValueList:bindValueList];
    NSString *whereString = [whereCondition whereStringWithConditionParams:whereConditionParams bindValueList:bindValueList];

    [[self.queryCommand updateTable:self.child.tableName valueString:valueString whereString:whereString bindValueList:bindValueList error:error] executeWithError:error];
}

- (void)updateValue:(id)value forKey:(NSString *)key primaryKeyValue:(NSNumber *)primaryKeyValue error:(NSError **)error
{
    // default value setting
    if (!value) {
        value = [NSNull null];
    }

    if(self.child.columnDetaultValue && value == [NSNull null]  ) {
        id defaultVale = [self.child.columnDetaultValue valueForKey:key];

        if(defaultVale) {
            value = defaultVale;
        }
    }

    if (key && primaryKeyValue) {
        NSMutableArray *bindValueArray = [[NSMutableArray alloc] init];

        NSString *whereKey = [NSString stringWithFormat:@":CTPersistanceWhere_%@", self.child.primaryKeyName];
        NSString *whereString = [NSString stringWithFormat:@"%@ = %@", self.child.primaryKeyName, whereKey];
        [bindValueArray addBindKey:whereKey bindValue:primaryKeyValue];

        NSString *valueKey = [NSString stringWithFormat:@":%@", key];

        NSString *valueString = [NSString stringWithFormat:@"%@ = %@", key, valueKey];
        [bindValueArray addBindKey:valueKey bindValue:value];

        [[self.queryCommand updateTable:self.child.tableName valueString:valueString whereString:whereString bindValueList:bindValueArray error:error] executeWithError:error];
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
    // default value setting
    if (!value) {
        value = [NSNull null];
    }

    if(self.child.columnDetaultValue && value == [NSNull null]  ) {
        id defaultVale = [self.child.columnDetaultValue valueForKey:key];

        if(defaultVale) {
            value = defaultVale;
        }
    }

    if (key && wherekey && valueList.count > 0) {
        NSMutableArray *bindValueList = [[NSMutableArray alloc] init];

        NSString *valueKey = [NSString stringWithFormat:@":%@", key];
        
        NSString *valueString = nil;
        valueString = [NSString stringWithFormat:@"%@ = %@", key, valueKey];

        [bindValueList addBindKey:valueKey bindValue:value];

        NSMutableArray *valueKeyList = [[NSMutableArray alloc] init];
        [valueList enumerateObjectsUsingBlock:^(id  _Nonnull value, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *valueKey = [NSString stringWithFormat:@":CTPersistanceWhere%lu_", (unsigned long)idx];
            [valueKeyList addObject:valueKey];
            [bindValueList addBindKey:valueKey bindValue:value];
        }];
        NSString *whereString = [NSString stringWithFormat:@"%@ IN (%@)", wherekey, [valueKeyList componentsJoinedByString:@","]];

        [[self.queryCommand updateTable:self.child.tableName valueString:valueString whereString:whereString bindValueList:bindValueList error:error] executeWithError:error];
    }
}

- (void)updateKeyValueList:(NSDictionary *)keyValueList primaryKeyValue:(NSNumber *)primaryKeyValue error:(NSError **)error
{
    if (primaryKeyValue == nil) {
        return;
    }

    NSMutableArray *bindValueList = [[NSMutableArray alloc] init];

    // default value setting
    keyValueList = [self defaultValueProcessBeforeUpdate:keyValueList];
    NSString *valueString = [keyValueList bindToUpdateValueList:bindValueList];

    NSString *whereKey = [NSString stringWithFormat:@":CTPersistanceWhere_%@", self.child.primaryKeyName];
    NSString *whereCondition = [NSString stringWithFormat:@"%@ = %@", self.child.primaryKeyName, whereKey];
    [bindValueList addBindKey:whereKey bindValue:primaryKeyValue];

    [[self.queryCommand updateTable:self.child.tableName valueString:valueString whereString:whereCondition bindValueList:bindValueList error:error] executeWithError:error];
}

- (void)updateKeyValueList:(NSDictionary *)keyValueList primaryKeyValueList:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error
{
    NSMutableArray *bindValueList = [[NSMutableArray alloc] init];

    keyValueList = [self defaultValueProcessBeforeUpdate:keyValueList];
    NSString *valueString = [keyValueList bindToUpdateValueList:bindValueList];

    NSMutableArray *valueKeyList = [[NSMutableArray alloc] init];
    [primaryKeyValueList enumerateObjectsUsingBlock:^(id  _Nonnull value, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *valueKey = [NSString stringWithFormat:@":CTPersistanceWhere%lu_", (unsigned long)idx];
        [valueKeyList addObject:valueKey];
        [bindValueList addBindKey:valueKey bindValue:value];
    }];
    NSString *whereString = [NSString stringWithFormat:@"%@ IN (%@)", self.child.primaryKeyName, [valueKeyList componentsJoinedByString:@","]];
    
    [[self.queryCommand updateTable:self.child.tableName valueString:valueString whereString:whereString bindValueList:bindValueList error:error] executeWithError:error];
}

- (NSDictionary *)defaultValueProcessBeforeUpdate:(NSDictionary *)keyValueList {
    if(!self.child.columnDetaultValue) {
        return keyValueList;
    }

    NSMutableDictionary *dictionaryRepresentation = [[NSMutableDictionary alloc] init];

    [keyValueList enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull columnName, NSString * _Nonnull columnDescription, BOOL * _Nonnull stop) {
       
        if(!keyValueList[columnName]) {
            dictionaryRepresentation[columnName] = [NSNull null];
        } else {
            dictionaryRepresentation[columnName] = keyValueList[columnName];
        }


        if (dictionaryRepresentation[columnName] != [NSNull null]) {
            return;
        }

        //setting default value
        if(self.child.columnDetaultValue) {
            id defaultValue = [self.child.columnDetaultValue valueForKey:columnName];

            if(defaultValue) {
                dictionaryRepresentation[columnName] = defaultValue;
            }
        }
    }];

    return dictionaryRepresentation;
}

@end
