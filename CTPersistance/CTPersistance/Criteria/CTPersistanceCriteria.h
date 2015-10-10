//
//  CTPersistanceCriteria.h
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTPersistanceQueryCommand.h"

/**
 *  criteria is an object which is convenient for user to create sql or make range for data to be fetched.
 */
@interface CTPersistanceCriteria : NSObject

/**
 *  the table or table list which connected with comma(,) to be select.
 */
@property (nonatomic, copy) NSString *select;

/**
 *  the condition in WHERE
 */
@property (nonatomic, copy) NSString *whereCondition;

/**
 *  params for whereCondition
 */
@property (nonatomic, copy) NSDictionary *whereConditionParams;

/**
 *  the key to order
 */
@property (nonatomic, copy) NSString *orderBy;

/**
 *  if YES, will generate DESC in ORDER BY clause. if NO, will generate ASC in ORDER BY clause
 */
@property (nonatomic, assign) BOOL isDESC;

/**
 *  the limit count
 */
@property (nonatomic, assign) NSInteger limit;

/**
 *  the offset to fetch
 */
@property (nonatomic, assign) NSInteger offset;

/**
 *  if YES, will generate SELECT DISTINCT, if NO, will generate SELECT
 */
@property (nonatomic, assign) BOOL isDistinct;

/**
 *  generate SQL for SELECT
 *
 *  @param queryCommand CTPersistanceQueryCommand instance
 *  @param tableName    name of table or tables which connected with comma(,)
 *
 *  @return return CTPersisstanceQueryCommand
 */
- (CTPersistanceQueryCommand *)applyToSelectQueryCommand:(CTPersistanceQueryCommand *)queryCommand tableName:(NSString *)tableName;

/**
 *  generate SQL for DELETE
 *
 *  @param queryCommand CTPersistanceQueryCommand instance
 *  @param tableName    name of table
 *
 *  @return return CTPersistanceQueryCommand
 */
- (CTPersistanceQueryCommand *)applyToDeleteQueryCommand:(CTPersistanceQueryCommand *)queryCommand tableName:(NSString *)tableName;

@end
