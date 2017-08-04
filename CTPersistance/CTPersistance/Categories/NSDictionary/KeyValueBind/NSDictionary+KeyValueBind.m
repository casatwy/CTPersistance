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
        [valueList addObject:[NSString stringWithFormat:@"%@ = %@", key, valueKey]];
        [bindValueList addBindKey:valueKey bindValue:value columnDescription:nil];
    }];

    return [valueList componentsJoinedByString:@","];
}

@end
