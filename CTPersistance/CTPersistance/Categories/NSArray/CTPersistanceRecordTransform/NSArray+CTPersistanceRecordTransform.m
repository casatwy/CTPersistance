//
//  NSArray+CTPersistanceRecordTransform.m
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "NSArray+CTPersistanceRecordTransform.h"
#import <CTMediator/CTMediator.h>

@implementation NSArray (CTPersistanceRecordTransform)

- (NSArray *)transformSQLItemsToClass:(Class)classType isSwift:(BOOL)isSwift
{
    if (isSwift) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        params[kCTMediatorParamsKeySwiftTargetModuleName] = @"CTPersistance_Swift";
        NSMutableArray *recordList = [[NSMutableArray alloc] init];
        for (id item in self) {
            [recordList addObject:[[classType alloc] init]];
        }
        params[@"recordList"] = recordList;
        params[@"data"] = self;
        return [[CTMediator sharedInstance] performTarget:@"" action:@"classPresentation" params:params shouldCacheTarget:YES];
    }
    NSMutableArray *recordList = [[NSMutableArray alloc] init];
    if ([self count] > 0) {
        [self enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull recordInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            id <CTPersistanceRecordProtocol> record = [[classType alloc] init];
            if ([record respondsToSelector:@selector(objectRepresentationWithDictionary:)]) {
                [record objectRepresentationWithDictionary:recordInfo];
                [recordList addObject:record];
            }
        }];
    }
    return recordList;
}

@end
