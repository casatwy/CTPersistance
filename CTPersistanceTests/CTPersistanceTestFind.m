//
//  CTPersistanceTestFind.m
//  CTPersistance
//
//  Created by casa on 2017/8/1.
//  Copyright © 2017年 casa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestTable.h"
#import "TestRecord.h"
#import "CTPersistanceCriteria.h"

@interface CTPersistanceTestFind : XCTestCase

@property (nonatomic, strong) TestTable *testTable;
@property (nonatomic, strong) NSMutableArray <TestRecord *> *recordListToDelete;

@end

@implementation CTPersistanceTestFind

- (void)setUp {
    [super setUp];

    self.testTable = [[TestTable alloc] init];
    self.recordListToDelete = [[NSMutableArray alloc] init];

    NSInteger count = 3;
    while (count --> 0) {
        TestRecord *record = [[TestRecord alloc] init];
        record.name = @"casa";
        record.age = @(count % 2);
        [self.testTable insertRecord:record error:NULL];
        [self.recordListToDelete addObject:record];
    }
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    [self.testTable truncate];
}

/*
- (NSNumber *)countTotalRecord;
- (NSNumber *)countWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams error:(NSError **)error;
- (NSDictionary *)countWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error;
 */

- (void)testFindLatestRecord
{
    NSError *error = nil;
    TestRecord *record = (TestRecord *)[self.testTable findLatestRecordWithError:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(record);
}

- (void)testFindAllWithWhereConditionConditionParamsIsDistinctFalse
{
    NSError *error = nil;
    NSArray <TestRecord *> *recordList = (NSArray <TestRecord *> *)[self.testTable findAllWithWhereCondition:@"name = :name"
                                                                                             conditionParams:@{@":name":@"casa"}
                                                                                                  isDistinct:NO
                                                                                                       error:&error];
    XCTAssertNil(error);
    XCTAssertGreaterThan(recordList.count, 0);
}

- (void)testFindAllWithWhereConditionConditionParamsIsDistinctTrue
{
    NSError *error = nil;
    NSArray <TestRecord *> *recordList = (NSArray <TestRecord *> *)[self.testTable findAllWithWhereCondition:@"age = :age"
                                                                                             conditionParams:@{@":age":@0}
                                                                                                  isDistinct:YES
                                                                                                       error:&error];
    XCTAssertNil(error);
    XCTAssertGreaterThan(recordList.count, 0);
}

- (void)testFindFirstRowWithWhereConditionConditionParams
{
    NSError *error = nil;
    TestRecord *record = (TestRecord *)[self.testTable findFirstRowWithWhereCondition:@"age = :age"
                                                                      conditionParams:@{@":age":@0}
                                                                           isDistinct:YES
                                                                                error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(record);
}

- (void)testFindWithPrimaryKey
{
    NSError *error = nil;

    TestRecord *recordToFind = [self.recordListToDelete firstObject];
    TestRecord *record = (TestRecord *)[self.testTable findWithPrimaryKey:recordToFind.primaryKey error:&error];
    
    XCTAssertNil(error);
    XCTAssertEqual([recordToFind.primaryKey integerValue], [record.primaryKey integerValue]);
}

- (void)testFindAllWithKeyValue
{
    NSError *error = nil;

    TestRecord *recordToFind = [self.recordListToDelete firstObject];
    TestRecord *record = (TestRecord *)[[self.testTable findAllWithKeyName:@"age" value:recordToFind.age error:&error] firstObject];
    
    XCTAssertNil(error);
    XCTAssertEqual([recordToFind.primaryKey integerValue], [record.primaryKey integerValue]);
}

- (void)testFindAllWithPrimaryKeyList
{
    NSError *error = nil;

    NSMutableArray *primaryKeyList = [[NSMutableArray alloc] init];
    [self.recordListToDelete enumerateObjectsUsingBlock:^(TestRecord * _Nonnull record, NSUInteger idx, BOOL * _Nonnull stop) {
        [primaryKeyList addObject:record.primaryKey];
    }];
    NSArray <TestRecord *> *recordList = (NSArray <TestRecord *> *)[self.testTable findAllWithPrimaryKey:primaryKeyList error:&error];

    XCTAssertNil(error);
    XCTAssertEqual(recordList.count, self.recordListToDelete.count);
    [recordList enumerateObjectsUsingBlock:^(TestRecord * _Nonnull record, NSUInteger idx, BOOL * _Nonnull stop) {
        TestRecord *recordToCompare = self.recordListToDelete[idx];
        XCTAssertEqual([recordToCompare.primaryKey integerValue], [record.primaryKey integerValue]);
    }];
}

- (void)testCountTotalRecord
{
    NSInteger result = [self.testTable countTotalRecord];
    XCTAssertEqual(result, 3);
}

- (void)testCountWithWhereConditionParams
{
    NSError *error = nil;
    NSInteger result = [self.testTable countWithWhereCondition:@"name = :name"
                                               conditionParams:@{@":name":@"casa"}
                                                         error:&error];
    XCTAssertEqual(result, 3);
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
