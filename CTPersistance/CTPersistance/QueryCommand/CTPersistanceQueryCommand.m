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

@property (nonatomic, strong) NSMutableDictionary *cachedStatements;

@end

@implementation CTPersistanceQueryCommand

#pragma mark - public methods
- (instancetype)initWithDatabase:(CTPersistanceDataBase *)database
{
    self = [super init];
    if (self) {
        self.cachedStatements = [NSMutableDictionary dictionary];
        self.shouldKeepDatabase = YES;
        self.database = database;
    }
    return self;
}

- (instancetype)initWithDatabaseName:(NSString *)databaseName
{
    self = [super init];
    if (self) {
        self.cachedStatements = [NSMutableDictionary dictionary];
        self.shouldKeepDatabase = NO;
        self.databaseName = databaseName;
    }
    return self;
}

- (CTPersistanceSqlStatement *)compileSqlString:(NSString *)sqlString bindValueList:(NSMutableArray <NSInvocation *> *)bindValueList error:(NSError *__autoreleasing *)error
{
    CTPersistanceSqlStatement *statement = nil;
    
    statement = [self cachedStatementForSqlString:sqlString];
    
    if (statement == nil) {
        
        statement = [[CTPersistanceSqlStatement alloc] initWithSqlString:sqlString bindValueList:bindValueList database:self.database error:error];
        [self setCachedStatement:statement forSqlString:sqlString];
        
    } else {
        
        sqlite3_stmt *stmt = statement.statement;
        
        [bindValueList enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull bindInvocation, NSUInteger idx, BOOL * _Nonnull stop) {
            [bindInvocation setArgument:(void *)&stmt atIndex:2];
            [bindInvocation invoke];
        }];
        [bindValueList removeAllObjects];
        
        
    }
    
    return statement;
}

#pragma mark - statement cache
- (CTPersistanceSqlStatement *)cachedStatementForSqlString:(NSString *)sqlString
{
    return [self.cachedStatements objectForKey:sqlString];
}

- (void)setCachedStatement:(CTPersistanceSqlStatement *)statement forSqlString:(NSString *)sqlString
{
    [self.cachedStatements setObject:statement forKey:sqlString];
}

- (void)clearCachedStatements
{
    for (CTPersistanceSqlStatement *statement in [self.cachedStatements objectEnumerator]) {
        [statement close];
    }
    
    [self.cachedStatements removeAllObjects];
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
