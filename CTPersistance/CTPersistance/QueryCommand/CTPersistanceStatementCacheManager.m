//
//  CTPersistanceStatementCacheManager.m
//  CTPersistance
//
//  Created by longjianjiang on 2018/7/7.
//  Copyright © 2018年 casa. All rights reserved.
//

#import "CTPersistanceStatementCacheManager.h"

@interface CTPersistanceStatementCacheManager()

@property (nonatomic, strong) NSMutableDictionary *cachedTree;

@end


@implementation CTPersistanceStatementCacheManager

- (sqlite3_stmt *)getCachedStatementWithSQLString:(NSString *)sqlString atDatabase:(NSString *)databaseName
{
    if (![self.cachedTree objectForKey:databaseName]) {
        return NULL;
    }
    
    NSMutableDictionary *cachedStatements = [self.cachedTree objectForKey:databaseName];
    
    if (![cachedStatements objectForKey:sqlString]) {
        return NULL;
    }
    
    @synchronized(self) {
        sqlite3_stmt *pStmt = [[cachedStatements objectForKey:sqlString] pointerValue];
        return pStmt;
    }
}

- (void)setCachedStatement:(sqlite3_stmt *)pStmt forSQLString:(NSString *)sqlString atDatabase:(NSString *)databaseName
{
    if (![self.cachedTree objectForKey:databaseName]) {
        [self.cachedTree setObject:[NSMutableDictionary dictionary] forKey:databaseName];
    }
    
    NSMutableDictionary *cachedStatements = [self.cachedTree objectForKey:databaseName];
    
    if ([cachedStatements objectForKey:sqlString]) {
        return;
    }
    
    @synchronized(self) {
        [cachedStatements setObject:[NSValue valueWithPointer:pStmt] forKey:sqlString];
    }
}

- (void)removeCachedStatement:(sqlite3_stmt *)pStmt forSQLString:(NSString *)sqlString atDatabase:(NSString *)databaseName
{
    if (![self.cachedTree objectForKey:databaseName]) {
        return;
    }
    
    NSMutableDictionary *cachedStatements = [self.cachedTree objectForKey:databaseName];
    
    if (![cachedStatements objectForKey:sqlString]) {
        return;
    }
    
    @synchronized(self) {
        [cachedStatements removeObjectForKey:sqlString];
    }
}

- (void)clearDatabaseStatementCache:(NSString *)databaseName
{
    if (![self.cachedTree objectForKey:databaseName]) {
        return;
    }
    
    NSMutableDictionary *cachedStatements = [self.cachedTree objectForKey:databaseName];
    
    @synchronized(self) {
        for (id statement in [cachedStatements objectEnumerator]) {
            sqlite3_finalize((sqlite3_stmt *)[statement pointerValue]);
        }
        
        [cachedStatements removeAllObjects];
        [self.cachedTree removeObjectForKey:databaseName];
    }
}

- (void)clearAllDatabaseStatementCache
{
    for (NSString *databaseName in [self.cachedTree objectEnumerator]) {
        [self clearDatabaseStatementCache:databaseName];
    }
}


#pragma mark - public methods
+ (instancetype)sharedInstance
{
    static CTPersistanceStatementCacheManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CTPersistanceStatementCacheManager alloc] init];
    });
    return sharedInstance;
}

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cachedTree = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc
{
    [self clearAllDatabaseStatementCache];
}

@end
