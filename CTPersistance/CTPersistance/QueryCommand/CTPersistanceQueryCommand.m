//
//  CTPersistanceQueryBuilder.m
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceQueryCommand.h"
#import "CTPersistanceDataBase.h"
#import "CTPersistanceDatabasePool.h"
#import "CTPersistanceConfiguration.h"

@interface CTPersistanceQueryCommand ()

@property (nonatomic, weak) CTPersistanceDataBase *database;
@property (nonatomic, strong) NSString *databaseName;
@property (nonatomic, assign) BOOL shouldKeepDatabase;

@end

@implementation CTPersistanceQueryCommand

#pragma mark - public methods
- (instancetype)initWithDatabase:(CTPersistanceDataBase *)database
{
    self = [super init];
    if (self) {
        self.shouldKeepDatabase = YES;
        self.database = database;
    }
    return self;
}

- (instancetype)initWithDatabaseName:(NSString *)databaseName
{
    self = [super init];
    if (self) {
        self.shouldKeepDatabase = NO;
        self.databaseName = databaseName;
    }
    return self;
}

- (CTPersistanceSqlStatement *)compileSqlString:(NSString *)sqlString bindValueList:(NSMutableArray <NSInvocation *> *)bindValueList error:(NSError *__autoreleasing *)error
{
    return [[CTPersistanceSqlStatement alloc] initWithSqlString:sqlString bindValueList:bindValueList database:self.database error:error];
}

#pragma mark - getters and setters
- (CTPersistanceDataBase *)database
{
    if (self.shouldKeepDatabase) {
        return _database;
    }
    _database = [[CTPersistanceDatabasePool sharedInstance] databaseWithName:self.databaseName];
    return _database;
}

@end
