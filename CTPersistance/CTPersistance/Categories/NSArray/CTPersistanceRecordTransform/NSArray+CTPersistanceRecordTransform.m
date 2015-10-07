//
//  NSArray+CTPersistanceRecordTransform.m
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "NSArray+CTPersistanceRecordTransform.h"
#import "CTPersistanceRecord.h"

@implementation NSArray (CTPersistanceRecordTransform)

- (NSArray *)transformSQLItemsToClass:(Class)classType
{
    NSMutableArray *recordList = [[NSMutableArray alloc] init];
    if ([self count] > 0) {
        [self enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull recordInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            NSObject <CTPersistanceRecordProtocol> *record = [[classType alloc] init];
            if ([record respondsToSelector:@selector(objectRepresentationWithDictionary:)]) {
                [record objectRepresentationWithDictionary:recordInfo];
                [recordList addObject:record];
            }
        }];
    }
    return recordList;
}

@end
