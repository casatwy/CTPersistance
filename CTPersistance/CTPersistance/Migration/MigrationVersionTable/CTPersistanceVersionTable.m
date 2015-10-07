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
    return kCTPersistanceVersionTableName;
}

- (NSDictionary *)columnInfo
{
    return @{
             @"identifier":@"INTEGER PRIMARY KEY AUTOINCREMENT",
             @"databaseVersion":@"TEXT"
             };
}

- (NSString *)primaryKeyName
{
    return @"identifier";
}

- (Class)recordClass
{
    return [CTPersistanceVersionRecord class];
}

#pragma mark - getters and setters
- (CTPersistanceQueryCommand *)queryCommand
{
    if (_queryCommand == nil) {
        _queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabase:self.database];
        [[_queryCommand createTable:[self.child tableName] columnInfo:[self.child columnInfo]] executeWithError:NULL];
    }
    return _queryCommand;
}

@end
