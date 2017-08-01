//
//  CTPersistanceTestInsert.m
//  CTPersistance
//
//  Created by casa on 2017/7/29.
//  Copyright © 2017年 casa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestTable.h"
#import "TestRecord.h"

@interface CTPersistanceTestInsert : XCTestCase

@property (nonatomic, strong) TestTable *testTable;

@end

@implementation CTPersistanceTestInsert

- (void)setUp {
    [super setUp];
    self.testTable = [[TestTable alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    [self.testTable truncate];
}

- (void)testInsertSpecialCharRecord
{
    TestRecord *record = [[TestRecord alloc] init];
    record.name = @"c'asa";

    NSError *error = nil;
    [self.testTable insertRecord:record error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil([self.testTable findWithPrimaryKey:record.primaryKey error:NULL]);
}

- (void)testInsertNULLTextRecord
{
    TestRecord *record = [[TestRecord alloc] init];
    record.name = @"NULL";
    
    NSError *error = nil;
    [self.testTable insertRecord:record error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil([self.testTable findWithPrimaryKey:record.primaryKey error:NULL]);
}

- (void)testInsertZeroRecord
{
    TestRecord *record = [[TestRecord alloc] init];
    record.age = @(0);

    NSError *error = nil;
    [self.testTable insertRecord:record error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil([self.testTable findWithPrimaryKey:record.primaryKey error:NULL]);
}

- (void)testInsertDoubleTypeRecord
{
    TestRecord *record = [[TestRecord alloc] init];
    record.progress = @(3.14);

    NSError *error = nil;
    [self.testTable insertRecord:record error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil([self.testTable findWithPrimaryKey:record.primaryKey error:NULL]);
}

- (void)testInsertBlobTypeRecord
{
    TestRecord *record = [[TestRecord alloc] init];
    record.avatar = [@"avatar data" dataUsingEncoding:NSUTF8StringEncoding];

    NSError *error = nil;
    [self.testTable insertRecord:record error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil([self.testTable findWithPrimaryKey:record.primaryKey error:NULL]);
}

- (void)testInsertImageDataTypeRecord
{
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"TestRecord" ofType:@"png"];

    TestRecord *record = [[TestRecord alloc] init];
    record.avatar = [NSData dataWithContentsOfFile:filePath];

    NSError *error = nil;
    [self.testTable insertRecord:record error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil([self.testTable findWithPrimaryKey:record.primaryKey error:NULL]);
}

- (void)testInsertRecordList
{
    NSInteger recordCount = 10;
    NSMutableArray <TestRecord *> *recordList = [[NSMutableArray alloc] init];
    while (recordCount --> 0) {
        TestRecord *record = [[TestRecord alloc] init];
        record.age = @(recordCount);
        [recordList addObject:record];
    }
    
    NSError *error = nil;
    [self.testTable insertRecordList:recordList error:&error];
    XCTAssertNil(error);

    NSMutableArray *primaryList = [[NSMutableArray alloc] init];
    [recordList enumerateObjectsUsingBlock:^(TestRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [primaryList addObject:obj.primaryKey];
    }];
    XCTAssertEqual(recordList.count, [self.testTable findAllWithPrimaryKey:primaryList error:NULL].count);
}

//- (void)testInsert_100_Performance
//{
//    NSInteger recordCount = 100;
//    NSMutableArray <TestRecord *> *recordList = [[NSMutableArray alloc] init];
//    while (recordCount --> 0) {
//        TestRecord *record = [[TestRecord alloc] init];
//        record.age = @(recordCount);
//        [recordList addObject:record];
//    }
//
//    [self measureBlock:^{
//        NSError *error = nil;
//        [self.testTable insertRecordList:recordList error:&error];
//    }];
//}
//
//- (void)testInsert_1_000_Performance
//{
//    NSInteger recordCount = 1000;
//    NSMutableArray *recordList = [[NSMutableArray alloc] init];
//    while (recordCount --> 0) {
//        TestRecord *record = [[TestRecord alloc] init];
//        record.age = @(recordCount);
//        [recordList addObject:record];
//    }
//
//    [self measureBlock:^{
//        NSError *error = nil;
//        [self.testTable insertRecordList:recordList error:&error];
//    }];
//}
//
//- (void)testInsert_10_000_Performance
//{
//    NSInteger recordCount = 10000;
//    NSMutableArray *recordList = [[NSMutableArray alloc] init];
//    while (recordCount --> 0) {
//        TestRecord *record = [[TestRecord alloc] init];
//        record.age = @(recordCount);
//        [recordList addObject:record];
//    }
//
//    [self measureBlock:^{
//        NSError *error = nil;
//        [self.testTable insertRecordList:recordList error:&error];
//    }];
//}
//
//- (void)testInsert_100_000_Performance
//{
//    NSInteger recordCount = 100000;
//    NSMutableArray *recordList = [[NSMutableArray alloc] init];
//    while (recordCount --> 0) {
//        TestRecord *record = [[TestRecord alloc] init];
//        record.age = @(recordCount);
//        [recordList addObject:record];
//    }
//
//    [self measureBlock:^{
//        NSError *error = nil;
//        [self.testTable insertRecordList:recordList error:&error];
//    }];
//}

@end
