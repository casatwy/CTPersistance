//
//  CTPersistanceStatementCacheItem.m
//  CTPersistance
//
//  Created by longjianjiang on 2018/7/13.
//  Copyright © 2018年 casa. All rights reserved.
//

#import "CTPersistanceStatementCacheItem.h"
#import <libkern/OSAtomic.h>
#import <pthread.h>

@interface CTPersistanceStatementCacheItem () {
     volatile uint32_t _inUse;
     pthread_mutex_t _lock;
}

@end

@implementation CTPersistanceStatementCacheItem
- (void)close
{
    if (_statement) {
        pthread_mutex_lock(&_lock);
        sqlite3_finalize(_statement);
        _statement = 0x00;
        pthread_mutex_unlock(&_lock);
    }
    
    self.inUse = NO;
}

- (void)reset
{
    if (_statement) {
        pthread_mutex_lock(&_lock);
        sqlite3_reset(_statement);
        pthread_mutex_unlock(&_lock);
    }

    self.inUse = NO;
}

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
         pthread_mutex_init(&_lock, NULL);
    }
    return self;
}

#pragma mark getter and setter
- (BOOL)inUse
{
    return _inUse != 0;
}

- (void)setInUse:(BOOL)allowed
{
    if (allowed) {
        OSAtomicOr32Barrier(1, &_inUse);
    } else {
        OSAtomicAnd32Barrier(0, &_inUse);
    }
}

@end
