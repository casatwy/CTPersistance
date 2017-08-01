//
//  CTPersistanceQueryBuilder.h
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTPersistanceDataBase.h"
#import <sqlite3.h>

/**
 *  CTPersistanceQueryCommand is a SQL builder for CTPersistance
 *
 *  @warning you should never create your own instance of CTPersistanceQueryCommand
 *
 */
@interface CTPersistanceQueryCommand : NSObject

#warning todo delete sqlstring
/**
 *  the current generated SQL string
 */
@property (nonatomic, strong, readonly) NSMutableString *sqlString; 

/*
 * the statement of current SQL
 */
@property (nonatomic, unsafe_unretained) sqlite3_stmt *statement;

/**
 *  related CTPersistanceDataBase
 */
@property (nonatomic, weak, readonly) CTPersistanceDataBase *database;

/**
 *  create CTPersistanceQueryCommand with name of database
 *
 *  @param databaseName the name of database
 *
 *  @return return CTPersistanceQueryCommand
 *
 *  @warning You should never use this method directly, use insert methods in CTPersistanceTable instead
 *
 */
- (instancetype)initWithDatabaseName:(NSString *)databaseName;

/**
 *  create CTPersistanceQueryCommand with instance of CTPersistanceDataBase
 *
 *  @param database the CTPersistanceDataBase instance
 *
 *  @return return CTPersistanceQueryCommand
 *
 *  @warning You should never use this method directly, use insert methods in CTPersistanceTable instead
 *
 */
- (instancetype)initWithDatabase:(CTPersistanceDataBase *)database;

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

/**
 *  count data with sqlString
 *
 *  @param error error if fails
 *
 *  @return return count, return -1 if fails
 */
//- (NSNumber *)countWithError:(NSError **)error;

@end
