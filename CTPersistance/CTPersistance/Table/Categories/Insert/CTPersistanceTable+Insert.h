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

- (NSNumber *)insertRecordList:(NSArray <NSObject <CTPersistanceRecordProtocol> *> *)recordList error:(NSError **)error;
- (NSObject <CTPersistanceRecordProtocol> *)insertRecord:(NSObject <CTPersistanceRecordProtocol> *)record error:(NSError **)error;

@end
