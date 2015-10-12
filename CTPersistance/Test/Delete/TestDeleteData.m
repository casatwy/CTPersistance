//
//  TestDeleteData.m
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "TestDeleteData.h"
#import "CTPersistance.h"
#import "TestTable.h"

@implementation TestDeleteData

- (void)test
{
    NSError *error = nil;
    TestTable *table = [[TestTable alloc] init];
    TestRecord *record = nil;
    
    /* 4001 */
    record = [[TestRecord alloc] init];
    [table insertRecord:record error:&error];
    NSNumber *primaryKey = [record.primaryKey copy];
    error = nil;
    [table deleteRecord:record error:&error];
    error = nil;
    record = (TestRecord *)[table findWithPrimaryKey:primaryKey error:&error];
    if (record) {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    } else {
        NSLog(@"4001 success");
    }
    
    /* 4002 */
    NSMutableArray *primaryKeyList = [[NSMutableArray alloc] init];
    NSUInteger count = 10;
    
    while (count --> 0) {
        record = [[TestRecord alloc] init];
        record.tomas = @"1";
        [table insertRecord:record error:&error];
        [primaryKeyList addObject:[record.primaryKey copy]];
    }
    
    NSArray *recordList = [table findAllWithPrimaryKey:primaryKeyList error:&error];
    if ([recordList count] == 0) {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    
    error = nil;
    [table deleteWithPrimaryKeyList:primaryKeyList error:&error];
    error = nil;
    recordList = [table findAllWithPrimaryKey:primaryKeyList error:&error];
    if ([recordList count] > 0) {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    } else {
        NSLog(@"4002 success");
    }
}

@end
