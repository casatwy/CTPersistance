//
//  TestTableColumnName.m
//  CTPersistance
//
//  Created by casa on 2017/7/10.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "TestTableColumnName.h"

@implementation TestTableColumnName

+ (NSString *)columnName
{
    return @"name";
}

+ (NSString *)columnType
{
    return CTPersistanceColumnTypeText;
}

+ (BOOL)isPrimaryKey
{
    return NO;
}

+ (BOOL)isAutoIncrement
{
    return NO;
}

+ (BOOL)isNOTNULL
{
    return YES;
}

@end
