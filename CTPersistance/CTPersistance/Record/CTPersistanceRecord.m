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
        if (!propertyList[columnName]) {
            return;
        }

        dictionaryRepresentation[columnName] = propertyList[columnName];

        if (propertyList[columnName] != [NSNull null]) {
            return;
        }

        //setting default value
        if(table.columnDetaultValue) {
            id defaultValue = [table.columnDetaultValue valueForKey:columnName];

            if(defaultValue) {
                dictionaryRepresentation[columnName] = defaultValue;
            }
        }
    }];

    return dictionaryRepresentation;
}

- (void)objectRepresentationWithDictionary:(NSDictionary *)dictionary
{
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull value, BOOL * _Nonnull stop) {
        [self setValue:value forKey:key];
    }];
}

- (NSObject<CTPersistanceRecordProtocol> *)mergeRecord:(NSObject<CTPersistanceRecordProtocol> *)record shouldOverride:(BOOL)shouldOverride
{
    if ([self respondsToSelector:@selector(availableKeyList)]) {
        NSArray *availableKeyList = [self availableKeyList];
        [availableKeyList enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([record respondsToSelector:NSSelectorFromString(key)]) {
                id recordValue = [record valueForKey:key];
                if (shouldOverride) {
                    [self setValue:recordValue forKey:key];
                } else {
                    id selfValue = [self valueForKey:key];
                    if (selfValue == nil) {
                        [self setValue:recordValue forKey:key];
                    }
                }
            }
        }];
    }
    return self;
}

#pragma mark - method override
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // do nothing
}

@end
