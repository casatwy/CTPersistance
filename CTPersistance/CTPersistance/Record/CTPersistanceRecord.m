//
//  CTPersistanceRecord.m
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceRecord.h"
#import "objc/runtime.h"
#import "NSString+SQL.h"

@implementation CTPersistanceRecord

#pragma mark - CTPersistanceRecordProtocol
- (NSDictionary *)dictionaryRepresentation
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableDictionary *dictionaryRepresentation = [[NSMutableDictionary alloc] init];
    while (count --> 0) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[count])];
        if ([key isEqualToString:@"debugDescription"]) {
            continue;
        }
        if ([key isEqualToString:@"description"]) {
            continue;
        }
        if ([key isEqualToString:@"superclass"]) {
            continue;
        }
        if ([key isEqualToString:@"hash"]) {
            continue;
        }
        
        id value = [self valueForKey:key];
        if (value == nil) {
            dictionaryRepresentation[key] = [NSNull null];
        } else {
            dictionaryRepresentation[key] = value;
        }
    }
    free(properties);
    return dictionaryRepresentation;
}

- (void)objectRepresentationWithDictionary:(NSDictionary *)dictionary
{
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull value, BOOL * _Nonnull stop) {
        [self setPersistanceValue:value forKey:key];
    }];
}

- (void)setPersistanceValue:(id)value forKey:(NSString *)key
{
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", [[key substringToIndex:1] capitalizedString], [key substringFromIndex:1]];
    if ([self respondsToSelector:NSSelectorFromString(setter)]) {
        if ([value isKindOfClass:[NSString class]]) {
            [self setValue:[value safeSQLDecode] forKey:key];
        } else if ([value isKindOfClass:[NSNull class]]) {
            [self setValue:nil forKey:key];
        } else {
            [self setValue:value forKey:key];
        }
    }
}

@end
