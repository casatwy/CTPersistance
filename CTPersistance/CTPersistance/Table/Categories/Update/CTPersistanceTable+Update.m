//
//  CTPersistanceTable+Update.m
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceTable+Update.h"
#import "CTPersistanceQueryCommand+DataManipulations.h"
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
    [[self.queryCommand updateTable:[self.child tableName] withData:keyValueList condition:whereCondition conditionParams:whereConditionParams] executeWithError:error];
}

- (void)updateValue:(id)value forKey:(NSString *)key primaryKeyValue:(NSNumber *)primaryKeyValue error:(NSError **)error
{
    if (key && value) {
        NSString *primaryKeyName = [self.child primaryKeyName];
        NSString *whereCondition = @":primaryKeyName = :primaryKeyValue";
        NSDictionary *whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyName, primaryKeyValue);
        [self updateKeyValueList:@{key:value} whereCondition:whereCondition whereConditionParams:whereConditionParams error:error];
    }
}

- (void)updateValue:(id)value forKey:(NSString *)key primaryKeyValueList:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error
{
    if (key && value) {
        NSString *primaryKeyName = [self.child primaryKeyName];
        NSString *primaryKeyValueListString = [primaryKeyValueList componentsJoinedByString:@","];
        NSString *whereCondition = @":primaryKeyName IN (:primaryKeyValueListString)";
        NSDictionary *whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyName, primaryKeyValueListString);
        [self updateKeyValueList:@{key:value} whereCondition:whereCondition whereConditionParams:whereConditionParams error:error];
    }
}

- (void)updateKeyValueList:(NSDictionary *)keyValueList primaryKeyValue:(NSNumber *)primaryKeyValue error:(NSError **)error
{
    NSString *primaryKeyName = [self.child primaryKeyName];
    NSString *whereCondition = @":primaryKeyName = :primaryKeyValue";
    NSDictionary *whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyName, primaryKeyValue);
    [self updateKeyValueList:keyValueList whereCondition:whereCondition whereConditionParams:whereConditionParams error:error];
}

- (void)updateKeyValueList:(NSDictionary *)keyValueList primaryKeyValueList:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error
{
        NSString *primaryKeyName = [self.child primaryKeyName];
        NSString *primaryKeyValueListString = [primaryKeyValueList componentsJoinedByString:@","];
        NSString *whereCondition = @":primaryKeyName IN (:primaryKeyValueListString)";
        NSDictionary *whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyName, primaryKeyValueListString);
    [self updateKeyValueList:keyValueList whereCondition:whereCondition whereConditionParams:whereConditionParams error:error];
}

@end
