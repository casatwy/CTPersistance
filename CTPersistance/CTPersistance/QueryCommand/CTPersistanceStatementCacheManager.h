//
//  CTPersistanceStatementCacheManager.h
//  CTPersistance
//
//  Created by longjianjiang on 2018/7/7.
//  Copyright © 2018年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface CTPersistanceStatementCacheManager : NSObject

+ (instancetype)sharedInstance;

- (sqlite3_stmt *)getCachedStatementWithSQLString:(NSString *)sqlString;
- (void)setCachedStatement:(sqlite3_stmt *)pStmt forSQLString:(NSString *)sqlString;

@end
