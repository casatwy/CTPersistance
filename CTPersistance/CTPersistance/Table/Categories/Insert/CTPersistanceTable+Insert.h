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
 *  @param recordList the list of record to insert
 *  @param error      error if fails
 *
 *  @return return the last insert row primary key
 */
- (NSNumber *)insertRecordList:(NSArray <NSObject <CTPersistanceRecordProtocol> *> *)recordList error:(NSError **)error;

/**
 *  insert a record
 *
 *  @param record the record to insert
 *  @param error  error if fails
 *
 *  @return return the primary key
 */
- (NSObject <CTPersistanceRecordProtocol> *)insertRecord:(NSObject <CTPersistanceRecordProtocol> *)record error:(NSError **)error;

@end
