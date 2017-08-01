//
//  CTPersistanceTable+Find.m
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceTable+Find.h"

#import "CTPersistanceConfiguration.h"
#import "CTPersistanceCriteria.h"
#import <UIKit/UIKit.h>

#import "NSArray+CTPersistanceRecordTransform.h"
#import "NSMutableArray+CTPersistanceBindValue.h"

#import "CTPersistanceQueryCommand+SchemaManipulations.h"
#import "CTPersistanceQueryCommand+ReadMethods.h"

@implementation CTPersistanceTable (Find)

- (NSObject<CTPersistanceRecordProtocol> *)findLatestRecordWithError:(NSError *__autoreleasing *)error
{
    CTPersistanceQueryCommand *queryCommand = self.queryCommand;
    if (self.isFromMigration == NO) {
        queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:[self.child databaseName]];
    }
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM `%@` ORDER BY %@ DESC LIMIT 1;", self.child.tableName, self.child.primaryKeyName];
    return [[[[queryCommand readWithSQL:sqlString bindValueList:nil error:error] fetchWithError:error] transformSQLItemsToClass:self.child.recordClass] firstObject];
}

- (NSArray <NSObject <CTPersistanceRecordProtocol> *> *)findAllWithWhereCondition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams isDistinct:(BOOL)isDistinct error:(NSError **)error
{
    NSMutableArray *bindValueList = [[NSMutableArray alloc] init];

    NSMutableString *whereString = [condition mutableCopy];
    [conditionParams enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        NSMutableString *valueKey = [key mutableCopy];
        [valueKey deleteCharactersInRange:NSMakeRange(0, 1)];
        [valueKey insertString:@":CTPersistanceWhere" atIndex:0];
        [whereString replaceOccurrencesOfString:key withString:valueKey options:0 range:NSMakeRange(0, whereString.length)];
        [bindValueList addBindKey:valueKey bindValue:value columnDescription:nil];
    }];

    NSString *sqlString = nil;
    if (isDistinct) {
        sqlString = [NSString stringWithFormat:@"SELECT DISTINCT * FROM `%@` WHERE %@", self.child.tableName, whereString];
    } else {
        sqlString = [NSString stringWithFormat:@"SELECT * FROM `%@` WHERE %@", self.child.tableName, whereString];
    }

    CTPersistanceQueryCommand *queryCommand = self.queryCommand;
    if (self.isFromMigration == NO) {
        queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:[self.child databaseName]];
    }
    return [[[queryCommand readWithSQL:sqlString bindValueList:bindValueList error:error] fetchWithError:error] transformSQLItemsToClass:self.child.recordClass];
}

- (NSArray <NSObject <CTPersistanceRecordProtocol> *> *)findAllWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error
{
    NSMutableArray *bindValueList = [[NSMutableArray alloc] init];
    [params enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        [bindValueList addBindKey:key bindValue:value columnDescription:self.child.columnInfo[key]];
    }];

    CTPersistanceQueryCommand *queryCommand = self.queryCommand;
    if (self.isFromMigration == NO) {
        queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:[self.child databaseName]];
    }
    return [[[queryCommand readWithSQL:sqlString bindValueList:bindValueList error:error] fetchWithError:error] transformSQLItemsToClass:self.child.recordClass];
}

- (NSObject <CTPersistanceRecordProtocol> *)findFirstRowWithWhereCondition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams isDistinct:(BOOL)isDistinct error:(NSError **)error
{
    NSMutableArray *bindValueList = [[NSMutableArray alloc] init];

    NSMutableString *whereString = [condition mutableCopy];
    [conditionParams enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        NSMutableString *valueKey = [key mutableCopy];
        [valueKey deleteCharactersInRange:NSMakeRange(0, 1)];
        [valueKey insertString:@":CTPersistanceWhere" atIndex:0];
        [whereString replaceOccurrencesOfString:key withString:valueKey options:0 range:NSMakeRange(0, whereString.length)];
        [bindValueList addBindKey:valueKey bindValue:value columnDescription:nil];
    }];

    NSString *sqlString = nil;
    if (isDistinct) {
        sqlString = [NSString stringWithFormat:@"SELECT DISTINCT * FROM `%@` WHERE %@ LIMIT 1;", self.child.tableName, whereString];
    } else {
        sqlString = [NSString stringWithFormat:@"SELECT * FROM `%@` WHERE %@ LIMIT 1;", self.child.tableName, whereString];
    }

    CTPersistanceQueryCommand *queryCommand = self.queryCommand;
    if (self.isFromMigration == NO) {
        queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:[self.child databaseName]];
    }
    return [[[[queryCommand readWithSQL:sqlString bindValueList:bindValueList error:error] fetchWithError:error] transformSQLItemsToClass:self.child.recordClass] firstObject];
}

- (NSObject <CTPersistanceRecordProtocol> *)findFirstRowWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error
{
    return [[self findAllWithSQL:sqlString params:params error:error] firstObject];
}

- (NSNumber *)countTotalRecord
{
    NSString *sqlString = [NSString stringWithFormat:@"SELECT COUNT(*) as count FROM %@", self.child.tableName];
    NSDictionary *countResult = [self countWithSQL:sqlString params:nil error:NULL];
    return countResult[@"count"];
}

- (NSNumber *)countWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams error:(NSError **)error
{
#warning todo
//    NSString *sqlString = @"SELECT COUNT(*) AS count FROM :tableName WHERE :whereString;";
//    NSString *whereString = [whereCondition stringWithSQLParams:conditionParams];
//    NSString *tableName = self.child.tableName;
//    NSDictionary *params = NSDictionaryOfVariableBindings(whereString, tableName);
//    NSDictionary *countResult = [self countWithSQL:sqlString params:params error:NULL];
//    return countResult[@"count"];
    return nil;
}

- (NSDictionary *)countWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error
{
#warning todo
//    CTPersistanceQueryCommand *queryCommand = self.queryCommand;
//    if (self.isFromMigration == NO) {
//        queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:[self.child databaseName]];
//    }
//    NSString *finalString = [sqlString stringWithSQLParams:params];
//    [queryCommand.sqlString appendString:finalString];
//    return [[queryCommand fetchWithError:NULL] firstObject];
    return nil;
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
    [bindValueList addBindKey:valueKey bindValue:primaryKeyValue columnDescription:self.child.columnInfo[self.child.primaryKeyName]];

    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM `%@` WHERE %@ = %@ LIMIT 1;", self.child.tableName, self.child.primaryKeyName, valueKey];

    CTPersistanceQueryCommand *queryCommand = self.queryCommand;
    if (self.isFromMigration == NO) {
        queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:[self.child databaseName]];
    }
    return [[[[queryCommand readWithSQL:sqlString bindValueList:bindValueList error:error] fetchWithError:error] transformSQLItemsToClass:self.child.recordClass] firstObject];
}

- (NSArray <NSObject <CTPersistanceRecordProtocol> *> *)findAllWithPrimaryKey:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error
{
//    NSString *primaryKeyValueListString = [primaryKeyValueList componentsJoinedByString:@","];
//    CTPersistanceCriteria *criteria = [[CTPersistanceCriteria alloc] init];
//    criteria.whereCondition = [NSString stringWithFormat:@"%@ IN (:primaryKeyValueListString)", [self.child primaryKeyName]];
//    criteria.whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyValueListString);
//    return [self findAllWithCriteria:criteria error:error];
    return nil;
}

- (NSArray<NSObject<CTPersistanceRecordProtocol> *> *)findAllWithKeyName:(NSString *)keyname value:(id)value error:(NSError *__autoreleasing *)error
{
//    if (keyname && value) {
//        CTPersistanceCriteria *criteria = [[CTPersistanceCriteria alloc] init];
//        criteria.whereCondition = [NSString stringWithFormat:@"%@ = :value", keyname];
//        criteria.whereConditionParams = NSDictionaryOfVariableBindings(value);
//        return [self findAllWithCriteria:criteria error:error];
//    }
    return nil;
}

@end
