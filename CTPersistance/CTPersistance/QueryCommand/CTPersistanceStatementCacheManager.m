//
//  CTPersistanceStatementCacheManager.m
//  CTPersistance
//
//  Created by longjianjiang on 2018/7/7.
//  Copyright © 2018年 casa. All rights reserved.
//

#import "CTPersistanceStatementCacheManager.h"

#define Lock() dispatch_semaphore_wait(self->_lock, DISPATCH_TIME_FOREVER)
#define Unlock() dispatch_semaphore_signal(self->_lock)

@interface CTPersistanceStatementCacheManager()

@property (nonatomic, strong) NSMutableDictionary *cachedTree;

@end


@implementation CTPersistanceStatementCacheManager {
     dispatch_semaphore_t _lock;
}

#pragma mark - getter
- (NSMutableDictionary *)_getCachedStatements:(NSString *)databaseName {
    Lock();
    NSMutableDictionary *cachedStatements = [self.cachedTree objectForKey:databaseName];
    if (!cachedStatements) {
        [self.cachedTree setObject:[NSMutableDictionary dictionary] forKey:databaseName];
        cachedStatements = [self.cachedTree objectForKey:databaseName];
    }
    Unlock();
    return cachedStatements;
}

- (NSMutableSet *)_getStatementSet:(NSString *)databaseName sqlString:(NSString *)sqlString {
    NSMutableDictionary *cachedStatements = [self _getCachedStatements:databaseName];
    Lock();
    NSMutableSet *statements = [cachedStatements objectForKey:sqlString];
    if (!statements) {
        [cachedStatements setObject:[NSMutableSet set] forKey:sqlString];
        statements = [cachedStatements objectForKey:sqlString];
    }
    Unlock();
    return statements;
}

- (CTPersistanceStatementCacheItem *)getCachedStatementWithSQLString:(NSString *)sqlString atDatabase:(NSString *)databaseName
{
    NSMutableDictionary *cachedStatements = [self _getCachedStatements:databaseName];
    
    if (!cachedStatements) {
        return nil;
    } else {
        NSMutableSet *statements = [self _getStatementSet:databaseName sqlString:sqlString];
        CTPersistanceStatementCacheItem *scItem = nil;
        
        Lock();
        for (CTPersistanceStatementCacheItem *item in statements) {
            if (item.inUse == NO) {
                scItem = item;
                [statements removeObject:item];
                break;
            }
        }
        Unlock();
        
        return scItem;
    }
}

- (void)setCachedStatement:(CTPersistanceStatementCacheItem *)pStmt forSQLString:(NSString *)sqlString atDatabase:(NSString *)databaseName
{
    NSMutableSet *statements = [self _getStatementSet:databaseName sqlString:sqlString];
    
    Lock();
    [pStmt reset];
    [statements addObject:pStmt];
    Unlock();
}

- (void)removeCachedStatement:(CTPersistanceStatementCacheItem *)pStmt forSQLString:(NSString *)sqlString atDatabase:(NSString *)databaseName
{
    NSMutableSet *statements = [self _getStatementSet:databaseName sqlString:sqlString];
    
    Lock();
    [pStmt close];
    [statements removeObject:pStmt];
    Unlock();
}

- (void)clearDatabaseStatementCache:(NSString *)databaseName
{
    NSMutableDictionary *cachedStatements = [self _getCachedStatements:databaseName];
    
    Lock();
    for (NSMutableSet *statements in [cachedStatements objectEnumerator]) {
        for (CTPersistanceStatementCacheItem *item in statements) {
            [item close];
        }
    }
    
    [cachedStatements removeAllObjects];
    [self.cachedTree removeObjectForKey:databaseName];
    Unlock();
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
        _lock = dispatch_semaphore_create(1);
        self.cachedTree = [NSMutableDictionary dictionary];
    }
    return self;
}

@end
