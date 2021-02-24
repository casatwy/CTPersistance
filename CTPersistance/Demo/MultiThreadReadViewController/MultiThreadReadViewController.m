//
//  MultiThreadReadViewController.m
//  CTPersistance
//
//  Created by casa on 2021/2/24.
//  Copyright © 2021 casa. All rights reserved.
//

#import "MultiThreadReadViewController.h"
#import <HandyFrame/UIView+LayoutMethods.h>
#import "DemoTestTable.h"

@interface MultiThreadReadViewController ()

@property (nonatomic, strong) DemoTestTable *testTable;

@end

@implementation MultiThreadReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.testTable truncate];

    NSUInteger multiple = 3;
    NSUInteger count = multiple * 10000;

    [self insert:count];

    NSUInteger repeat = 1000;
    while (repeat-- > 0) {
        [[CTPersistanceAsyncExecutor sharedInstance] read:^{
            DemoTestRecord *record = (DemoTestRecord *)[self.testTable findFirstRowWithWhereCondition:@"age = :age" conditionParams:@{@":age" : @(repeat*10*multiple)} isDistinct:NO error:NULL];

            NSLog(@"%@", record.primaryKey);
        }];
    }
}

- (void)insert:(NSUInteger)recordCount {
    NSMutableArray *recordList = [[NSMutableArray alloc] init];
    while (recordCount --> 0) {
        DemoTestRecord *record = [[DemoTestRecord alloc] init];
        record.age = @(recordCount);
        record.name = @"sdkfhsdkfhugewhgiuahpgiasgiajsdgidhjgopaewhin;erighjwiprhsdkfhsdkfhugewhgiuahpgiasgiajsdgidhjgopaewhin;erighjwiprhsdkfhsdkfhugewhgiuahpgiasgiajsdgidhjgopaewhin;erighjwiprhsdkfhsdkfhugewhgiuahpgiasgiajsdgidhjgopaewhin;erighjwiprhsdkfhsdkfhugewhgiuahpgiasgiajsdgidhjgopaewhin;erighjwiprhsdkfhsdkfhugewhgiuahpgiasgiajsdgidhjgopaewhin;erighjwiprhsdkfhsdkfhugewhgiuahpgiasgiajsdgidhjgopaewhin;erighjwiprhsdkfhsdkfhugewhgiuahpgiasgiajsdgidhjgopaewhin;erighjwiprhsdkfhsdkfhugewhgiuahpgiasgiajsdgidhjgopaewhin;erighjwiprhsdkfhsdkfhugewhgiuahpgiasgiajsdgidhjgopaewhin;erighjwiprh";
        [recordList addObject:record];
        [self.testTable insertRecord:record error:NULL];
        NSLog(@"insert %lu", (unsigned long)recordCount);
    }
}

- (DemoTestTable *)testTable
{
    if (_testTable == nil) {
        _testTable = [[DemoTestTable alloc] init];
    }
    return _testTable;
}

@end
