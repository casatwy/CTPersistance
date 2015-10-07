//
//  CTPersistanceTable+Delete.m
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceTable+Delete.h"
#import "NSString+SQL.h"

@implementation CTPersistanceTable (Delete)

- (void)deleteRecord:(NSObject <CTPersistanceRecordProtocol> *)record error:(NSError **)error
{
    [self deleteWithPrimaryKey:[record valueForKey:[self.child primaryKeyName]] error:error];
}

- (void)deleteRecordList:(NSArray <NSObject <CTPersistanceRecordProtocol> *> *)recordList error:(NSError **)error
{
    NSMutableArray *primatKeyList = [[NSMutableArray alloc] init];
    [recordList enumerateObjectsUsingBlock:^(NSObject <CTPersistanceRecordProtocol> * _Nonnull record, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *primaryKeyValue = [record valueForKey:[self.child primaryKeyName]];
        if (primaryKeyValue) {
            [primatKeyList addObject:primaryKeyValue];
        }
    }];
    [self deleteWithPrimaryKeyList:primatKeyList error:error];
}

- (void)deleteWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams error:(NSError **)error
{
    CTPersistanceCriteria *criteria = [[CTPersistanceCriteria alloc] init];
    criteria.whereCondition = whereCondition;
    criteria.whereConditionParams = conditionParams;
    [self deleteWithCriteria:criteria error:error];
}

- (void)deleteWithCriteria:(CTPersistanceCriteria *)criteria error:(NSError **)error
{
    [[criteria applyToDeleteQueryCommand:self.queryCommand tableName:[self.child tableName]] executeWithError:error];
}

- (void)deleteWithSql:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error
{
    NSString *finalSql = [sqlString stringWithSQLParams:params];
    [self.queryCommand resetQueryCommand];
    [self.queryCommand.sqlString appendString:finalSql];
    [self.queryCommand executeWithError:error];
}

- (void)deleteWithPrimaryKey:(NSNumber *)primaryKeyValue error:(NSError **)error
{
    if (primaryKeyValue) {
        NSString *primaryKeyName = [self.child primaryKeyName];
        CTPersistanceCriteria *criteria = [[CTPersistanceCriteria alloc] init];
        criteria.whereCondition = @":primaryKeyName = :primaryKeyValue";
        criteria.whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyName, primaryKeyValue);
        [self deleteWithCriteria:criteria error:error];
    }
}

- (void)deleteWithPrimaryKeyList:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error
{
    if ([primaryKeyValueList count] > 0) {
        NSString *primaryKeyValueListString = [primaryKeyValueList componentsJoinedByString:@","];
        NSString *primaryKeyName = [self.child primaryKeyName];
        CTPersistanceCriteria *criteria = [[CTPersistanceCriteria alloc] init];
        criteria.whereCondition = @":primaryKeyName IN (:primaryKeyValueListString)";
        criteria.whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyName, primaryKeyValueListString);
        [self deleteWithCriteria:criteria error:error];
    }
}

@end
