//
//  CTPersistanceCriteria.m
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceCriteria.h"
#import "CTPersistanceConfiguration.h"
#import "CTPersistanceQueryCommand+ReadMethods.h"
#import "CTPersistanceQueryCommand+DataManipulations.h"
#import "NSMutableArray+CTPersistanceBindValue.h"

@implementation CTPersistanceCriteria

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.limit = CTPersistanceNoLimit;
        self.offset = CTPersistanceNoOffset;
    }
    return self;
}

- (CTPersistanceCriteria *)applySelectForTableName:(NSString *)tableName
{
    NSMutableArray *bindValueList = [[NSMutableArray alloc] init];
    NSMutableString *sqlString = [[NSMutableString alloc] init];;

    if (self.isDistinct) {
        [sqlString appendString:[NSString stringWithFormat:@"SELECT DISTINCT %@ FROM `%@`", self.select, tableName]];
    } else {
        [sqlString appendString:[NSString stringWithFormat:@"SELECT %@ FROM `%@`", self.select, tableName]];
    }

    if (self.whereCondition && self.whereConditionParams) {
        NSMutableString *whereString = [self.whereCondition mutableCopy];
        [self.whereConditionParams enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
            NSMutableString *valueKey = [key mutableCopy];
            [valueKey deleteCharactersInRange:NSMakeRange(0, 1)];
            [valueKey insertString:@":CTPersistanceWhere" atIndex:0];
            [whereString replaceOccurrencesOfString:key withString:valueKey options:0 range:NSMakeRange(0, whereString.length)];
            [bindValueList addBindKey:valueKey bindValue:value columnDescription:nil];
        }];
        [sqlString appendString:[NSString stringWithFormat:@" WHERE %@", whereString]];
    }

    if (self.orderBy) {
        if (self.isDESC) {
            [sqlString appendString:[NSString stringWithFormat:@" ORDER BY %@ DESC", self.orderBy]];
        } else {
            [sqlString appendString:[NSString stringWithFormat:@" ORDER BY %@ ASC", self.orderBy]];
        }
    }

    if (self.limit != CTPersistanceNoLimit) {
        [sqlString appendString:[NSString stringWithFormat:@" LIMIT %ld", (long)self.limit]];
    }

    if (self.offset != CTPersistanceNoOffset) {
        [sqlString appendString:[NSString stringWithFormat:@" OFFSET %ld", (long)self.offset]];
    }

    return self;
}

- (CTPersistanceCriteria *)applyDeleteForTableName:(NSString *)tableName
{
#warning todo
    return self;
}

@end
