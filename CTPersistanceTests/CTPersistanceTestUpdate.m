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

@end

@implementation CTPersistanceTestUpdate

- (void)setUp {
    [super setUp];
    self.testTable = [[TestTable alloc] init];

    TestRecord *record = [[TestRecord alloc] init];
    record.name = @"casa";

    NSError *error = nil;
    [self.testTable insertRecord:record error:&error];
    self.recordToUpdate = record;
}

- (void)tearDown {
    [super tearDown];
}

- (void)testUpdateRecord
{
    self.recordToUpdate.name = @"c'asa";
    NSError *error = nil;
    [self.testTable updateRecord:self.recordToUpdate error:&error];
    XCTAssertNil(error);
}

- (void)testUpdateRecordList
{
    self.recordToUpdate.name = @"c'recordList";
    NSError *error = nil;
    [self.testTable updateRecordList:@[self.recordToUpdate] error:&error];
    XCTAssertNil(error);
}

- (void)testUpdateRecordList_multiRecord
{
    NSMutableArray *recordList = [[NSMutableArray alloc] init];
    NSInteger count = 3;
    while (count --> 0) {
        TestRecord *record = [[TestRecord alloc] init];
        record.primaryKey = @(count);
        record.name = @"multiRecord";
        [recordList addObject:record];
    }

    NSError *error = nil;
    [self.testTable updateRecordList:recordList error:&error];
    XCTAssertNil(error);
}

- (void)testUpdateValueForKeyPrimaryKeyValue
{
    NSError *error = nil;
    [self.testTable updateValue:@"updateValueForKeyPrimaryKeyValue" forKey:@"name" primaryKeyValue:self.recordToUpdate.primaryKey error:&error];
    XCTAssertNil(error);
}

- (void)testUpdateValueForKeyWhereKeyInList
{
    NSError *error = nil;
    [self.testTable updateValue:@"wherekeyinlist" forKey:@"name" whereKey:self.testTable.primaryKeyName inList:@[self.recordToUpdate.primaryKey] error:&error];
    XCTAssertNil(error);
}

- (void)testUpdateValueForKeyWhereKeyInList_multikey
{
    NSError *error = nil;
    [self.testTable updateValue:@"wherekeyinlist" forKey:@"name" whereKey:self.testTable.primaryKeyName inList:@[@1, @2, @3] error:&error];
    XCTAssertNil(error);
}

- (void)testUpdateKeyValueListWhereConditionWhereConditionParams
{
    NSError *error = nil;
    [self.testTable updateKeyValueList:@{@"name":@"keyvaluelist"}
                        whereCondition:@"primaryKey > :primaryKeyValue AND name = :name"
                  whereConditionParams:@{
                                         @":primaryKeyValue":@1,
                                         @":name":@"casa"
                                         }
                                 error:&error];
    XCTAssertNil(error);
}

- (void)testUpdateValueForKeyPrimaryKeyValueList
{
    NSError *error = nil;
    [self.testTable updateValue:@"c'asa"
                         forKey:@"name"
            primaryKeyValueList:@[@1,self.recordToUpdate.primaryKey]
                          error:&error];
    XCTAssertNil(error);
}

- (void)testUpdateKeyValueList_PrimaryKeyValueList
{
    NSError *error = nil;
    [self.testTable updateKeyValueList:@{@"age":@1,@"name":@"casaupdated"}
                   primaryKeyValueList:@[@1,self.recordToUpdate.primaryKey]
                                 error:&error];
    XCTAssertNil(error);
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
