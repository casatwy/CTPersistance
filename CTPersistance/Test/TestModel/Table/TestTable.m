//
//  TestModel.m
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "TestTable.h"
#import "CTPersistanceTable+Insert.h"

#import "TestTableColumnTomas.h"
#import "TestTableColumnAge.h"
#import "TestTableColumnName.h"
#import "TestTableColumnPrimaryKey.h"

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

- (NSArray<Class<CTPersistanceColumnDescription>> *)columnInfo
{
    return @[
             [TestTableColumnTomas class],
             [TestTableColumnPrimaryKey class],
             [TestTableColumnAge class],
             [TestTableColumnName class],
             ];
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
