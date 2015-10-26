//
//  CTPersistanceTable+Find.m
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceTable+Find.h"
#import "NSString+SQL.h"
#import "CTPersistanceQueryCommand+ReadMethods.h"
#import "NSArray+CTPersistanceRecordTransform.h"
#import <UIKit/UIKit.h>
#import "CTPersistanceConfiguration.h"

@implementation CTPersistanceTable (Find)

- (NSObject<CTPersistanceRecordProtocol> *)findLatestRecordWithError:(NSError *__autoreleasing *)error
{
    CTPersistanceCriteria *criteria = [[CTPersistanceCriteria alloc] init];
    criteria.isDistinct = NO;
    criteria.orderBy = [self.child primaryKeyName];
    criteria.isDESC = YES;
    criteria.limit = 1;
    return [self findFirstRowWithCriteria:criteria error:error];
}

- (NSArray <NSObject <CTPersistanceRecordProtocol> *> *)findAllWithWhereCondition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams isDistinct:(BOOL)isDistinct error:(NSError **)error
{
    CTPersistanceCriteria *criteria = [[CTPersistanceCriteria alloc] init];
    criteria.isDistinct = isDistinct;
    criteria.whereCondition = condition;
    criteria.whereConditionParams = conditionParams;
    return [self findAllWithCriteria:criteria error:error];
}

- (NSArray <NSObject <CTPersistanceRecordProtocol> *> *)findAllWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error
{
    if (sqlString == nil) {
        return @[];
    }
    NSString *finalString = [sqlString stringWithSQLParams:params];
    [self.queryCommand resetQueryCommand];
    [self.queryCommand.sqlString appendString:finalString];
    NSArray *fetchedResult = [self.queryCommand fetchWithError:error];
    return [fetchedResult transformSQLItemsToClass:[self.child recordClass]];
}

- (NSArray <NSObject <CTPersistanceRecordProtocol> *> *)findAllWithCriteria:(CTPersistanceCriteria *)criteria error:(NSError **)error
{
    [criteria applyToSelectQueryCommand:self.queryCommand tableName:[self.child tableName]];
    NSArray *fetchedResult = [self.queryCommand fetchWithError:error];
    return [fetchedResult transformSQLItemsToClass:[self.child recordClass]];
}

- (NSObject <CTPersistanceRecordProtocol> *)findFirstRowWithWhereCondition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams isDistinct:(BOOL)isDistinct error:(NSError **)error
{
    CTPersistanceCriteria *criteria = [[CTPersistanceCriteria alloc] init];
    criteria.isDistinct = isDistinct;
    criteria.whereCondition = condition;
    criteria.whereConditionParams = conditionParams;
    criteria.limit = 1;
    return [self findFirstRowWithCriteria:criteria error:error];
}

- (NSObject <CTPersistanceRecordProtocol> *)findFirstRowWithCriteria:(CTPersistanceCriteria *)criteria error:(NSError **)error
{
    criteria.limit = 1;
    return [[[[criteria applyToSelectQueryCommand:self.queryCommand tableName:[self.child tableName]] fetchWithError:error] transformSQLItemsToClass:[self.child recordClass]] firstObject];
}

- (NSObject <CTPersistanceRecordProtocol> *)findFirstRowWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error
{
    NSString *finalString = [sqlString stringWithSQLParams:params];
    [self.queryCommand resetQueryCommand];
    finalString = [finalString stringByReplacingOccurrencesOfString:@";" withString:@""];
    [self.queryCommand.sqlString appendFormat:@"%@ ", finalString];
    [self.queryCommand limit:1];
    return [[[self.queryCommand fetchWithError:error] transformSQLItemsToClass:[self.child recordClass]] firstObject];
}

- (NSNumber *)countTotalRecord
{
    NSString *sqlString = [NSString stringWithFormat:@"SELECT COUNT(*) as count FROM %@", self.child.tableName];
    NSDictionary *countResult = [self countWithSQL:sqlString params:nil error:NULL];
    return countResult[@"count"];
}

- (NSNumber *)countWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams error:(NSError **)error
{
    NSString *sqlString = @"SELECT COUNT(*) AS count FROM :tableName WHERE :whereString;";
    NSString *whereString = [whereCondition stringWithSQLParams:conditionParams];
    NSString *tableName = self.child.tableName;
    NSDictionary *params = NSDictionaryOfVariableBindings(whereString, tableName);
    NSDictionary *countResult = [self countWithSQL:sqlString params:params error:NULL];
    return countResult[@"count"];
}

- (NSDictionary *)countWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error
{
    NSString *finalString = [sqlString stringWithSQLParams:params];
    [self.queryCommand resetQueryCommand];
    [self.queryCommand.sqlString appendString:finalString];
    return [[self.queryCommand fetchWithError:NULL] firstObject];
}

- (NSObject <CTPersistanceRecordProtocol> *)findWithPrimaryKey:(NSNumber *)primaryKeyValue error:(NSError **)error
{
    if (primaryKeyValue == nil) {
        if (error) {
            *error = [NSError errorWithDomain:kCTPersistanceErrorDomain
                                         code:CTPersistanceErrorCodeQueryStringError
                                     userInfo:@{NSLocalizedDescriptionKey:@"primaryKeyValue or primaryKeyValue is nil"}];
        }
        return nil;
    }
    
    CTPersistanceCriteria *criteria = [[CTPersistanceCriteria alloc] init];
    criteria.whereCondition = [NSString stringWithFormat:@"%@ = :primaryKeyValue", [self.child primaryKeyName]];
    criteria.whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyValue);
    return [self findFirstRowWithCriteria:criteria error:error];
}

- (NSArray <NSObject <CTPersistanceRecordProtocol> *> *)findAllWithPrimaryKey:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error
{
    NSString *primaryKeyValueListString = [primaryKeyValueList componentsJoinedByString:@","];
    CTPersistanceCriteria *criteria = [[CTPersistanceCriteria alloc] init];
    criteria.whereCondition = [NSString stringWithFormat:@"%@ IN (:primaryKeyValueListString)", [self.child primaryKeyName]];
    criteria.whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyValueListString);
    return [self findAllWithCriteria:criteria error:error];
}

@end
