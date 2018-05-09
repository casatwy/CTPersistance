//
//  TestModel.m
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "TestTable.h"

@implementation TestTable

#pragma mark - CTPersistanceTableProtocol
- (NSString *)tableName
{
    return @"test";
}

- (NSString *)databaseName
{
    //you can use like:
    return @"TestDatabase.sqlite";

    //Or
    //return @"User/Shopping/testdatabase.sqlite";
}

-(NSDictionary *)columnDetaultValue {
    return @{
             @"defaultInt":@(1),
             @"defaultStr":@"",
             @"defaultBool":@(1),
             @"defaultDouble":@(1.0)
             };
}

- (NSDictionary *)columnInfo
{
    return @{
             @"primaryKey":@"INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
             @"name":@"TEXT",
             @"age":@"INTEGER",
             @"isCelebrity":@"BOOLEAN",
             @"avatar":@"BLOB",
             @"progress":@"REAL",
             @"nilValue":@"TEXT",

             @"timeStamp":@"INTEGER",
             @"defaultInt":@"INTEGER",
             @"defaultStr":@"TEXT",
             @"defaultBool":@"INTEGER",
             @"defaultDouble":@"REAL",
             @"defaultBlob":@"BLOB",
             };
}

- (Class)recordClass
{
    return [TestRecord class];
}

- (NSString *)primaryKeyName
{
    return @"primaryKey";
}

- (NSArray<NSDictionary *> *)indexList
{
    return @[
             @{
                 kCTPersistanceTableIndexName:@"IndexAge",
                 kCTPersistanceTableIndexedColumnList:@[@"age"],
                 kCTPersistanceTableIndexIsUniq:@(NO),
                 },
            ];
}

@end
