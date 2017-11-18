//
//  CTPersistanceSqlStatement.h
//  CTPersistance
//
//  Created by casa on 2017/8/13.
//  Copyright © 2017年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTPersistanceDataBase.h"

@interface CTPersistanceSqlStatement : NSObject

- (instancetype)initWithSqlString:(NSString *)sqlString bindValueList:(NSMutableArray <NSInvocation *> *)bindValueList database:(CTPersistanceDataBase *)database error:(NSError *__autoreleasing *)error;

/**
 *  execute SQL with sqlString
 *
 *  @param error error if fails
 *
 *  @return return NO if fails, and YES for success
 */
- (BOOL)executeWithError:(NSError **)error;

/**
 *  fetch data with sqlString
 *
 *  @param error error if fails
 *
 *  @return return fetched data list
 */
- (NSArray <NSDictionary *> *)fetchWithError:(NSError **)error;

@end
