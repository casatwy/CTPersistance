//
//  NSArray+CTPersistanceRecordTransform.h
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTPersistanceRecord.h"

/**
 *  category to transform items to object
 */
@interface NSArray (CTPersistanceRecordTransform)

/**
 *  Transform items in Array to the Object by classType, the classType must confirms to <CTPersistanceRecordProtocol>, if the classType is not confirmed to <CTPersistanceRecordProtocol>, this method will return an empty array, not nil.
 *
 *  @param classType the class of result Object
 *
 *  @return return the list of transformed objects
 */
- (NSArray *)transformSQLItemsToClass:(Class<CTPersistanceRecordProtocol>)classType;

@end
