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

}

- (void)testMultiReadSingleWrite
{

}

- (void)testMultiWriteSingleRead
{

}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
