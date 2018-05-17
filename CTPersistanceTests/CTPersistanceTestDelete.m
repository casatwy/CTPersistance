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
@property (nonatomic, strong) NSMutableArray <TestRecord *> *recordListToDelete;

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
    [self.testTable truncate];
    [super tearDown];
}

- (void)testDeleteWithPrimaryKey
{
    NSError *error = nil;
    NSNumber *primaryKey = self.recordToDelete.primaryKey;
    [self.testTable deleteWithPrimaryKey:primaryKey error:&error];
    XCTAssertNil(error);
    XCTAssertNil([self.testTable findWithPrimaryKey:primaryKey error:NULL]);
}

- (void)testDeleteWithKeyValue
{
    NSError *error = nil;
    TestRecord *record = [[TestRecord alloc] init];
    record.name = @"a record to be deleted";
    [self.testTable insertRecord:record error:&error];
    [self.testTable deleteRecordWhereKey:@"name" value:@"a record to be deleted" error:&error];
    XCTAssertNil(error);
    XCTAssertNil([self.testTable findWithPrimaryKey:record.primaryKey error:NULL]);
}

- (void)testDeleteWithPrimaryKeyList
{
    NSError *error = nil;
    NSArray *primaryKeyList = @[
                                self.recordToDelete.primaryKey,
                                @([self.recordToDelete.primaryKey integerValue] + 1),
                                @([self.recordToDelete.primaryKey integerValue] + 2),
                                @([self.recordToDelete.primaryKey integerValue] + 3)
                                ];
    [self.testTable deleteWithPrimaryKeyList:primaryKeyList error:&error];
    XCTAssertNil(error);
    XCTAssertEqual([self.testTable findAllWithPrimaryKey:primaryKeyList error:NULL].count, 0);
}

- (void)testDeleteRecord
{
    NSError *error = nil;
    NSNumber *primaryKey = self.recordToDelete.primaryKey;

    [self.testTable deleteRecord:self.recordToDelete error:&error];
    
    XCTAssertNil(error);
    XCTAssertNil([self.testTable findWithPrimaryKey:primaryKey error:NULL]);
}

- (void)testDeleteRecordList
{
    NSError *error = nil;
    NSMutableArray *primaryKeyList = [[NSMutableArray alloc] init];
    [self.recordListToDelete enumerateObjectsUsingBlock:^(TestRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [primaryKeyList addObject:obj.primaryKey];
    }];

    [self.testTable deleteRecordList:self.recordListToDelete error:&error];

    XCTAssertNil(error);
    XCTAssertEqual([self.testTable findAllWithPrimaryKey:primaryKeyList error:NULL].count, 0);
}

- (void)testDeleteWithWhereCondition
{
    NSError *error = nil;
    NSNumber *primaryKey = self.recordToDelete.primaryKey;
    [self.testTable deleteWithWhereCondition:@"primaryKey = :primaryKey" conditionParams:@{@":primaryKey":primaryKey} error:&error];
    XCTAssertNil(error);
    XCTAssertNil([self.testTable findWithPrimaryKey:primaryKey error:NULL]);
}

- (void)testDeleteWithWhereConditionNilValue
{
    XCTAssertGreaterThan([self.testTable countTotalRecord], 0);
    NSError *error = nil;
    [self.testTable deleteWithWhereCondition:@"nilValue is :nilValue" conditionParams:@{@":nilValue":[NSNull null]} error:&error];
    XCTAssertNil(error);
    XCTAssertEqual([self.testTable countTotalRecord], 0);
}

@end
