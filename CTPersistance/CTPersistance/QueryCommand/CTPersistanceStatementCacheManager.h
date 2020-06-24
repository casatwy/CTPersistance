//
//  CTPersistanceStatementCacheManager.h
//  CTPersistance
//
//  Created by longjianjiang on 2018/7/7.
//  Copyright © 2018年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTPersistanceStatementCacheItem.h"

@interface CTPersistanceStatementCacheManager : NSObject

+ (instancetype)sharedInstance;

- (void)setCachedStatement:(CTPersistanceStatementCacheItem *)pStmt forSQLString:(NSString *)sqlString atDatabase:(NSString *)databaseName;
- (CTPersistanceStatementCacheItem *)getCachedStatementWithSQLString:(NSString *)sqlString atDatabase:(NSString *)databaseName;
- (void)removeCachedStatement:(CTPersistanceStatementCacheItem *)pStmt forSQLString:(NSString *)sqlString atDatabase:(NSString *)databaseName;

- (void)clearDatabaseStatementCache:(NSString *)databaseName;

@end
