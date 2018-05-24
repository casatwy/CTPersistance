//
//  CTPersistanceTable+Upsert.h
//  CTPersistance
//
//  Created by casa on 2018/5/17.
//  Copyright © 2018年 casa. All rights reserved.
//

#import "CTPersistanceTable.h"

@interface CTPersistanceTable (Upsert)

- (void)upsertRecord:(NSObject <CTPersistanceRecordProtocol> *)record uniqKeyName:(NSString *)uniqKeyName shouldUpdateNilValueToDatabase:(BOOL)shouldUpdateNilValueToDatabase error:(NSError **)error;

@end
