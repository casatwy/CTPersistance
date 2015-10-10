//
//  CTPersistanceRecord.h
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceRecordProtocol.h"

/**
 *  this is a record implemented by me, you can create your own Record as long as it confirms to <CTPersistanceRecordProtocol>
 *  you can just extend this class for convenience.
 */
@interface CTPersistanceRecord : NSObject <CTPersistanceRecordProtocol>
@end
