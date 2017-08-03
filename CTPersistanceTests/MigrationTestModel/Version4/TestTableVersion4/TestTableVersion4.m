//
//  TestTableVersion4.m
//  CTPersistance
//
//  Created by casa on 2017/8/3.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "TestTableVersion4.h"
#import "TestRecordVersion4.h"

@implementation TestTableVersion4

#pragma mark - CTPersistanceTableProtocol
- (NSString *)databaseName
{
    return @"MigrationTestDatabase_version4.sqlite";
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
             @"version4":@"TEXT",
             };
}

- (Class)recordClass
{
    return [TestRecordVersion4 class];
}

- (NSString *)primaryKeyName
{
    return @"primaryKey";
}

@end
