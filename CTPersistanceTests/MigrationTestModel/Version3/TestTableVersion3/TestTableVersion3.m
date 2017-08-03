//
//  TestTableVersion3.m
//  CTPersistance
//
//  Created by casa on 2017/8/3.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "TestTableVersion3.h"
#import "TestRecordVersion3.h"

@implementation TestTableVersion3

#pragma mark - CTPersistanceTableProtocol
- (NSString *)databaseName
{
    return @"MigrationTestDatabase_version3.sqlite";
}

- (NSString *)tableName
{
    return @"migration";
}

- (NSDictionary *)columnInfo
{
    return @{
             @"primaryKey":@"INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
             @"version1":@"TEXT",
             @"version2":@"TEXT",
             @"version3":@"TEXT",
             };
}

- (Class)recordClass
{
    return [TestRecordVersion3 class];
}

- (NSString *)primaryKeyName
{
    return @"primaryKey";
}

@end
