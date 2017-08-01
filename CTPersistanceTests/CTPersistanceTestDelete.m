//
//  CTPersistanceTestDelete.m
//  CTPersistance
//
//  Created by casa on 2017/7/31.
//  Copyright © 2017年 casa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestTable.h"
#import "TestRecord.h"

@interface CTPersistanceTestDelete : XCTestCase

@property (nonatomic, strong) TestTable *testTable;
@property (nonatomic, strong) TestRecord *recordToDelete;
@property (nonatomic, strong) NSMutableArray *recordListToDelete;

@end

@implementation CTPersistanceTestDelete

- (void)setUp {
    [super setUp];

    self.testTable = [[TestTable alloc] init];
    self.recordListToDelete = [[NSMutableArray alloc] init];

    NSInteger count = 3;
    while (count --> 0) {
        TestRecord *record = [[TestRecord alloc] init];
        record.name = @"casa";
        [self.testTable insertRecord:record error:NULL];
        [self.recordListToDelete addObject:record];
        if (self.recordToDelete == nil) {
            self.recordToDelete = record;
        }
    }
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDeleteWithPrimaryKey
{
    NSError *error = nil;
    [self.testTable deleteWithPrimaryKey:self.recordToDelete.primaryKey error:NULL];
    XCTAssertNil(error);
}

- (void)testDeleteWithPrimaryKeyList
{
    NSError *error = nil;
    [self.testTable deleteWithPrimaryKeyList:@[self.recordToDelete.primaryKey, @([self.recordToDelete.primaryKey integerValue] + 1), @([self.recordToDelete.primaryKey integerValue] + 2), @([self.recordToDelete.primaryKey integerValue] + 3)] error:&error];
    XCTAssertNil(error);
}

- (void)testDeleteRecord
{
    NSError *error = nil;
    [self.testTable deleteRecord:self.recordToDelete error:&error];
    XCTAssertNil(error);
}

- (void)testDeleteRecordList
{
    NSError *error = nil;
    [self.testTable deleteRecordList:self.recordListToDelete error:&error];
    XCTAssertNil(error);
}

- (void)testDeleteWithWhereCondition
{
    NSError *error = nil;
    [self.testTable deleteWithWhereCondition:@"primaryKey = :primaryKey" conditionParams:@{@":primaryKey":@5} error:&error];
    XCTAssertNil(error);
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
