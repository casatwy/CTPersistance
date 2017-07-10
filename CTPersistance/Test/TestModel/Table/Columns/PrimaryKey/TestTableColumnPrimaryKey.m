//
//  TestTableColumnPrimaryKey.m
//  CTPersistance
//
//  Created by casa on 2017/7/10.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "TestTableColumnPrimaryKey.h"

@implementation TestTableColumnPrimaryKey

+ (NSString *)columnName
{
    return @"primaryKey";
}

+ (NSString *)columnType
{
    return CTPersistanceColumnTypeInteger;
}

+ (BOOL)isPrimaryKey
{
    return YES;
}

+ (BOOL)isAutoIncrement
{
    return YES;
}

+ (BOOL)isNOTNULL
{
    return YES;
}

@end
