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
#import "CTPersistanceTransaction.h"

@interface CTPersistanceTestUpsert : XCTestCase

@property (nonatomic, strong) TestTable *testTable;

@end

@implementation CTPersistanceTestUpsert

- (void)setUp {
    [super setUp];
    self.testTable = [[TestTable alloc] init];
    [self.testTable truncate];
    
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

- (void)testUpdateToEmptyTable
{
    // clean all data
    [self.testTable truncate];
    NSUInteger recordCount = [self.testTable countTotalRecord];
    XCTAssertEqual(recordCount, 0);
    
    TestRecord *testRecord = [[TestRecord alloc] init];
    testRecord.primaryKey = @(1);
    testRecord.age = @(999);
    testRecord.name = @"casa999";
    testRecord.avatar = [testRecord.name dataUsingEncoding:NSUTF8StringEncoding];
    testRecord.progress = @(999);
    testRecord.isCelebrity = @(999 % 2);
    testRecord.nilValue = nil;
    testRecord.timeStamp = 123;
    
    NSError *error = nil;
    [self.testTable upsertRecord:testRecord uniqKeyName:@"age" shouldUpdateNilValueToDatabase:YES error:&error];
    
    XCTAssertNil(error);
    recordCount = [self.testTable countTotalRecord];
    XCTAssertEqual(recordCount, 1);

    // recorver data
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

- (void)testTransaction {
    [CTPersistanceTransaction performTranscationWithBlock:^(BOOL *shouldRollback) {
        NSInteger count = [self.testTable countTotalRecord];
        NSError *error = nil;
        while (count --> 0) {
            TestRecord *testRecord = [[TestRecord alloc] init];
            testRecord.name = @"new casa";
            testRecord.age = @(count);
            [self.testTable upsertRecord:testRecord uniqKeyName:@"age" shouldUpdateNilValueToDatabase:YES error:&error];
            XCTAssertNil(error);
        }
    } queryCommand:self.testTable.queryCommand lockType:CTPersistanceTransactionLockTypeDefault];
    
    NSArray <TestRecord *> *recordList = (NSArray <TestRecord *> *)[self.testTable findAllWithError:NULL];
    [recordList enumerateObjectsUsingBlock:^(TestRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XCTAssertTrue([obj.name isEqualToString:@"new casa"]);
        XCTAssertNil(obj.progress);
    }];
}

- (void)test_No_UpdateNilValueToDatabase {
    NSInteger count = [self.testTable countTotalRecord];
    NSInteger countToAssert = count;
    
    NSError *error = nil;
    while (count --> 0) {
        TestRecord *testRecord = [[TestRecord alloc] init];
        testRecord.name = @"casa";
        testRecord.age = @(count);
        [self.testTable upsertRecord:testRecord uniqKeyName:@"age" shouldUpdateNilValueToDatabase:NO error:&error];
        XCTAssertNil(error);
    }
    
    count = [self.testTable countTotalRecord];
    XCTAssertEqual(countToAssert, count);
    
    NSArray <TestRecord *> *recordList = (NSArray <TestRecord *> *)[self.testTable findAllWithError:NULL];
    [recordList enumerateObjectsUsingBlock:^(TestRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XCTAssertTrue([obj.name isEqualToString:@"casa"]);
        XCTAssertNotNil(obj.progress);
    }];
}

- (void)test_Should_UpdateNilValueToDatabase {
    NSInteger count = [self.testTable countTotalRecord];
    NSInteger countToAssert = count;
    
    NSError *error = nil;
    while (count --> 0) {
        TestRecord *testRecord = [[TestRecord alloc] init];
        testRecord.name = @"casa";
        testRecord.age = @(count);
        [self.testTable upsertRecord:testRecord uniqKeyName:@"age" shouldUpdateNilValueToDatabase:YES error:&error];
        XCTAssertNil(error);
    }
    
    count = [self.testTable countTotalRecord];
    XCTAssertEqual(countToAssert, count);
    
    NSArray <TestRecord *> *recordList = (NSArray <TestRecord *> *)[self.testTable findAllWithError:NULL];
    [recordList enumerateObjectsUsingBlock:^(TestRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XCTAssertTrue([obj.name isEqualToString:@"casa"]);
        XCTAssertNil(obj.progress);
    }];
}

- (void)testUpdate {
    NSError *error = nil;
    TestRecord *testRecord = (TestRecord *)[self.testTable findWithPrimaryKey:@(1) error:NULL];
    testRecord.age = @(123);
    
    [self.testTable upsertRecord:testRecord uniqKeyName:@"name" shouldUpdateNilValueToDatabase:NO error:&error];
    XCTAssertNil(error);
    
    testRecord = (TestRecord *)[self.testTable findWithPrimaryKey:@(1) error:&error];
    XCTAssertNil(error);
    XCTAssertEqual(testRecord.age.integerValue, 123);
}

- (void)testUpdateKeyName {
    NSError *error = nil;
    TestRecord *testRecord = (TestRecord *)[self.testTable findWithPrimaryKey:@(2) error:NULL];
    testRecord.age = @(456);
    
    [self.testTable upsertRecord:testRecord uniqKeyName:@"age" shouldUpdateNilValueToDatabase:NO error:&error];
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
    
    [self.testTable upsertRecord:testRecord uniqKeyName:@"age" shouldUpdateNilValueToDatabase:YES error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(testRecord.primaryKey);
    
    testRecord = (TestRecord *)[self.testTable findWithPrimaryKey:testRecord.primaryKey error:&error];
    XCTAssertNil(error);
    XCTAssertEqual(testRecord.age.integerValue, 789);
}

- (void)testUniqKeyNameIsPrimaryKey {
    NSError *error = nil;
    TestRecord *testRecord = [[TestRecord alloc] init];
    testRecord.age = @(789);
    testRecord.name = @"casa";
    testRecord.avatar = [@"casa" dataUsingEncoding:NSUTF8StringEncoding];
    testRecord.progress = @(100);
    testRecord.isCelebrity = @(YES);
    testRecord.nilValue = nil;
    
    [self.testTable upsertRecord:testRecord uniqKeyName:self.testTable.primaryKeyName shouldUpdateNilValueToDatabase:YES error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(testRecord.primaryKey);
    
    testRecord = (TestRecord *)[self.testTable findWithPrimaryKey:testRecord.primaryKey error:&error];
    XCTAssertNil(error);
    XCTAssertEqual(testRecord.age.integerValue, 789);
    XCTAssertEqual(testRecord.primaryKey.integerValue, 11);
}

@end
