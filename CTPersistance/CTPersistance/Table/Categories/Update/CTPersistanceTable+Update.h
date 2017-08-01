//
//  CTPersistanceTable+Update.h
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceTable.h"
#import "CTPersistanceRecord.h"

@interface CTPersistanceTable (Update)

/**
 *  update a record
 *
 *  @param record the record you want to update
 *  @param error  error if fails
 */
- (void)updateRecord:(NSObject <CTPersistanceRecordProtocol> *)record error:(NSError **)error;

/**
 *  udpate a list of record
 *
 *  @param recordList the list of record to update
 *  @param error      error if fails
 */
- (void)updateRecordList:(NSArray <NSObject <CTPersistanceRecordProtocol> *> *)recordList error:(NSError **)error;

/**
 *  update value for key which the row matches whereCondition, @see deleteWithWhereCondition:conditionParams:error:
 *
 *  @param value                the value to update
 *  @param key                  the key of the column to update
 *  @param whereCondition       where condition
 *  @param whereConditionParams params for where condition
 *  @param error                error if fails
 */
- (void)updateValue:(id)value forKey:(NSString *)key whereCondition:(NSString *)whereCondition whereConditionParams:(NSDictionary *)whereConditionParams error:(NSError **)error;

/**
 *  update keys and values of rows matches whereCondition, @see deleteWithWhereCondition:conditionParams:error:
 *
 *  @param keyValueList         key-values to update
 *  @param whereCondition       where contidition
 *  @param whereConditionParams params for where condition
 *  @param error                error if fails
 */
- (void)updateKeyValueList:(NSDictionary *)keyValueList whereCondition:(NSString *)whereCondition whereConditionParams:(NSDictionary *)whereConditionParams error:(NSError **)error;

/**
 *  update value for key by primary key
 *
 *  @param value           value to update
 *  @param key             key to update
 *  @param primaryKeyValue primary key of the record you want to update
 *  @param error           error if fails
 */
- (void)updateValue:(id)value forKey:(NSString *)key primaryKeyValue:(NSNumber *)primaryKeyValue error:(NSError **)error;

/**
 *  update value for key by primary list
 *
 *  @param value               value to update
 *  @param key                 key to update
 *  @param primaryKeyValueList the list of primary key
 *  @param error               error if fails
 */
- (void)updateValue:(id)value forKey:(NSString *)key primaryKeyValueList:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error;

/**
 *  update value for key1, where key2 in a list
 *
 *  @param value        value to update
 *  @param key          key for value to update
 *  @param wherekey     keyname to search
 *  @param valueList    keyname's value list
 *  @param error        error if fails
 */
- (void)updateValue:(id)value forKey:(NSString *)key whereKey:(NSString *)wherekey inList:(NSArray *)valueList error:(NSError *__autoreleasing *)error;

/**
 *  update key-value list by primary key of the record you want to update
 *
 *  @param keyValueList    key-value list to update
 *  @param primaryKeyValue the primary key of the record you want to update
 *  @param error           error if fails
 */
- (void)updateKeyValueList:(NSDictionary *)keyValueList primaryKeyValue:(NSNumber *)primaryKeyValue error:(NSError **)error;

/**
 *  update key-value list by primary key list of the record you want to update
 *
 *  @param keyValueList        key-value list to update
 *  @param primaryKeyValueList the primary key list of records you want to update
 *  @param error               error if fails
 */
- (void)updateKeyValueList:(NSDictionary *)keyValueList primaryKeyValueList:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error;
@end
