//
//  ItemDataCenter.m
//  CTPersistance
//
//  Created by casa on 2017/11/17.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "ItemDataCenter.h"

#import "ItemTable.h"
#import "ItemRecord.h"

#import "ItemDetailTable.h"
#import "ItemDetailRecord.h"

#import "ItemView+DataCenter.h"

@interface ItemDataCenter()

@property (nonatomic, strong) ItemTable *itemTable;
@property (nonatomic, strong) ItemDetailTable *itemDetailTable;

@end

@implementation ItemDataCenter

- (ItemView *)createNewItem
{
    ItemRecord *itemRecord = [[ItemRecord alloc] init];
    itemRecord.name = @"tree";
    [self.itemTable insertRecord:itemRecord error:NULL];
    
    ItemDetailRecord *itemDetailRecord = [[ItemDetailRecord alloc] init];
    itemDetailRecord.detail = @"this is a very tall tree";
    [self.itemDetailTable insertRecord:itemDetailRecord error:NULL];
    
    ItemView *itemView = [[ItemView alloc] init];
    itemView.itemRecordPrimaryKey = itemRecord.primaryKey;
    itemView.itemDetailRecordPrimaryKey = itemDetailRecord.primaryKey;
    
    [itemView mergeRecord:itemRecord shouldOverride:YES];
    [itemView mergeRecord:itemDetailRecord shouldOverride:YES];
    
    return itemView;
}

- (void)insert:(ItemView *)itemView
{
    [self.itemTable insertRecord:itemView error:NULL];
    itemView.itemRecordPrimaryKey = itemView.primaryKey;
    
    [self.itemDetailTable insertRecord:itemView error:NULL];
    itemView.itemDetailRecordPrimaryKey = itemView.primaryKey;

    [itemView setNeedsLayout];
}

- (void)updateItemToDataCenter:(ItemView *)itemView
{
    itemView.primaryKey = itemView.itemRecordPrimaryKey;
    [self.itemTable updateRecord:itemView error:NULL];
    
    itemView.primaryKey = itemView.itemDetailRecordPrimaryKey;
    [self.itemDetailTable updateRecord:itemView error:NULL];
}

- (void)updateItemFromDataCenter:(ItemView *)itemView
{
    // before we update the data of item view from data center, we should change the data in data center first.
    // you don't have to do this in real world;
    [self changeRecordContentWithItemRecordPrimaryKey:itemView.itemRecordPrimaryKey itemDetailRecordPrimaryKey:itemView.itemDetailRecordPrimaryKey];
    
    // now here is the real world code.
    ItemRecord *itemRecord = (ItemRecord *)[self.itemTable findWithPrimaryKey:itemView.itemRecordPrimaryKey error:NULL];
    [itemView mergeRecord:itemRecord shouldOverride:YES];
    
    ItemDetailRecord *itemDetailRecord = (ItemDetailRecord *)[self.itemDetailTable findWithPrimaryKey:itemView.itemDetailRecordPrimaryKey error:NULL];
    [itemView mergeRecord:itemDetailRecord shouldOverride:YES];
    
    [itemView setNeedsLayout];
}

- (void)deleteItem:(ItemView *)itemView
{
    [self.itemTable deleteWithPrimaryKey:itemView.itemRecordPrimaryKey error:NULL];
    [self.itemDetailTable deleteWithPrimaryKey:itemView.itemDetailRecordPrimaryKey error:NULL];
    
    itemView.name = @"";
    itemView.detail = @"I have been deleted";
    [itemView setNeedsLayout];
}

#pragma mark - private method

// this method changes the data in data center, that we should do before we update data from data center to item view
// you don't have to write this in real world, it's just a preparation for testing.
- (void)changeRecordContentWithItemRecordPrimaryKey:(NSNumber *)itemRecordPrimaryKey itemDetailRecordPrimaryKey:(NSNumber *)itemDetailRecordPrimaryKey
{
    ItemRecord *itemRecord = (ItemRecord *)[self.itemTable findWithPrimaryKey:itemRecordPrimaryKey error:NULL];
    itemRecord.name = @"house";
    [self.itemTable updateRecord:itemRecord error:NULL];
    
    ItemDetailRecord *itemDetailRecord = (ItemDetailRecord *)[self.itemDetailTable findWithPrimaryKey:itemDetailRecordPrimaryKey error:NULL];
    itemDetailRecord.detail = @"this is a very big house";
    [self.itemDetailTable updateRecord:itemDetailRecord error:NULL];
}

#pragma mark - getters and setters
- (ItemTable *)itemTable
{
    if (_itemTable == nil) {
        _itemTable = [[ItemTable alloc] init];
    }
    return _itemTable;
}

- (ItemDetailTable *)itemDetailTable
{
    if (_itemDetailTable == nil) {
        _itemDetailTable = [[ItemDetailTable alloc] init];
    }
    return _itemDetailTable;
}

@end
