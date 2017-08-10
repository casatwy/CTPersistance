//
//  CTPersistanceTestAsync.m
//  CTPersistance
//
//  Created by casa on 2017/8/7.
//  Copyright © 2017年 casa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CTPersistance.h"
#import "TestTable.h"
#import "TestRecord.h"

@interface CTPersistanceTestAsync : XCTestCase

@property (nonatomic, strong) TestTable *testTable;

@end

@implementation CTPersistanceTestAsync

- (void)setUp {
    [super setUp];
    self.testTable = [[TestTable alloc] init];

    [self.testTable insertValue:@"casa" forKey:@"name" error:NULL];
    [self.testTable insertValue:@"casa" forKey:@"name" error:NULL];
    [self.testTable insertValue:@"casa" forKey:@"name" error:NULL];
}

- (void)tearDown {
    [super tearDown];
    [self.testTable truncate];
}

- (void)testMultiRead
{

}

- (void)testMultiWrite
{
//    @autoreleasepool {
//        NSInteger count = 10;
//        while (count --> 0) {
//            [NSThread detachNewThreadSelector:@selector(insertRecord) toTarget:self withObject:nil];
//        }
//    }
}

- (void)testMultiReadSingleWrite
{

}

- (void)testMultiWriteSingleRead
{

}

- (void)insertRecord
{
    NSError *error = nil;
    NSInteger count = 10;
    while (count --> 0) {
        NSLog(@"%@", [NSThread currentThread]);
        [self.testTable insertValue:[NSString stringWithFormat:@"%@%ld", [NSThread currentThread], (long)count] forKey:@"name" error:&error];
        if (error) {
            NSLog(@"error is %@", error);
        }
    }
}

- (void)readRecord
{
    TestRecord *record = (TestRecord *)[self.testTable findWithPrimaryKey:@(1) error:NULL];
    NSLog(@"%@", record.primaryKey);
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
