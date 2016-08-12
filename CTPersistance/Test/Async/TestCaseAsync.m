//
//  TestCaseAsync.m
//  CTPersistance
//
//  Created by casa on 15/10/22.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "TestCaseAsync.h"

#import "TestTable.h"
#import "CTPersistance.h"

@implementation TestCaseAsync

- (void)test
{
    
    /* test 7001 */
    [[CTPersistanceAsyncExecutor sharedInstance] performAsyncAction:^{
        NSUInteger count = 500;
        NSError *error = nil;
        TestTable *testTable = [[TestTable alloc] init];
        while (count --> 0) {
            TestRecord *record = [[TestRecord alloc] init];
            record.age = @(count);
            record.name = @"name";
            record.tomas = @"tomas";
            [testTable insertRecord:record error:&error];
            if (error) {
                NSLog(@"error is %@", error);
                NSException *exception = [[NSException alloc] init];
                @throw exception;
            }
        }
    } shouldWaitUntilDone:NO];
    
    NSError *error = nil;
    TestTable *mainTestTable = [[TestTable alloc] init];
    NSUInteger count = 500;
    while (count --> 0) {
        TestRecord *record = [[TestRecord alloc] init];
        record.age = @(count);
        record.name = @"name";
        record.tomas = @"main";

        /* will crash here, should use different table in different thread */
//        [testTable insertRecord:record error:&error];
        
        [mainTestTable insertRecord:record error:&error];
        if (error) {
            NSLog(@"error is %@", error);
            NSException *exception = [[NSException alloc] init];
            @throw exception;
        }
    }
    
    if (error) {
        NSLog(@"error is %@", error);
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    } else {
        NSLog(@"7001 success");
    }
    
    /* test 7002 */
    __block BOOL isFinished = NO;
    [[CTPersistanceAsyncExecutor sharedInstance] performAsyncAction:^{
        NSUInteger count = 500;
        while (count --> 0) {
            TestRecord *record = [[TestRecord alloc] init];
            record.age = @(count);
            record.name = @"name";
            record.tomas = @"tomas";
            [mainTestTable insertRecord:record error:NULL];
        }
        isFinished = YES;
    } shouldWaitUntilDone:YES];
    
    if (isFinished) {
        NSLog(@"7002 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
}

@end
