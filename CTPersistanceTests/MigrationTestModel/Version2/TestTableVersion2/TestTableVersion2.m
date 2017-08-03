//
//  TestTableVersion2.m
//  CTPersistance
//
//  Created by casa on 2017/8/3.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "TestTableVersion2.h"
#import "TestRecordVersion2.h"

@implementation TestTableVersion2

#pragma mark - CTPersistanceTableProtocol
- (NSString *)databaseName
{
    return @"MigrationTestDatabase_version2.sqlite";
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
             };
}

- (Class)recordClass
{
    return [TestRecordVersion2 class];
}

- (NSString *)primaryKeyName
{
    return @"primaryKey";
}

@end
