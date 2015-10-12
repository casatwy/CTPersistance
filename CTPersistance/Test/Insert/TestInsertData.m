//
//  TestInsertDataCenter.m
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "TestInsertData.h"

#import "TestTable.h"
#import "CTPersistance.h"

@implementation TestInsertData

- (void)test
{
    NSError *error = nil;
    
    /* test 1001 */
    TestTable *table = [[TestTable alloc] init];
    TestRecord *record = [[TestRecord alloc] init];
    record.age = @(1);
    record.name = @"1";
    record = (TestRecord *)[table insertRecord:record error:&error];
    if ([record.primaryKey integerValue] > 0 || error != nil) {
        NSLog(@"1001 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    
    /* test 1002 */
    error = nil;
    record = [[TestRecord alloc] init];
    record = (TestRecord *)[table insertRecord:record error:&error];
    if ([record.primaryKey integerValue] > 0 || error != nil) {
        NSLog(@"1002 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    
    /* test 1003 */
    error = nil;
    record = (TestRecord *)[table insertRecord:nil error:&error];
    if ([record.primaryKey integerValue] > 0 || error != nil) {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    } else {
        NSLog(@"1003 success");
    }
    
    /* test 1004 */
    error = nil;
    NSMutableArray *recordList = [[NSMutableArray alloc] init];
    NSUInteger count = 100;
    while (count --> 0) {
        record = [[TestRecord alloc] init];
        record.age = @(count);
        record.name = [NSString stringWithFormat:@"%ld", count];
        [recordList addObject:record];
    }
    NSNumber *lastInsertRowId = [table insertRecordList:recordList error:&error];
    if ([lastInsertRowId integerValue] > 0 || error != nil) {
        NSLog(@"1004 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    
    /* test 1005 */
    error = nil;
    lastInsertRowId = [table insertRecordList:nil error:&error];
    if ([lastInsertRowId integerValue] > 0 || error != nil) {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    } else {
        NSLog(@"1005 success");
    }
}

@end
