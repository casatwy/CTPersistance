//
//  CTPersistanceTestUpdate.m
//  CTPersistance
//
//  Created by casa on 2017/7/30.
//  Copyright © 2017年 casa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestTable.h"
#import "TestRecord.h"

@interface CTPersistanceTestUpdate : XCTestCase

@property (nonatomic, strong) TestTable *testTable;
@property (nonatomic, strong) TestRecord *recordToUpdate;
@property (nonatomic, strong) NSMutableArray <TestRecord *> *recordList;
@property (nonatomic, strong) NSMutableArray *primaryKeyList;

@end

@implementation CTPersistanceTestUpdate

- (void)setUp {
    [super setUp];
    self.testTable = [[TestTable alloc] init];
    self.recordList = [[NSMutableArray alloc] init];

    NSInteger count = 5;
    while (count --> 0) {
        TestRecord *record = [[TestRecord alloc] init];
        record.name = @"casa";
        [self.testTable insertRecord:record error:NULL];
        [self.recordList addObject:record];
        [self.primaryKeyList addObject:record.primaryKey];
    }

    self.recordToUpdate = [self.recordList firstObject];;
}

- (void)tearDown {
    [super tearDown];
    [self.testTable truncate];
}

- (void)testUpdateRecord
{
    self.recordToUpdate.name = @"testUpdateRecord";
    NSError *error = nil;
    [self.testTable updateRecord:self.recordToUpdate error:&error];
    XCTAssertNil(error);

    TestRecord *record = (TestRecord *)[self.testTable findWithPrimaryKey:self.recordToUpdate.primaryKey error:NULL];
    XCTAssert([record.name isEqualToString:@"testUpdateRecord"]);
}

- (void)testUpdateRecordList
{
    self.recordToUpdate.name = @"testUpdateRecordList";
    NSError *error = nil;
    [self.testTable updateRecordList:@[self.recordToUpdate] error:&error];
    XCTAssertNil(error);

    TestRecord *record = (TestRecord *)[self.testTable findWithPrimaryKey:self.recordToUpdate.primaryKey error:NULL];
    XCTAssert([record.name isEqualToString:@"testUpdateRecordList"]);
}

- (void)testUpdateRecordList_multiRecord
{
    [self.recordList enumerateObjectsUsingBlock:^(TestRecord * _Nonnull record, NSUInteger idx, BOOL * _Nonnull stop) {
        record.name = @"testUpdateRecordList_multiRecord";
    }];
    
    NSError *error = nil;
    [self.testTable updateRecordList:self.recordList error:&error];
    XCTAssertNil(error);

    NSArray <TestRecord *> *recordListToCheck = (NSArray <TestRecord *> *)[self.testTable findAllWithPrimaryKey:self.primaryKeyList error:NULL];
    XCTAssertEqual(recordListToCheck.count, self.primaryKeyList.count);
    [recordListToCheck enumerateObjectsUsingBlock:^(TestRecord * _Nonnull recordToCheck, NSUInteger idx, BOOL * _Nonnull stop) {
        XCTAssert([recordToCheck.name isEqualToString:@"testUpdateRecordList_multiRecord"]);
    }];
}

- (void)testUpdateValueForKeyPrimaryKeyValue
{
    NSError *error = nil;
    [self.testTable updateValue:@"testUpdateValueForKeyPrimaryKeyValue" forKey:@"name" primaryKeyValue:self.recordToUpdate.primaryKey error:&error];
    XCTAssertNil(error);

    TestRecord *record = (TestRecord *)[self.testTable findWithPrimaryKey:self.recordToUpdate.primaryKey error:NULL];
    XCTAssert([record.name isEqualToString:@"testUpdateValueForKeyPrimaryKeyValue"]);
}

- (void)testUpdateValueForKeyWhereKeyInList
{
    NSError *error = nil;
    [self.testTable updateValue:@"testUpdateValueForKeyWhereKeyInList" forKey:@"name" whereKey:self.testTable.primaryKeyName inList:self.primaryKeyList error:&error];
    XCTAssertNil(error);

    NSArray <TestRecord *> *recordListToCheck = (NSArray <TestRecord *> *)[self.testTable findAllWithPrimaryKey:self.primaryKeyList error:NULL];
    XCTAssertEqual(recordListToCheck.count, self.primaryKeyList.count);
    [recordListToCheck enumerateObjectsUsingBlock:^(TestRecord * _Nonnull recordToCheck, NSUInteger idx, BOOL * _Nonnull stop) {
        XCTAssert([recordToCheck.name isEqualToString:@"testUpdateValueForKeyWhereKeyInList"]);
    }];
}

- (void)testUpdateKeyValueListWhereConditionWhereConditionParams
{
    NSError *error = nil;
    [self.testTable updateKeyValueList:@{@"name":@"testUpdateKeyValueListWhereConditionWhereConditionParams"}
                        whereCondition:@"primaryKey > :primaryKeyValue"
                  whereConditionParams:@{@":primaryKeyValue":@0,}
                                 error:&error];
    XCTAssertNil(error);

    NSArray <TestRecord *> *recordListToCheck = (NSArray <TestRecord *> *)[self.testTable findAllWithPrimaryKey:self.primaryKeyList error:NULL];
    XCTAssertEqual(recordListToCheck.count, self.primaryKeyList.count);
    [recordListToCheck enumerateObjectsUsingBlock:^(TestRecord * _Nonnull recordToCheck, NSUInteger idx, BOOL * _Nonnull stop) {
        XCTAssert([recordToCheck.name isEqualToString:@"testUpdateKeyValueListWhereConditionWhereConditionParams"]);
    }];
}

- (void)testUpdateValueForKeyPrimaryKeyValueList
{
    NSError *error = nil;
    [self.testTable updateValue:@"testUpdateValueForKeyPrimaryKeyValueList"
                         forKey:@"name"
            primaryKeyValueList:self.primaryKeyList
                          error:&error];
    XCTAssertNil(error);

    NSArray <TestRecord *> *recordListToCheck = (NSArray <TestRecord *> *)[self.testTable findAllWithPrimaryKey:self.primaryKeyList error:NULL];
    XCTAssertEqual(recordListToCheck.count, self.primaryKeyList.count);
    [recordListToCheck enumerateObjectsUsingBlock:^(TestRecord * _Nonnull recordToCheck, NSUInteger idx, BOOL * _Nonnull stop) {
        XCTAssert([recordToCheck.name isEqualToString:@"testUpdateValueForKeyPrimaryKeyValueList"]);
    }];
}

- (void)testUpdateKeyValueList_PrimaryKeyValueList
{
    NSError *error = nil;
    [self.testTable updateKeyValueList:@{@"age":@1,@"name":@"testUpdateKeyValueList_PrimaryKeyValueList"}
                   primaryKeyValueList:self.primaryKeyList
                                 error:&error];
    XCTAssertNil(error);

    NSArray <TestRecord *> *recordListToCheck = (NSArray <TestRecord *> *)[self.testTable findAllWithPrimaryKey:self.primaryKeyList error:NULL];
    XCTAssertEqual(recordListToCheck.count, self.primaryKeyList.count);
    [recordListToCheck enumerateObjectsUsingBlock:^(TestRecord * _Nonnull recordToCheck, NSUInteger idx, BOOL * _Nonnull stop) {
        XCTAssert([recordToCheck.name isEqualToString:@"testUpdateKeyValueList_PrimaryKeyValueList"]);
        XCTAssertEqual([recordToCheck.age integerValue], 1);
    }];
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
