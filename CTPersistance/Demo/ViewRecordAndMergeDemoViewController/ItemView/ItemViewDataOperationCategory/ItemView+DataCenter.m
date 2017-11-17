//
//  ItemView+DataCenter.m
//  CTPersistance
//
//  Created by casa on 2017/11/17.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "ItemView+DataCenter.h"
#import "ItemTable.h"
#import "ItemDetailTable.h"
#import <objc/runtime.h>

void *kItemViewPrimaryKey = &kItemViewPrimaryKey;
void *kItemViewItemRecordPrimaryKey = &kItemViewItemRecordPrimaryKey;
void *kItemViewItemDetailRecordPrimaryKey = &kItemViewItemDetailRecordPrimaryKey;

@implementation ItemView (DataCenter)

#pragma mark - CTPersistanceRecordProtocol

- (NSDictionary *)dictionaryRepresentationWithTable:(CTPersistanceTable <CTPersistanceTableProtocol> *)table
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];

    if ([table isKindOfClass:[ItemTable class]]) {
        result[@"name"] = self.name;
    }

    if ([table isKindOfClass:[ItemDetailTable class]]) {
        result[@"detail"] = self.detail;
    }

    return result;
}

- (void)objectRepresentationWithDictionary:(NSDictionary *)dictionary
{
    self.name = dictionary[@"name"];
    self.detail = dictionary[@"detail"];
}

- (NSObject <CTPersistanceRecordProtocol> *)mergeRecord:(NSObject <CTPersistanceRecordProtocol> *)record shouldOverride:(BOOL)shouldOverride
{
    NSArray *availableKeyList = [self availableKeyList];
    [availableKeyList enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {

        if ([record respondsToSelector:NSSelectorFromString(key)]) {

            id recordValue = [record valueForKey:key];
            if ([recordValue isKindOfClass:[NSNull class]]) {
                recordValue = nil;
            }
            id selfValue = [self valueForKey:key];

            if (shouldOverride || selfValue == nil) {
                [self setValue:recordValue forKey:key];
            }
        }
    }];
    return self;
}

- (NSArray *)availableKeyList
{
    return @[@"name", @"detail"];
}

#pragma mark - getters and setters
- (NSNumber *)itemRecordPrimaryKey
{
    return objc_getAssociatedObject(self, kItemViewItemRecordPrimaryKey);
}

- (void)setItemRecordPrimaryKey:(NSNumber *)itemRecordPrimaryKey
{
    objc_setAssociatedObject(self, kItemViewItemRecordPrimaryKey, itemRecordPrimaryKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)itemDetailRecordPrimaryKey
{
    return objc_getAssociatedObject(self, kItemViewItemDetailRecordPrimaryKey);
}

- (void)setItemDetailRecordPrimaryKey:(NSNumber *)itemDetailRecordPrimaryKey
{
    objc_setAssociatedObject(self, kItemViewItemDetailRecordPrimaryKey, itemDetailRecordPrimaryKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)primaryKey
{
    return objc_getAssociatedObject(self, kItemViewPrimaryKey);
}

- (void)setPrimaryKey:(NSNumber *)primaryKey
{
    objc_setAssociatedObject(self, kItemViewPrimaryKey, primaryKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
