//
//  CTPersistanceRecord.m
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceRecord.h"
#import "objc/runtime.h"
#import "CTPersistanceTable.h"

@implementation CTPersistanceRecord

#pragma mark - CTPersistanceRecordProtocol
- (NSDictionary *)dictionaryRepresentationWithTable:(CTPersistanceTable<CTPersistanceTableProtocol> *)table
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableDictionary *propertyList = [[NSMutableDictionary alloc] init];
    while (count --> 0) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[count])];
        id value = [self valueForKey:key];
        if (value == nil) {
            propertyList[key] = [NSNull null];
        } else {
            propertyList[key] = value;
        }
    }
    free(properties);
    
    NSMutableDictionary *dictionaryRepresentation = [[NSMutableDictionary alloc] init];
    [table.columnInfo enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull columnName, NSString * _Nonnull columnDescription, BOOL * _Nonnull stop) {
        if (propertyList[columnName]) {
            dictionaryRepresentation[columnName] = propertyList[columnName];
        }
    }];
    
    return dictionaryRepresentation;
}

- (void)objectRepresentationWithDictionary:(NSDictionary *)dictionary
{
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull value, BOOL * _Nonnull stop) {
        [self setPersistanceValue:value forKey:key];
    }];
}

- (BOOL)setPersistanceValue:(id)value forKey:(NSString *)key
{
    BOOL result = YES;
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", [[key substringToIndex:1] capitalizedString], [key substringFromIndex:1]];
    if ([self respondsToSelector:NSSelectorFromString(setter)]) {
        if ([value isKindOfClass:[NSString class]]) {
#warning todo modify set value
            [self setValue:value forKey:key];
        } else if ([value isKindOfClass:[NSNull class]]) {
            [self setValue:nil forKey:key];
        } else {
            [self setValue:value forKey:key];
        }
    } else {
        result = NO;
    }
    
    return result;
}

- (NSObject<CTPersistanceRecordProtocol> *)mergeRecord:(NSObject<CTPersistanceRecordProtocol> *)record shouldOverride:(BOOL)shouldOverride
{
    if ([self respondsToSelector:@selector(availableKeyList)]) {
        NSArray *availableKeyList = [self availableKeyList];
        [availableKeyList enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([record respondsToSelector:NSSelectorFromString(key)]) {
                id recordValue = [record valueForKey:key];
                if (shouldOverride) {
                    [self setPersistanceValue:recordValue forKey:key];
                } else {
                    id selfValue = [self valueForKey:key];
                    if (selfValue == nil) {
                        [self setPersistanceValue:recordValue forKey:key];
                    }
                }
            }
        }];
    }
    return self;
}

@end
