//
//  NSString+Where.m
//  CTPersistance
//
//  Created by casa on 2017/8/4.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "NSString+Where.h"
#import "NSMutableArray+CTPersistanceBindValue.h"

@implementation NSString (Where)

- (NSString *)whereStringWithConditionParams:(NSDictionary *)conditionParams bindValueList:(NSMutableArray<NSInvocation *> *)bindValueList
{
    NSMutableString *whereString = [self mutableCopy];
    [conditionParams enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        NSMutableString *valueKey = [key mutableCopy];
        [valueKey deleteCharactersInRange:NSMakeRange(0, 1)];
        [valueKey insertString:@":CTPersistanceWhere_" atIndex:0];
        [whereString replaceOccurrencesOfString:key withString:valueKey options:0 range:NSMakeRange(0, whereString.length)];
        [bindValueList addBindKey:valueKey bindValue:value];
    }];
    return whereString;
}

@end
