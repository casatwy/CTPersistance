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
@property (nonatomic, strong) NSMutableArray *recordListToDelete;

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

    [self.testTable deleteRecordList:self.recordListToDelete error:NULL];
}

/*
- (NSNumber *)countTotalRecord;
- (NSNumber *)countWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams error:(NSError **)error;
- (NSDictionary *)countWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error;

- (NSObject <CTPersistanceRecordProtocol> *)findWithPrimaryKey:(NSNumber *)primaryKeyValue error:(NSError **)error;
- (NSArray <NSObject <CTPersistanceRecordProtocol> *> *)findAllWithPrimaryKey:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error;
- (NSArray <NSObject <CTPersistanceRecordProtocol> *> *)findAllWithKeyName:(NSString *)keyname value:(id)value error:(NSError **)error;
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

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
