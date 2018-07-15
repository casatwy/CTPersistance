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

- (CTPersistanceStatementCacheItem *)getCachedStatementWithSQLString:(NSString *)sqlString atDatabase:(NSString *)databaseName
{
    @synchronized (self) {
        if (![self.cachedTree objectForKey:databaseName]) {
            return NULL;
        }
        
        NSMutableDictionary *cachedStatements = [self.cachedTree objectForKey:databaseName];
        
        if (![cachedStatements objectForKey:sqlString]) {
            return NULL;
        }
        
        NSMutableSet *statements = [cachedStatements objectForKey:sqlString];
    
        for (CTPersistanceStatementCacheItem *item in statements) {
            if (item.inUse == NO) {
                return item;
            }
        }
        
        return nil;
    }
}

- (void)setCachedStatement:(CTPersistanceStatementCacheItem *)pStmt forSQLString:(NSString *)sqlString atDatabase:(NSString *)databaseName
{
    @synchronized (self) {
        if (![self.cachedTree objectForKey:databaseName]) {
            [self.cachedTree setObject:[NSMutableDictionary dictionary] forKey:databaseName];
        }
        
        NSMutableDictionary *cachedStatements = [self.cachedTree objectForKey:databaseName];
        
        NSMutableSet *statements = [cachedStatements objectForKey:sqlString];
        if (!statements) {
            statements = [NSMutableSet set];
        }
        
        if (pStmt.inUse == NO) {
            [statements addObject:pStmt];
            [cachedStatements setObject:statements forKey:sqlString];
        }
    
    }
   
}

- (void)removeCachedStatement:(CTPersistanceStatementCacheItem *)pStmt forSQLString:(NSString *)sqlString atDatabase:(NSString *)databaseName
{
    
    @synchronized (self) {
        if (![self.cachedTree objectForKey:databaseName]) {
            return;
        }
        
        NSMutableDictionary *cachedStatements = [self.cachedTree objectForKey:databaseName];
        
        if (![cachedStatements objectForKey:sqlString]) {
            return;
        }
        
        NSMutableSet *statements = [cachedStatements objectForKey:sqlString];
        [statements removeObject:pStmt];
    }
}

- (void)clearDatabaseStatementCache:(NSString *)databaseName
{
    if (![self.cachedTree objectForKey:databaseName]) {
        return;
    }
    
    NSMutableDictionary *cachedStatements = [self.cachedTree objectForKey:databaseName];
    
    for (NSMutableSet *statements in [cachedStatements objectEnumerator]) {
        for (CTPersistanceStatementCacheItem *item in statements) {
            [item close];
        }
    }
    
    [cachedStatements removeAllObjects];
    [self.cachedTree removeObjectForKey:databaseName];
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

@end
