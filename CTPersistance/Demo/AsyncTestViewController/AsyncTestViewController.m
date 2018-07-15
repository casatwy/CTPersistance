//
//  AsyncTestViewController.m
//  CTPersistance
//
//  Created by casa on 2017/8/12.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "AsyncTestViewController.h"
#import "CTPersistanceAsyncExecutor.h"

#import "TestTable.h"
#import "TestRecord.h"

#define COUNT 1000

@interface AsyncTestViewController ()

@property (nonatomic, strong) TestTable *testTable;

@end

@implementation AsyncTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self.testTable truncate];
    NSInteger count = COUNT;
    while (count --> 0) {
        TestRecord *record = [[TestRecord alloc] init];
        record.name = @"casa";
        [self.testTable insertRecord:record error:NULL];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[CTPersistanceAsyncExecutor sharedInstance] read:^{
        NSInteger count = COUNT;
        while (count --> 0) {
            TestRecord *record = (TestRecord *)[self.testTable findWithPrimaryKey:@(count) error:NULL];
            NSLog(@"read one %@", record.primaryKey);
        }
    }];

    NSInteger count = COUNT;
    while (count --> 0) {
        [[CTPersistanceAsyncExecutor sharedInstance] read:^{
            TestRecord *record = (TestRecord *)[self.testTable findWithPrimaryKey:@(count) error:NULL];
            NSLog(@"read two %@", record.primaryKey);
        }];
    }

    [[CTPersistanceAsyncExecutor sharedInstance] write:^{
        NSInteger count = COUNT;
        while (count --> 0) {
            NSNumber *primaryKey = [self.testTable insertValue:@"casa" forKey:@"name" error:NULL];
            NSLog(@"write one %@", primaryKey);
        }
    }];

    count = COUNT;
    while (count --> 0) {
        [[CTPersistanceAsyncExecutor sharedInstance] read:^{
            TestRecord *record = (TestRecord *)[self.testTable findWithPrimaryKey:@(count) error:NULL];
            NSLog(@"read three %@", record.primaryKey);
        }];
    }

    count = COUNT;
    while (count --> 0) {
        [[CTPersistanceAsyncExecutor sharedInstance] write:^{
            NSNumber *primaryKey = [self.testTable insertValue:@"casa" forKey:@"name" error:NULL];
            NSLog(@"write two %@", primaryKey);
        }];
    }

    count = COUNT;
    while (count --> 0) {
        [[CTPersistanceAsyncExecutor sharedInstance] read:^{
            TestRecord *record = (TestRecord *)[self.testTable findWithPrimaryKey:@(count) error:NULL];
            NSLog(@"read four %@", record.primaryKey);
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"finished");
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.testTable truncate];
}

#pragma mark - getters and setters
- (TestTable *)testTable
{
    if (_testTable == nil) {
        _testTable = [[TestTable alloc] init];
    }
    return _testTable;
}

@end
