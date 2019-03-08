//
//  EncryptPlaintextDatabaseTestTable.m
//  CTPersistanceTests
//
//  Created by 周中广 on 2019/3/8.
//  Copyright © 2019 casa. All rights reserved.
//

#import "EncryptPlaintextDatabaseTestTable.h"


@implementation EncryptPlaintextDatabaseTestTable

#pragma mark - CTPersistanceTableProtocol
- (NSString *)tableName
{
    return @"encryptPlaintextDatabaseTest";
}

- (NSString *)databaseName
{
    return @"EncryptPlaintextTestDataBase.sqlite";
}

- (NSDictionary *)columnInfo
{
    return @{
             @"primaryKey":@"INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
             @"name":@"TEXT",
             @"age":@"INTEGER",
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


@end
