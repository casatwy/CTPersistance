//
//  CTPersistanceContext.h
//  CTPersistance
//
//  Created by casa on 15/10/3.
//  Copyright © 2015年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTPersistanceDataBase.h"

@interface CTPersistanceDatabasePool : NSObject

/**
 *  return the singleton instance
 *
 *  @return return the singleton instance
 */
+ (instancetype)sharedInstance;

/**
 *  fetch database instance by file name of your database. If the database is not created before, this method will create a database instance.
 *
 *  @param databaseName the file name of your database
 *
 *  @return return instance of database
 */
- (CTPersistanceDataBase *)databaseWithName:(NSString *)databaseName;

/**
 *  close database by file name of the database.
 *
 *  @param databaseName file name of the database
 */
- (void)closeDatabaseWithName:(NSString *)databaseName;

/**
 *  close all database.
 */
- (void)closeAllDatabase;

@end
