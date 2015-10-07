//
//  NSArray+CTPersistanceRecordTransform.h
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (CTPersistanceRecordTransform)

- (NSArray *)transformSQLItemsToClass:(Class)classType;

@end
