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

- (CTPersistanceQueryCommand *)applyToSelectQueryCommand:(CTPersistanceQueryCommand *)queryCommand tableName:(NSString *)tableName
{
    [queryCommand select:self.select isDistinct:self.isDistinct];
    [queryCommand from:tableName];
    [queryCommand where:self.whereCondition params:self.whereConditionParams];
    [queryCommand orderBy:self.orderBy isDESC:self.isDESC];
    [queryCommand limit:self.limit offset:self.offset];
    return queryCommand;
}

- (CTPersistanceQueryCommand *)applyToDeleteQueryCommand:(CTPersistanceQueryCommand *)queryCommand tableName:(NSString *)tableName
{
    return [queryCommand deleteTable:tableName withCondition:self.whereCondition conditionParams:self.whereConditionParams];
}

@end
