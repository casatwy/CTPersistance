//
//  TestTableVersion1.m
//  CTPersistance
//
//  Created by casa on 2017/8/3.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "TestTableVersion1.h"
#import "TestRecordVersion1.h"

@implementation TestTableVersion1

#pragma mark - CTPersistanceTableProtocol
- (NSString *)databaseName
{
    return @"MigrationTestDatabase_version1.sqlite";
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
             };
}

- (Class)recordClass
{
    return [TestRecordVersion1 class];
}

- (NSString *)primaryKeyName
{
    return @"primaryKey";
}

@end
