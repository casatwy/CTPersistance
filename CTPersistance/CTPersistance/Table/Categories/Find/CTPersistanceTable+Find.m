//
//  CTPersistanceTable+Find.m
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceTable+Find.h"

#import "CTPersistanceConfiguration.h"

#import "NSArray+CTPersistanceRecordTransform.h"
#import "NSMutableArray+CTPersistanceBindValue.h"
#import "NSDictionary+KeyValueBind.h"
#import "NSString+Where.h"

#import "CTPersistanceQueryCommand+SchemaManipulations.h"

@implementation CTPersistanceTable (Find)

- (NSArray <NSObject<CTPersistanceRecordProtocol> *> *)findAllWithError:(NSError *__autoreleasing *)error
{
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM `%@`;", self.child.tableName];
    return [[[self.queryCommand compileSqlString:sqlString bindValueList:NULL error:error] fetchWithError:error] transformSQLItemsToClass:self.child.recordClass];
}

- (NSObject<CTPersistanceRecordProtocol> *)findLatestRecordWithError:(NSError *__autoreleasing *)error
{
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM `%@` ORDER BY %@ DESC LIMIT 1;", self.child.tableName, self.child.primaryKeyName];
    return [[[[self.queryCommand compileSqlString:sqlString bindValueList:NULL error:error] fetchWithError:error] transformSQLItemsToClass:self.child.recordClass] firstObject];
}

- (NSArray <NSObject <CTPersistanceRecordProtocol> *> *)findAllWithWhereCondition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams isDistinct:(BOOL)isDistinct error:(NSError **)error
{
    NSMutableArray *bindValueList = [[NSMutableArray alloc] init];

    NSString *whereString = [condition whereStringWithConditionParams:conditionParams bindValueList:bindValueList];

    NSString *sqlString = nil;
    if (isDistinct) {
        sqlString = [NSString stringWithFormat:@"SELECT DISTINCT * FROM `%@` WHERE %@", self.child.tableName, whereString];
    } else {
        sqlString = [NSString stringWithFormat:@"SELECT * FROM `%@` WHERE %@", self.child.tableName, whereString];
    }

    return [[[self.queryCommand compileSqlString:sqlString bindValueList:bindValueList error:error] fetchWithError:error] transformSQLItemsToClass:self.child.recordClass];
}

- (NSArray <NSObject <CTPersistanceRecordProtocol> *> *)findAllWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error
{
    NSMutableArray *bindValueList = [[NSMutableArray alloc] init];
    [params enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        [bindValueList addBindKey:key bindValue:value];
    }];

    return [[[self.queryCommand compileSqlString:sqlString bindValueList:bindValueList error:error] fetchWithError:error] transformSQLItemsToClass:self.child.recordClass];
}

- (NSObject <CTPersistanceRecordProtocol> *)findFirstRowWithWhereCondition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams isDistinct:(BOOL)isDistinct error:(NSError **)error
{
    NSMutableArray *bindValueList = [[NSMutableArray alloc] init];

    NSString *whereString = [condition whereStringWithConditionParams:conditionParams bindValueList:bindValueList];

    NSString *sqlString = nil;
    if (isDistinct) {
        sqlString = [NSString stringWithFormat:@"SELECT DISTINCT * FROM `%@` WHERE %@ LIMIT 1;", self.child.tableName, whereString];
    } else {
        sqlString = [NSString stringWithFormat:@"SELECT * FROM `%@` WHERE %@ LIMIT 1;", self.child.tableName, whereString];
    }

    return [[[[self.queryCommand compileSqlString:sqlString bindValueList:bindValueList error:error] fetchWithError:error] transformSQLItemsToClass:self.child.recordClass] firstObject];
}

- (NSObject <CTPersistanceRecordProtocol> *)findFirstRowWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error
{
    return [[self findAllWithSQL:sqlString params:params error:error] firstObject];
}

- (NSInteger)countTotalRecord
{
    NSString *sqlString = [NSString stringWithFormat:@"SELECT COUNT(*) AS count FROM %@;", self.child.tableName];
    return [self countWithSQL:sqlString params:nil error:NULL];
}

- (NSInteger)countWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams error:(NSError **)error
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

    NSMutableString *whereString = [whereCondition mutableCopy];
    [conditionParams enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        NSMutableString *valueKey = [key mutableCopy];
        [valueKey deleteCharactersInRange:NSMakeRange(0, 1)];
        [valueKey insertString:@":CTPersistanceWhere_" atIndex:0];
        [whereString replaceOccurrencesOfString:key withString:valueKey options:0 range:NSMakeRange(0, whereString.length)];
        params[valueKey] = value;
    }];

    NSString *sqlString = [NSString stringWithFormat:@"SELECT COUNT(*) AS count FROM %@ WHERE %@;", self.child.tableName, whereString];
    return [self countWithSQL:sqlString params:params error:error];
}

- (NSInteger)countWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error
{
    NSMutableArray *bindValueList = [[NSMutableArray alloc] init];
    [params enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id _Nonnull value, BOOL * _Nonnull stop) {
        [bindValueList addBindKey:key bindValue:value];
    }];

    NSArray *result = [[self.queryCommand compileSqlString:sqlString bindValueList:bindValueList error:error] fetchWithError:error];
    return [[result firstObject][@"count"] integerValue];
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

    NSString *valueKey = @":primaryValue";
    NSMutableArray *bindValueList = [[NSMutableArray alloc] init];
    [bindValueList addBindKey:valueKey bindValue:primaryKeyValue];

    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM `%@` WHERE %@ = %@ LIMIT 1;", self.child.tableName, self.child.primaryKeyName, valueKey];

    return [[[[self.queryCommand compileSqlString:sqlString bindValueList:bindValueList error:error] fetchWithError:error] transformSQLItemsToClass:self.child.recordClass] firstObject];
}

- (NSArray <NSObject <CTPersistanceRecordProtocol> *> *)findAllWithPrimaryKey:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error
{
    return [self findAllWithKeyName:self.child.primaryKeyName inValueList:primaryKeyValueList error:NULL];
}

- (NSArray<NSObject<CTPersistanceRecordProtocol> *> *)findAllWithKeyName:(NSString *)keyname value:(id)value error:(NSError *__autoreleasing *)error
{
    if (keyname && value) {
        return [self findAllWithWhereCondition:[NSString stringWithFormat:@"%@ = :%@", keyname, keyname]
                               conditionParams:@{[NSString stringWithFormat:@":%@", keyname]:value}
                                    isDistinct:NO
                                         error:error];
    }
    return nil;
}

- (NSArray<NSObject<CTPersistanceRecordProtocol> *> *)findAllWithKeyName:(NSString *)keyname
                                                             inValueList:(NSArray *)valueList
                                                                   error:(NSError *__autoreleasing *)error
{
    if (keyname.length == 0 || valueList.count == 0) {
        return @[];
    }
    
    NSMutableArray *bindValueList = [[NSMutableArray alloc] init];
    NSMutableArray *valueKeyList = [[NSMutableArray alloc] init];
    
    [valueList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull value, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *valueKey = [NSString stringWithFormat:@":CTPersistanceWhereKey%lu", (unsigned long)idx];
        [valueKeyList addObject:valueKey];
        [bindValueList addBindKey:valueKey bindValue:value];
    }];
    
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM `%@` WHERE %@ IN (%@);", self.child.tableName, keyname, [valueKeyList componentsJoinedByString:@","]];
    
    return [[[self.queryCommand compileSqlString:sqlString bindValueList:bindValueList error:error] fetchWithError:error] transformSQLItemsToClass:self.child.recordClass];
}

@end
