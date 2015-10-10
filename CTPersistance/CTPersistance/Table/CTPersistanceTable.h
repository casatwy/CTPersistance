//
//  CTPersistanceModel.h
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTPersistanceRecord.h"

@class CTPersistanceQueryCommand;

/**
 *  the protocol which every table should confirm.
 */
@protocol CTPersistanceTableProtocol <NSObject>
@required
/**
 *  return the name of databse file, CTPersistanceDatabasePool will create CTDatabase by this string.
 *
 *  @return return the name of database file
 */
- (NSString *)databaseName;

/**
 *  the name of your table
 *
 *  @return return the name of your table
 */
- (NSString *)tableName;

/**
 *  column info with this table. If table not exists in database, CTPersistance will create a table based on the column info you provided
 *
 *  @return return the column info of your table
 */
- (NSDictionary *)columnInfo;

/**
 *  the Class of the record.
 *
 *  CTPersistanceTable will transform data into the object you want, so this class is the class of the result object you want CTPersistanceTable to transform. You can add a setter for recordClass in order to change the class every time CTPersisitanceTable fetches data.
 *
 *  @return return the class of the record
 */
- (Class)recordClass;

/**
 *  the name of the primary key.
 *
 *  @return return the name of the primary key.
 */
- (NSString *)primaryKeyName;

@optional
/**
 *  modify current database name.
 *
 *  sometimes, especially when migration, the table will be create with CTPersistanceQueryCommand, and the database name of CTPersistanceQueryCommand is not match to this table, so query command will ask you to change database.
 *
 *  and in some other time, you have many databases, they share the same table. If you want your current table to work for the new database, you should modify the database name of this table.
 *
 *  @param newDatabaseName the new database name.
 */
- (void)modifyDatabaseName:(NSString *)newDatabaseName;

/**
 *  to check record before insert
 *
 *  some times we want to validate the record before it been insert into database, so you can implement this method in your table to check every record waiting to insert. Return NO will prevent record been insert.
 *
 *  @param record the record waiting to insert
 *
 *  @return return the result of validation.
 */
- (BOOL)isCorrectToInsertRecord:(NSObject <CTPersistanceRecordProtocol> *)record;

/**
 *  to check record before update
 *
 *  some times we want to validate the record before it been update into database, so you can implement this method in your table to check every record waiting to update. Return NO will prevent record been update.
 *
 *  @param record the record waiting to update
 *
 *  @return return the result of validation
 */
- (BOOL)isCorrectToUpdateRecord:(NSObject <CTPersistanceRecordProtocol> *)record;
@end

@interface CTPersistanceTable : NSObject

/**
 *  create tabel with CTPersistanceQueryCommand, you should not create any table with this method.
 *
 *  @param queryCommand the query command
 *
 *  @return return instance of CTPersistanceTable
 */
- (instancetype)initWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand;

/**
 *  the child is just the same as self. just to make sure your own CTPersistance table is confirm to <CTPersistanceTableProtocol>
 */
@property (nonatomic, weak, readonly) CTPersistanceTable <CTPersistanceTableProtocol> *child;

/**
 *  query command for you for debug.
 *
 *  @see CTPersistanceQueryCommand
 */
@property (nonatomic, strong, readonly) CTPersistanceQueryCommand *queryCommand;

@end
