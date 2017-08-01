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
    return @"testdatabase.sqlite";
    
    //Or
    //return @"User/Shopping/testdatabase.sqlite";
    
}

- (NSDictionary *)columnInfo
{
    return @{
             @"primaryKey":@"INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
             @"name":@"TEXT",
             @"age":@"INTEGER",
             @"avatar":@"BLOB",
             @"progress":@"REAL"
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

- (void)modifyDatabaseName:(NSString *)databaseName
{
    
}

@end
