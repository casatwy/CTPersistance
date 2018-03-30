//
//  CTPersistanceTable+Find.h
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceTable.h"
#import "CTPersistanceRecord.h"

@interface CTPersistanceTable (Find)

/**
 *  find all the record in the table
 *
 *  @param error error if find fails
 *
 *  @return return all the record.
 */
- (NSArray <NSObject<CTPersistanceRecordProtocol> *> *)findAllWithError:(NSError **)error;

/**
 *  find the latest record
 *
 *  @param error error if find fails
 *
 *  @return return the latest record.
 */
- (NSObject <CTPersistanceRecordProtocol> *)findLatestRecordWithError:(NSError **)error;

/**
 *  find all record with where condition. @see - (void)deleteWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams error:(NSError **)error: for how to use where condition.
 *
 *  @param condition       the where condition
 *  @param conditionParams the params to bind into where condition
 *  @param isDistinct      if YES, will use 'SELECT DISTINCT' clause.
 *  @param error           error if fails
 *
 *  @return return the record list.
 */
- (NSArray <NSObject <CTPersistanceRecordProtocol> *> *)findAllWithWhereCondition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams isDistinct:(BOOL)isDistinct error:(NSError **)error;

/**
 *  find all record with sql string. sqlString can be bind with params like where condition. @see - (void)deleteWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams error:(NSError **)error: for how to use where condition.
 *
 *  @param sqlString the sqlString for finding all records
 *  @param params    the params to be bind into sqlString
 *  @param error     error if fails
 *
 *  @return return the record list
 */
- (NSArray <NSObject <CTPersistanceRecordProtocol> *> *)findAllWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error;

/**
 *  find first row in record list with where condition.  @see - (void)deleteWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams error:(NSError **)error: for how to use where condition. First row means the first record of fetched record list, not the first record in table.
 *
 *  @param condition       condition used in WHERE clause
 *  @param conditionParams params to bind into whereCondition
 *  @param isDistinct      if YES, will use 'SELECT DISTINCT' clause
 *  @param error           error if fails
 *
 *  @return return a record
 */
- (NSObject <CTPersistanceRecordProtocol> *)findFirstRowWithWhereCondition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams isDistinct:(BOOL)isDistinct error:(NSError **)error;

/**
 *  find first record with sqlString. sqlString can be bind with params like where condition. @see - (void)deleteWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams error:(NSError **)error: for how to use where condition.
 *
 *  First row means the first record of fetched record list, not the first record in table.
 *
 *  @param sqlString the sqlString to find
 *  @param params    the params to bind into sqlString
 *  @param error     error if fails
 *
 *  @return return the first row.
 */
- (NSObject <CTPersistanceRecordProtocol> *)findFirstRowWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error;

/**
 *  return total record count in this table
 *
 *  @return return total record count in this table
 */
- (NSInteger)countTotalRecord;

/**
 *  record count of record list with matches where condition. @see deleteWithWhereCondition:conditionParams:error: for how to use where condition.
 *
 *  @param whereCondition  condition used in WHERE clause
 *  @param conditionParams params ro bind into whereCondition
 *  @param error           error if fails
 *
 *  @return return record count of record list with matches where condition.
 */
- (NSInteger)countWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams error:(NSError **)error;

/**
 *  return count of record list by SQL. sqlString can be bind with params like where condition. @see deleteWithWhereCondition:conditionParams:error: for how to use where condition.
 *
 *  @param sqlString    the sqlString to count
 *  @param params       the params to bind into sqlString
 *  @param error        error if fails
 *
 *  @return             return count as NSInteger.
 */
- (NSInteger)countWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error;

/**
 *  find a record with primary key.
 *
 *  @param primaryKeyValue the primary key of the record you want to find
 *  @param error           error if fails
 *
 *  @return return a record
 */
- (NSObject <CTPersistanceRecordProtocol> *)findWithPrimaryKey:(NSNumber *)primaryKeyValue error:(NSError **)error;

/**
 *  find all records by primary key list
 *
 *  @param primaryKeyValueList list of primary keys to find
 *  @param error               error if fails
 *
 *  @return return a list of record
 */
- (NSArray <NSObject <CTPersistanceRecordProtocol> *> *)findAllWithPrimaryKey:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error;

/**
 *  find all keyname's value equal to value
 *
 *  @param keyname key name
 *  @param value   value of key name
 *  @param error   error if fails
 *
 *  @return return a list of record
 */
- (NSArray <NSObject <CTPersistanceRecordProtocol> *> *)findAllWithKeyName:(NSString *)keyname value:(id)value error:(NSError **)error;


/**
 *  find all keyname's value equal to value
 *
 *  @param keyname      key name
 *  @param valueList    a list of value
 *  @param error        error if fails
 *
 *  @return return a list of record
 */
- (NSArray <NSObject <CTPersistanceRecordProtocol> *> *)findAllWithKeyName:(NSString *)keyname inValueList:(NSArray *)valueList error:(NSError **)error;

@end
