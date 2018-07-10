//
//  CTPersistanceStatementCacheManager.m
//  CTPersistance
//
//  Created by zl on 2018/7/7.
//  Copyright © 2018年 casa. All rights reserved.
//

#import "CTPersistanceStatementCacheManager.h"

@interface CTPersistanceStatementCacheManager()

@property (nonatomic, strong) NSMutableDictionary *cachedStatements;

@property (nonatomic, strong) NSMutableDictionary *useCount;

@end


@implementation CTPersistanceStatementCacheManager

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

- (sqlite3_stmt *)getCachedStatementWithSQLString:(NSString *)sqlString
{
    if (![self.cachedStatements objectForKey:sqlString]) {
        return NULL;
    }
    
    @synchronized(self) {
        sqlite3_stmt *pStmt = [[self.cachedStatements objectForKey:sqlString] pointerValue];

        NSInteger count = [[self.useCount objectForKey:sqlString] integerValue] + 1;
        [self.useCount setObject:@(count) forKey:sqlString];
#ifdef DEBUG
        NSLog(@" sqlstring %@ , use count is %@", sqlString, [self.useCount objectForKey:sqlString]);
#endif
        if (count >= 55) {
            return NULL;
        }
        return pStmt;
    }
    
}

- (void)setCachedStatement:(sqlite3_stmt *)pStmt forSQLString:(NSString *)sqlString
{
    if ([self.cachedStatements objectForKey:sqlString]) {
        return;
    }
    
    NSArray *notCachedSQL = @[@"PRAGMA"];
    BOOL shouldCache = YES;
    for (NSString *sql in notCachedSQL) {
        if ([[sqlString uppercaseString] rangeOfString:sql].length) {
            shouldCache = NO;
            break;
        }
    }
    
    if (1) {
        @synchronized(self) {
            [self.cachedStatements setObject:[NSValue valueWithPointer:pStmt] forKey:sqlString];
            [self.useCount setObject:@(0) forKey:sqlString];
        }
    }

}

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cachedStatements = [NSMutableDictionary dictionary];
        self.useCount = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc
{
    @synchronized(self) {
        for (id statement in [self.cachedStatements objectEnumerator]) {
            sqlite3_finalize((sqlite3_stmt *)[statement pointerValue]);
        }
        
        [self.cachedStatements removeAllObjects];
        [self.useCount removeAllObjects];
    }
    
}

@end
