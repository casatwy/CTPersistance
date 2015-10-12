//
//  CTPersistanceRecordProtocol.h
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#ifndef CTPersistanceRecordProtocol_h
#define CTPersistanceRecordProtocol_h

#import <Foundation/Foundation.h>

@class CTPersistanceTable;
@protocol CTPersistanceTableProtocol;

/**
 *  CTPersistanceTable will transform the fetched data into an object. The object must confirms to this protocol, that means every object who confirms to this protocol can be the record of CTPersistanceTable
 *
 *  @warning the name of key must as same as the name of column in table.
 */
@protocol CTPersistanceRecordProtocol <NSObject>

@required
/**
 *  transform record into dictionary based with column infomation and table name
 *
 *  @param table   the instance of CTPersistanceTable
 *
 *  @return return the dicitonary of record data.
 */
- (NSDictionary *)dictionaryRepresentationWithTable:(CTPersistanceTable <CTPersistanceTableProtocol> *)table;

/**
 *  config your record with dictionary.
 *
 *  @param dictionary the data fetched with CTPersistanceTable
 */
- (void)objectRepresentationWithDictionary:(NSDictionary *)dictionary;

/**
 *  CTPersistanceTable will set data by this method, this method can also be called when merge another record.
 *
 *  @param value the value in fetched data
 *  @param key   the key in fetched data
 */
- (void)setPersistanceValue:(id)value forKey:(NSString *)key;

/**
 *  merge record
 *
 *  @param record         the record to merge
 *  @param shouldOverride if YES, the data in record param will override the data in self.
 *
 *  @return return the merged record
 */
- (NSObject <CTPersistanceRecordProtocol> *)mergeRecord:(NSObject <CTPersistanceRecordProtocol> *)record shouldOverride:(BOOL)shouldOverride;

@optional

/**
 *  if you want to make this record able to merge, you should return all keys available when merging.
 *
 *  @return return the available key list.
 */
- (NSArray *)availableKeyList;

@end

#endif /* CTPersistanceRecordProtocol_h */
