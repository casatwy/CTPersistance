//
//  CTPersistanceStatementCacheItem.m
//  CTPersistance
//
//  Created by longjianjiang on 2018/7/13.
//  Copyright © 2018年 casa. All rights reserved.
//

#import "CTPersistanceStatementCacheItem.h"
#import <libkern/OSAtomic.h>

@interface CTPersistanceStatementCacheItem () {
     volatile uint32_t _inUse;
}

@end

@implementation CTPersistanceStatementCacheItem
- (void)close
{
    if (_statement) {
        sqlite3_finalize(_statement);
        _statement = 0x00;
    }
    
    self.inUse = NO;
}

- (void)reset
{
    if (_statement) {
        sqlite3_reset(_statement);
    }

    self.inUse = NO;
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
