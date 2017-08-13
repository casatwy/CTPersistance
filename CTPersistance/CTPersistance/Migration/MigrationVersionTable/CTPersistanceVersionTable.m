//
//  CTPersistanceTableVersion.m
//  CTPersistance
//
//  Created by casa on 15/10/7.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceVersionTable.h"
#import "CTPersistanceConfiguration.h"
#import "CTPersistanceVersionRecord.h"
#import "CTPersistanceQueryCommand.h"
#import "CTPersistanceQueryCommand+SchemaManipulations.h"

@interface CTPersistanceVersionTable ()

@property (nonatomic, weak) CTPersistanceDataBase *database;
@property (nonatomic, strong) NSString *databaseName;
@property (nonatomic, strong) CTPersistanceQueryCommand *queryCommand;

@end

@implementation CTPersistanceVersionTable

@synthesize queryCommand = _queryCommand;

#pragma mark - life cycle
- (instancetype)initWithDatabase:(CTPersistanceDataBase *)database
{
    self = [super init];
    if (self) {
        self.database = database;
        self.databaseName = database.databaseName;
    }
    return self;
}

#pragma mark - CTPersistanceTableProtocol
- (NSString *)tableName
{
    return [CTPersistanceVersionTable tableName];
}

+ (NSString *)tableName
{
    return kCTPersistanceVersionTableName;
}

+ (NSDictionary *)columnInfo
{
    return @{
             @"identifier":@"INTEGER PRIMARY KEY AUTOINCREMENT",
             @"databaseVersion":@"TEXT"
             };
}

- (NSDictionary *)columnInfo
{
    return [CTPersistanceVersionTable columnInfo];
}

+ (NSString *)primaryKeyName
{
    return @"identifier";
}

- (NSString *)primaryKeyName
{
    return [CTPersistanceVersionTable primaryKeyName];
}

- (Class)recordClass
{
    return [CTPersistanceVersionTable recordClass];
}

+ (Class)recordClass
{
    return [CTPersistanceVersionRecord class];
}


#pragma mark - getters and setters
- (CTPersistanceQueryCommand *)queryCommand
{
    _queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabase:self.database];
    return _queryCommand;
}

@end
