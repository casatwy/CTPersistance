//
//  CTPersistanceDataBase.h
//  CTPersistance
//
//  Created by casa on 15/10/4.
//  Copyright © 2015年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

extern NSString * const kCTPersistanceConfigurationParamsKeyDatabaseName;

/**
 *  CTPersistanceDataBase is a wrapper of sqlite3 database
 */
@interface CTPersistanceDataBase : NSObject

/**
 *  the database used for SQLite library,'sqlite3' pointer
 */
@property (nonatomic, unsafe_unretained, readonly) sqlite3 *database;

/**
 *  name of database file.
 */
@property (nonatomic, copy, readonly) NSString *databaseName;

/**
 *  file path of database
 */
@property (nonatomic, copy, readonly) NSString *databaseFilePath;

/**
 *  connect database with databaseName.
 *
 *  The file path will be located at NSLibraryDirectory. This method will create the database file if file not exists.
 *
 *  If you put database file name and Migrator Class name in CTPersistanceConfiguration.plist, this method will create Migrator by the Class name you defined, and create a version table if the database file is first created.
 *
 *  If migrator is not nil, this method will check whether to perform migration every time the connection to database established.
 *
 *  @param databaseName the file name of your database
 *  @param error        the error when create databse fails
 *
 *  @return return an instance of CTPersistanceDatabase
 */
- (instancetype)initWithDatabaseName:(NSString *)databaseName swiftModuleName:(NSString *)swiftModuleName error:(NSError **)error;

/**
 *  close the database connection.
 */
- (void)closeDatabase;

@end
