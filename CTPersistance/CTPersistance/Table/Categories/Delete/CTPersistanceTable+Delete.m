//
//  CTPersistanceTable+Delete.m
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceTable+Delete.h"
#import <UIKit/UIKit.h>

#import "CTPersistanceQueryCommand+DataManipulations.h"
#import "NSMutableArray+CTPersistanceBindValue.h"
#import "NSString+Where.h"
#import "NSDictionary+KeyValueBind.h"

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
    CTPersistanceQueryCommand *queryCommand = self.queryCommand;
    if (self.isFromMigration == NO) {
        queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:[self.child databaseName]];
    }

    NSMutableArray *bindValueList = [[NSMutableArray alloc] init];

    NSString *whereString = [whereCondition whereStringWithConditionParams:conditionParams bindValueList:bindValueList];
    
    [[queryCommand deleteTable:self.child.tableName whereString:whereString bindValueList:bindValueList error:error] executeWithError:error];
}

- (void)deleteWithPrimaryKey:(NSNumber *)primaryKeyValue error:(NSError **)error
{
    if (primaryKeyValue) {
        CTPersistanceQueryCommand *queryCommand = self.queryCommand;
        if (self.isFromMigration == NO) {
            queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:[self.child databaseName]];
        }

        NSMutableArray *bindValueList = [[NSMutableArray alloc] init];
        
        NSString *whereKey = [NSString stringWithFormat:@":CTPersistanceWhere_%@", self.child.primaryKeyName];
        [bindValueList addBindKey:whereKey bindValue:primaryKeyValue columnDescription:self.child.columnInfo[self.child.primaryKeyName]];

        NSString *whereString = [NSString stringWithFormat:@"%@ = %@", self.child.primaryKeyName, whereKey];
        [[queryCommand deleteTable:self.child.tableName whereString:whereString bindValueList:bindValueList error:error] executeWithError:error];
    }
}

- (void)deleteWithPrimaryKeyList:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error
{
    if ([primaryKeyValueList count] > 0) {
        CTPersistanceQueryCommand *queryCommand = self.queryCommand;
        if (self.isFromMigration == NO) {
            queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:[self.child databaseName]];
        }

        NSMutableArray *bindValueList = [[NSMutableArray alloc] init];

        NSMutableArray *valueKeyList = [[NSMutableArray alloc] init];
        [primaryKeyValueList enumerateObjectsUsingBlock:^(id  _Nonnull value, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *valueKey = [NSString stringWithFormat:@":CTPersistanceWhere%lu", (unsigned long)idx];
            [valueKeyList addObject:valueKey];
            [bindValueList addBindKey:valueKey bindValue:value columnDescription:self.child.columnInfo[self.child.primaryKeyName]];
        }];
        NSString *whereString = [NSString stringWithFormat:@"%@ IN (%@)", self.child.primaryKeyName, [valueKeyList componentsJoinedByString:@","]];

        [[queryCommand deleteTable:self.child.tableName whereString:whereString bindValueList:bindValueList error:error] executeWithError:error];
    }
}

- (void)truncate
{
    CTPersistanceQueryCommand *queryCommand = self.queryCommand;
    if (self.isFromMigration == NO) {
        queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:[self.child databaseName]];
    }
    [[queryCommand truncateTable:self.child.tableName] executeWithError:NULL];
}

@end
