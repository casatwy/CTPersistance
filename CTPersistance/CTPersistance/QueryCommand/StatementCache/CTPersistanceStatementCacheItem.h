//
//  CTPersistanceStatementCacheItem.h
//  CTPersistance
//
//  Created by longjianjiang on 2018/7/13.
//  Copyright © 2018年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface CTPersistanceStatementCacheItem : NSObject

@property (atomic, assign) BOOL inUse;
@property (nonatomic, unsafe_unretained) sqlite3_stmt *statement;

- (void)reset;
- (void)close;

@end

