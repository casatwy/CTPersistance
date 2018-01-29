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
        record.avatar = [@"avatar" dataUsingEncoding:NSUTF8StringEncoding];
        record.progress = @(0.0f);
        record.isCelebrity = @(NO);
        record.nilValue = @"nilValue";
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
    self.recordToUpdate.avatar = [@"newAvatar" dataUsingEncoding:NSUTF8StringEncoding];
    self.recordToUpdate.progress = @(0.1f);
    self.recordToUpdate.isCelebrity = @(YES);
    self.recordToUpdate.nilValue = nil;
    NSError *error = nil;
    [self.testTable updateRecord:self.recordToUpdate error:&error];
    XCTAssertNil(error);

    TestRecord *record = (TestRecord *)[self.testTable findWithPrimaryKey:self.recordToUpdate.primaryKey error:NULL];
    XCTAssert([record.name isEqualToString:@"testUpdateRecord"]);
    NSString *newAvatarString = [[NSString alloc] initWithData:record.avatar encoding:NSUTF8StringEncoding];
    XCTAssert([newAvatarString isEqualToString:@"newAvatar"]);
    XCTAssertEqual([record.progress doubleValue], 0.1f);
    XCTAssertEqual([record.isCelebrity boolValue], YES);
    XCTAssertNil(record.nilValue);
}

- (void)testUpdateRecordList
{
    self.recordToUpdate.name = @"testUpdateRecordList";
    self.recordToUpdate.avatar = [@"newAvatar" dataUsingEncoding:NSUTF8StringEncoding];
    self.recordToUpdate.progress = @(0.1f);
    self.recordToUpdate.nilValue = nil;
    NSError *error = nil;
    [self.testTable updateRecordList:@[self.recordToUpdate] error:&error];
    XCTAssertNil(error);

    TestRecord *record = (TestRecord *)[self.testTable findWithPrimaryKey:self.recordToUpdate.primaryKey error:NULL];
    XCTAssert([record.name isEqualToString:@"testUpdateRecordList"]);
    NSString *newAvatarString = [[NSString alloc] initWithData:record.avatar encoding:NSUTF8StringEncoding];
    XCTAssert([newAvatarString isEqualToString:@"newAvatar"]);
    XCTAssertEqual([record.progress doubleValue], 0.1f);
    XCTAssertNil(record.nilValue);
}

- (void)testUpdateRecordList_multiRecord
{
    [self.recordList enumerateObjectsUsingBlock:^(TestRecord * _Nonnull record, NSUInteger idx, BOOL * _Nonnull stop) {
        record.name = @"testUpdateRecordList_multiRecord";
        record.avatar = [@"newAvatar" dataUsingEncoding:NSUTF8StringEncoding];
        record.progress = @(0.1f);
        record.nilValue = nil;
    }];
    
    NSError *error = nil;
    [self.testTable updateRecordList:self.recordList error:&error];
    XCTAssertNil(error);

    NSArray <TestRecord *> *recordListToCheck = (NSArray <TestRecord *> *)[self.testTable findAllWithPrimaryKey:self.primaryKeyList error:NULL];
    XCTAssertEqual(recordListToCheck.count, self.primaryKeyList.count);
    [recordListToCheck enumerateObjectsUsingBlock:^(TestRecord * _Nonnull recordToCheck, NSUInteger idx, BOOL * _Nonnull stop) {
        XCTAssert([recordToCheck.name isEqualToString:@"testUpdateRecordList_multiRecord"]);
        NSString *newAvatarString = [[NSString alloc] initWithData:recordToCheck.avatar encoding:NSUTF8StringEncoding];
        XCTAssert([newAvatarString isEqualToString:@"newAvatar"]);
        XCTAssertEqual([recordToCheck.progress doubleValue], 0.1f);
        XCTAssertNil(recordToCheck.nilValue);
    }];
}

- (void)testUpdateValueForKeyPrimaryKeyValue
{
    NSError *error = nil;
    [self.testTable updateValue:@"testUpdateValueForKeyPrimaryKeyValue" forKey:@"name" primaryKeyValue:self.recordToUpdate.primaryKey error:&error];
    XCTAssertNil(error);
    [self.testTable updateValue:[@"newAvatar" dataUsingEncoding:NSUTF8StringEncoding] forKey:@"avatar" primaryKeyValue:self.recordToUpdate.primaryKey error:&error];
    XCTAssertNil(error);
    [self.testTable updateValue:@(0.1f) forKey:@"progress" primaryKeyValue:self.recordToUpdate.primaryKey error:&error];
    XCTAssertNil(error);
    [self.testTable updateValue:nil forKey:@"nilValue" primaryKeyValue:self.recordToUpdate.primaryKey error:&error];
    XCTAssertNil(error);

    TestRecord *record = (TestRecord *)[self.testTable findWithPrimaryKey:self.recordToUpdate.primaryKey error:NULL];
    XCTAssert([record.name isEqualToString:@"testUpdateValueForKeyPrimaryKeyValue"]);
    NSString *newAvatarString = [[NSString alloc] initWithData:record.avatar encoding:NSUTF8StringEncoding];
    XCTAssert([newAvatarString isEqualToString:@"newAvatar"]);
    XCTAssertEqual([record.progress doubleValue], 0.1f);
    XCTAssertNil(record.nilValue);
}

- (void)testUpdateValueForKeyWhereKeyInList
{
    NSError *error = nil;
    [self.testTable updateValue:@"testUpdateValueForKeyWhereKeyInList" forKey:@"name" whereKey:self.testTable.primaryKeyName inList:self.primaryKeyList error:&error];
    XCTAssertNil(error);
    [self.testTable updateValue:[@"newAvatar" dataUsingEncoding:NSUTF8StringEncoding] forKey:@"avatar" whereKey:self.testTable.primaryKeyName inList:self.primaryKeyList error:&error];
    XCTAssertNil(error);
    [self.testTable updateValue:@(0.1f) forKey:@"progress" whereKey:self.testTable.primaryKeyName inList:self.primaryKeyList error:&error];
    XCTAssertNil(error);
    [self.testTable updateValue:nil forKey:@"nilValue" whereKey:self.testTable.primaryKeyName inList:self.primaryKeyList error:&error];
    XCTAssertNil(error);

    NSArray <TestRecord *> *recordListToCheck = (NSArray <TestRecord *> *)[self.testTable findAllWithPrimaryKey:self.primaryKeyList error:NULL];
    XCTAssertEqual(recordListToCheck.count, self.primaryKeyList.count);
    [recordListToCheck enumerateObjectsUsingBlock:^(TestRecord * _Nonnull recordToCheck, NSUInteger idx, BOOL * _Nonnull stop) {
        XCTAssert([recordToCheck.name isEqualToString:@"testUpdateValueForKeyWhereKeyInList"]);
        NSString *newAvatarString = [[NSString alloc] initWithData:recordToCheck.avatar encoding:NSUTF8StringEncoding];
        XCTAssert([newAvatarString isEqualToString:@"newAvatar"]);
        XCTAssertEqual([recordToCheck.progress doubleValue], 0.1f);
        XCTAssertNil(recordToCheck.nilValue);
    }];
}

- (void)testUpdateKeyValueListWhereConditionWhereConditionParams
{
    NSError *error = nil;
    [self.testTable updateKeyValueList:@{
                                         @"name":@"testUpdateKeyValueListWhereConditionWhereConditionParams",
                                         @"avatar":[@"newAvatar" dataUsingEncoding:NSUTF8StringEncoding],
                                         @"progress":@(0.1f),
                                         @"nilValue":[NSNull null],
                                         }
                        whereCondition:@"primaryKey > :primaryKeyValue"
                  whereConditionParams:@{@":primaryKeyValue":@0,}
                                 error:&error];
    XCTAssertNil(error);

    NSArray <TestRecord *> *recordListToCheck = (NSArray <TestRecord *> *)[self.testTable findAllWithPrimaryKey:self.primaryKeyList error:NULL];
    XCTAssertEqual(recordListToCheck.count, self.primaryKeyList.count);
    [recordListToCheck enumerateObjectsUsingBlock:^(TestRecord * _Nonnull recordToCheck, NSUInteger idx, BOOL * _Nonnull stop) {
        XCTAssert([recordToCheck.name isEqualToString:@"testUpdateKeyValueListWhereConditionWhereConditionParams"]);
        NSString *newAvatarString = [[NSString alloc] initWithData:recordToCheck.avatar encoding:NSUTF8StringEncoding];
        XCTAssert([newAvatarString isEqualToString:@"newAvatar"]);
        XCTAssertEqual([recordToCheck.progress doubleValue], 0.1f);
        XCTAssertNil(recordToCheck.nilValue);
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
    [self.testTable updateValue:[@"newAvatar" dataUsingEncoding:NSUTF8StringEncoding]
                         forKey:@"avatar"
            primaryKeyValueList:self.primaryKeyList
                          error:&error];
    XCTAssertNil(error);
    [self.testTable updateValue:@(0.1f)
                         forKey:@"progress"
            primaryKeyValueList:self.primaryKeyList
                          error:&error];
    XCTAssertNil(error);
    [self.testTable updateValue:nil
                         forKey:@"nilValue"
            primaryKeyValueList:self.primaryKeyList
                          error:&error];
    XCTAssertNil(error);

    NSArray <TestRecord *> *recordListToCheck = (NSArray <TestRecord *> *)[self.testTable findAllWithPrimaryKey:self.primaryKeyList error:NULL];
    XCTAssertEqual(recordListToCheck.count, self.primaryKeyList.count);
    [recordListToCheck enumerateObjectsUsingBlock:^(TestRecord * _Nonnull recordToCheck, NSUInteger idx, BOOL * _Nonnull stop) {
        XCTAssert([recordToCheck.name isEqualToString:@"testUpdateValueForKeyPrimaryKeyValueList"]);
        NSString *newAvatarString = [[NSString alloc] initWithData:recordToCheck.avatar encoding:NSUTF8StringEncoding];
        XCTAssert([newAvatarString isEqualToString:@"newAvatar"]);
        XCTAssertEqual([recordToCheck.progress doubleValue], 0.1f);
        XCTAssertNil(recordToCheck.nilValue);
    }];
}

- (void)testUpdateKeyValueList_PrimaryKeyValueList
{
    NSError *error = nil;
    [self.testTable updateKeyValueList:@{
                                         @"age":@1,
                                         @"name":@"testUpdateKeyValueList_PrimaryKeyValueList",
                                         @"avatar":[@"newAvatar" dataUsingEncoding:NSUTF8StringEncoding],
                                         @"progress":@(0.1f),
                                         @"nilValue":[NSNull null],
                                         }
                   primaryKeyValueList:self.primaryKeyList
                                 error:&error];
    XCTAssertNil(error);

    NSArray <TestRecord *> *recordListToCheck = (NSArray <TestRecord *> *)[self.testTable findAllWithPrimaryKey:self.primaryKeyList error:NULL];
    XCTAssertEqual(recordListToCheck.count, self.primaryKeyList.count);
    [recordListToCheck enumerateObjectsUsingBlock:^(TestRecord * _Nonnull recordToCheck, NSUInteger idx, BOOL * _Nonnull stop) {
        XCTAssert([recordToCheck.name isEqualToString:@"testUpdateKeyValueList_PrimaryKeyValueList"]);
        XCTAssertEqual([recordToCheck.age integerValue], 1);
        NSString *newAvatarString = [[NSString alloc] initWithData:recordToCheck.avatar encoding:NSUTF8StringEncoding];
        XCTAssert([newAvatarString isEqualToString:@"newAvatar"]);
        XCTAssertEqual([recordToCheck.progress doubleValue], 0.1f);
        XCTAssertNil(recordToCheck.nilValue);
    }];
}

@end
