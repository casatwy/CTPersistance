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
        if (*error) {
            *stop = YES;
        }
    }];
}

- (void)updateValue:(id)value forKey:(NSString *)key whereCondition:(NSString *)whereCondition whereConditionParams:(NSDictionary *)whereConditionParams error:(NSError **)error
{
    if (key && value) {
        [self updateKeyValueList:@{key:value} whereCondition:whereCondition whereConditionParams:whereConditionParams error:error];
    }
}

- (void)updateKeyValueList:(NSDictionary *)keyValueList whereCondition:(NSString *)whereCondition whereConditionParams:(NSDictionary *)whereConditionParams error:(NSError **)error
{
    CTPersistanceQueryCommand *queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:[self.child databaseName]];
    [[queryCommand updateTable:[self.child tableName] withData:keyValueList condition:whereCondition conditionParams:whereConditionParams] executeWithError:error];
}

- (void)updateValue:(id)value forKey:(NSString *)key primaryKeyValue:(NSNumber *)primaryKeyValue error:(NSError **)error
{
    if (key && value) {
        NSString *whereCondition = [NSString stringWithFormat:@"%@ = :primaryKeyValue", [self.child primaryKeyName]];
        NSDictionary *whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyValue);
        [self updateKeyValueList:@{key:value} whereCondition:whereCondition whereConditionParams:whereConditionParams error:error];
    }
}

- (void)updateValue:(id)value forKey:(NSString *)key primaryKeyValueList:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error
{
    if (key && value) {
        NSString *primaryKeyValueListString = [primaryKeyValueList componentsJoinedByString:@","];
        NSString *whereCondition = [NSString stringWithFormat:@"%@ IN (:primaryKeyValueListString)", [self.child primaryKeyName]];
        NSDictionary *whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyValueListString);
        [self updateKeyValueList:@{key:value} whereCondition:whereCondition whereConditionParams:whereConditionParams error:error];
    }
}

- (void)updateValue:(id)value forKey:(NSString *)key whereKey:(NSString *)wherekey inList:(NSArray *)keyList error:(NSError *__autoreleasing *)error
{
    if (key && value && wherekey && keyList.count > 0) {
        NSString *keyListString = [keyList componentsJoinedByString:@","];
        NSString *whereCondition = [NSString stringWithFormat:@"%@ IN (:keyListString)", wherekey];
        NSDictionary *whereConditionParams = NSDictionaryOfVariableBindings(keyListString);
        [self updateKeyValueList:@{key:value} whereCondition:whereCondition whereConditionParams:whereConditionParams error:error];
    }
}

- (void)updateKeyValueList:(NSDictionary *)keyValueList primaryKeyValue:(NSNumber *)primaryKeyValue error:(NSError **)error
{
    NSString *whereCondition = [NSString stringWithFormat:@"%@ = :primaryKeyValue", [self.child primaryKeyName]];
    NSDictionary *whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyValue);
    [self updateKeyValueList:keyValueList whereCondition:whereCondition whereConditionParams:whereConditionParams error:error];
}

- (void)updateKeyValueList:(NSDictionary *)keyValueList primaryKeyValueList:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error
{
        NSString *primaryKeyValueListString = [primaryKeyValueList componentsJoinedByString:@","];
        NSString *whereCondition = [NSString stringWithFormat:@"%@ IN (:primaryKeyValueListString)", [self.child primaryKeyName]];
        NSDictionary *whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyValueListString);
    [self updateKeyValueList:keyValueList whereCondition:whereCondition whereConditionParams:whereConditionParams error:error];
}

@end
