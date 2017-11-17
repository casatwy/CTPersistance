//
//  ItemTable.m
//  CTPersistance
//
//  Created by casa on 2017/11/17.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "ItemTable.h"
#import "ItemRecord.h"

@implementation ItemTable

#pragma mark - CTPersistanceTableProtocol
- (NSString *)tableName
{
    return @"item";
}

- (NSString *)databaseName
{
    return @"item.sqlite";
}

- (NSDictionary *)columnInfo
{
    return @{
             @"primaryKey":@"INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
             @"name":@"TEXT"
             };
}

- (Class)recordClass
{
    return [ItemRecord class];
}

- (NSString *)primaryKeyName
{
    return @"primaryKey";
}

@end
