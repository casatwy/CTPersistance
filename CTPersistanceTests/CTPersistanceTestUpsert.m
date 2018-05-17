//
//  CTPersistanceTestUpsert.m
//  CTPersistanceTests
//
//  Created by casa on 2018/5/17.
//  Copyright © 2018年 casa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestTable.h"
#import "TestRecord.h"

@interface CTPersistanceTestUpsert : XCTestCase

@property (nonatomic, strong) TestTable *testTable;

@end

@implementation CTPersistanceTestUpsert

- (void)setUp {
    [super setUp];
    self.testTable = [[TestTable alloc] init];
    
    NSInteger count = 10;
    while (count --> 0) {
        TestRecord *testRecord = [[TestRecord alloc] init];
        testRecord.age = @(count);
        testRecord.name = [NSString stringWithFormat:@"casa%ld", (long)count];
        testRecord.avatar = [testRecord.name dataUsingEncoding:NSUTF8StringEncoding];
        testRecord.progress = @(count);
        testRecord.isCelebrity = @(count % 2);
        testRecord.nilValue = nil;
        testRecord.timeStamp = 123;
        [self.testTable insertRecord:testRecord error:NULL];
    }
}

- (void)tearDown {
    [self.testTable truncate];
    [super tearDown];
}

- (void)testUpdate {
    NSError *error = nil;
    TestRecord *testRecord = (TestRecord *)[self.testTable findWithPrimaryKey:@(1) error:NULL];
    testRecord.age = @(123);
    
    [self.testTable upsertRecord:testRecord uniqKeyName:@"name" error:&error];
    XCTAssertNil(error);
    
    testRecord = (TestRecord *)[self.testTable findWithPrimaryKey:@(1) error:&error];
    XCTAssertNil(error);
    XCTAssertEqual(testRecord.age.integerValue, 123);
}

- (void)testUpdateKeyName {
    NSError *error = nil;
    TestRecord *testRecord = (TestRecord *)[self.testTable findWithPrimaryKey:@(2) error:NULL];
    testRecord.age = @(456);
    
    [self.testTable upsertRecord:testRecord uniqKeyName:@"age" error:&error];
    XCTAssertNil(error);
    
    testRecord = (TestRecord *)[self.testTable findWithPrimaryKey:@(2) error:&error];
    XCTAssertNil(error);
    XCTAssertEqual(testRecord.age.integerValue, 456);
}

- (void)testInsert {
    NSError *error = nil;
    TestRecord *testRecord = [[TestRecord alloc] init];
    testRecord.age = @(789);
    testRecord.name = @"casa";
    testRecord.avatar = [@"casa" dataUsingEncoding:NSUTF8StringEncoding];
    testRecord.progress = @(100);
    testRecord.isCelebrity = @(YES);
    testRecord.nilValue = nil;
    
    [self.testTable upsertRecord:testRecord uniqKeyName:@"age" error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(testRecord.primaryKey);
    
    testRecord = (TestRecord *)[self.testTable findWithPrimaryKey:testRecord.primaryKey error:&error];
    XCTAssertNil(error);
    XCTAssertEqual(testRecord.age.integerValue, 789);
}

@end
