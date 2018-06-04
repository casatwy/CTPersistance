//
//  TestNewRecordVersionTable.m
//  CTPersistanceTests
//
//  Created by 吴明亮 on 2018/6/4.
//  Copyright © 2018 casa. All rights reserved.
//

#import "TestNewRecordVersionTable.h"
#import "CTPersistanceRecord.h"
#import "TestNewRecordVersion.h"

@implementation TestNewRecordVersionTable

#pragma mark - CTPersistanceTableProtocol
- (NSString *)databaseName
{
    return @"MigrationTestDatabaseNewCreate.sqlite";
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
    return [TestNewRecordVersion class];
}

- (NSString *)primaryKeyName
{
    return @"primaryKey";
}

@end
