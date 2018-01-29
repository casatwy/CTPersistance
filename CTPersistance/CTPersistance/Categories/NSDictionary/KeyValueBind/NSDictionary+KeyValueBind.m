//
//  NSDictionary+KeyValueBind.m
//  CTPersistance
//
//  Created by casa on 2017/8/4.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "NSDictionary+KeyValueBind.h"
#import "NSMutableArray+CTPersistanceBindValue.h"

@implementation NSDictionary (KeyValueBind)

- (NSString *)bindToValueList:(NSMutableArray <NSInvocation *> *)bindValueList
{
    NSMutableArray *valueList = [[NSMutableArray alloc] init];

    [self enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        NSString *valueKey = [NSString stringWithFormat:@":%@", key];
        if ([value isKindOfClass:[NSNull class]]) {
            [valueList addObject:[NSString stringWithFormat:@"%@ is %@", key, valueKey]];
        } else {
            [valueList addObject:[NSString stringWithFormat:@"%@ = %@", key, valueKey]];
        }
        [bindValueList addBindKey:valueKey bindValue:value];
    }];

    return [valueList componentsJoinedByString:@","];
}

- (NSString *)bindToUpdateValueList:(NSMutableArray<NSInvocation *> *)bindUpdateValueList
{
    NSMutableArray *valueList = [[NSMutableArray alloc] init];
    
    [self enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        NSString *valueKey = [NSString stringWithFormat:@":%@", key];
        [valueList addObject:[NSString stringWithFormat:@"%@ = %@", key, valueKey]];
        [bindUpdateValueList addBindKey:valueKey bindValue:value];
    }];
    
    return [valueList componentsJoinedByString:@","];
}

@end
