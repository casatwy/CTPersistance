//
//  CTPersistanceTable+Insert.h
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceTable.h"
#import "CTPersistanceRecord.h"

@interface CTPersistanceTable (Insert)

/**
 *  insert a list of record
 *
 *  the record failed to insert will be included into error's userinfo, which key is kCTPersistanceErrorUserinfoKeyErrorRecord
 *
 *  if the record list is nil or empty, this method will return YES and error is nil.
 *
 *  @param recordList the list of record to insert
 *  @param error      error if fails
 *
 *  @return return YES if success
 *
 *  @warning if the record list is nil or empty, this method will return YES and error is nil.
 */
- (BOOL)insertRecordList:(NSArray <NSObject <CTPersistanceRecordProtocol> *> *)recordList error:(NSError **)error;

/**
 *  insert a record
 *
 *  the record failed to insert will be included into error's userinfo, which key is kCTPersistanceErrorUserinfoKeyErrorRecord
 *
 *  if the record to insert is nil, this method will return YES and error is nil.
 *
 *  @param record the record to insert
 *  @param error  error if fails
 *
 *  @return return YES if success
 *
 *  @warning if the record is nil or empty, this method will return YES and error is nil.
 */
- (BOOL)insertRecord:(NSObject <CTPersistanceRecordProtocol> *)record error:(NSError **)error;

@end
