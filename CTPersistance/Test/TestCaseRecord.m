//
//  TestCaseRecord.m
//  CTPersistance
//
//  Created by casa on 15/10/8.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "TestCaseRecord.h"
#import "TestRecord.h"

@implementation TestCaseRecord

- (void)test
{
    /* test 5001 */
    TestRecord *recordA = [[TestRecord alloc] init];
    recordA.primaryKey = @(1);
    recordA.age = @(2);
    recordA.name = @"casa";
    
    TestRecord *recordB = [[TestRecord alloc] init];
    [recordB mergeRecord:recordA shouldOverride:YES];
    
    if ([recordB.primaryKey integerValue] == 1 && [recordB.age integerValue] == 2 && [recordB.name isEqualToString:@"casa"]) {
        NSLog(@"5001 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    
    /* test 5002*/
    recordB.age = @(3);
    [recordB mergeRecord:recordA shouldOverride:NO];
    
    if ([recordB.primaryKey integerValue] == 1 && [recordB.age integerValue] == 3 && [recordB.name isEqualToString:@"casa"]) {
        NSLog(@"5002 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    
    /* test 5003 */
    [self cleanRecord:recordA];
    [recordB mergeRecord:recordA shouldOverride:YES];
    
    if (recordB.primaryKey == nil && recordB.age == nil && recordB.name == nil) {
        NSLog(@"5003 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
}

- (void)cleanRecord:(TestRecord *)record
{
    record.primaryKey = nil;
    record.age = nil;
    record.name = nil;
}

@end
