//
//  CTPersistanceTestConcurrentRead.m
//  CTPersistanceTests
//
//  Created by zhongguang zhou on 2021/2/6.
//  Copyright © 2021 casa. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TestTable.h"
#import "TestRecord.h"
#import "CTPersistance.h"

@interface CTPersistanceTestConcurrentRead : XCTestCase

@property (nonatomic, strong) TestTable *testTable;

@end

@implementation CTPersistanceTestConcurrentRead

- (void)setUp {
    self.testTable = [[TestTable alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testConcurrentRead {
    [self.testTable truncate];

    NSUInteger multiple = 3;
    NSUInteger count = multiple * 10000;

    [self insert:count];

    count = [self.testTable countTotalRecord];
    NSLog(@"countTotalRecord:%ld", count);
    
    
    NSUInteger repeat = 1000;
    while (repeat-- > 0) {
        [[CTPersistanceAsyncExecutor sharedInstance] read:^{
            TestRecord *record = (TestRecord *)[self.testTable findFirstRowWithWhereCondition:@"age = :age" conditionParams:@{@":age" : @(repeat*10*multiple)} isDistinct:NO error:NULL];

            NSLog(@"%@", record.primaryKey);
        }];
    }
    
    while (true) {
        
    }
}

- (void)insert:(NSUInteger)recordCount {
//    NSInteger recordCount = 10000;
    NSMutableArray *recordList = [[NSMutableArray alloc] init];
    while (recordCount --> 0) {
        TestRecord *record = [[TestRecord alloc] init];
        record.age = @(recordCount);
        record.name = @"sdkfhsdkfhugewhgiuahpgiasgiajsdgidhjgopaewhin;erighjwiprhsdkfhsdkfhugewhgiuahpgiasgiajsdgidhjgopaewhin;erighjwiprhsdkfhsdkfhugewhgiuahpgiasgiajsdgidhjgopaewhin;erighjwiprhsdkfhsdkfhugewhgiuahpgiasgiajsdgidhjgopaewhin;erighjwiprhsdkfhsdkfhugewhgiuahpgiasgiajsdgidhjgopaewhin;erighjwiprhsdkfhsdkfhugewhgiuahpgiasgiajsdgidhjgopaewhin;erighjwiprhsdkfhsdkfhugewhgiuahpgiasgiajsdgidhjgopaewhin;erighjwiprhsdkfhsdkfhugewhgiuahpgiasgiajsdgidhjgopaewhin;erighjwiprhsdkfhsdkfhugewhgiuahpgiasgiajsdgidhjgopaewhin;erighjwiprhsdkfhsdkfhugewhgiuahpgiasgiajsdgidhjgopaewhin;erighjwiprh";
        [recordList addObject:record];
        [self.testTable insertRecord:record error:NULL];
        NSLog(@"insert %lu", (unsigned long)recordCount);
    }
}

@end
