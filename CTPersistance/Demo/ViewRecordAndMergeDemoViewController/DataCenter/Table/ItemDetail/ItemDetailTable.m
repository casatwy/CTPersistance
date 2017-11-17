//
//  ItemDetailTable.m
//  CTPersistance
//
//  Created by casa on 2017/11/17.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "ItemDetailTable.h"
#import "ItemDetailRecord.h"

@implementation ItemDetailTable

#pragma mark - CTPersistanceTableProtocol
- (NSString *)tableName
{
    return @"item_detail";
}

- (NSString *)databaseName
{
    return @"item.sqlite";
}

- (NSDictionary *)columnInfo
{
    return @{
             @"primaryKey":@"INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
             @"detail":@"TEXT"
             };
}

- (Class)recordClass
{
    return [ItemDetailRecord class];
}

- (NSString *)primaryKeyName
{
    return @"primaryKey";
}

@end
