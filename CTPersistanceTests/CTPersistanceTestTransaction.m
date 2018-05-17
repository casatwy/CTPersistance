//
//  CTPersistanceTestTransaction.m
//  CTPersistance
//
//  Created by casa on 2017/9/13.
//  Copyright © 2017年 casa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestTable.h"
#import "TestRecord.h"

@interface CTPersistanceTestTransaction : XCTestCase

@property (nonatomic, strong) TestTable *testTable;

@end

@implementation CTPersistanceTestTransaction

- (void)setUp
{
    [super setUp];
    
    self.testTable = [[TestTable alloc] init];
    [self.testTable truncate];
    
    NSInteger count = 10;
    while (count --> 0) {
        [self.testTable insertValue:[NSString stringWithFormat:@"%ld", (long)count] forKey:@"name" error:NULL];
    }
}

- (void)tearDown
{
    [self.testTable truncate];
    [super tearDown];
}

- (void)testInsertTransactionCommit
{
    [CTPersistanceTransaction performTranscationWithBlock:^(BOOL *shouldRollback) {
        NSInteger count = 10;
        while (count --> 0) {
            [self.testTable insertValue:@"casa" forKey:@"name" error:NULL];
        }
        *shouldRollback = NO;
    }
                                             queryCommand:self.testTable.queryCommand
                                                 lockType:CTPersistanceTransactionLockTypeDefault];
    
    NSInteger count = [self.testTable countWithWhereCondition:@"name = :name" conditionParams:@{@":name":@"casa"} error:NULL];
    XCTAssertEqual(count, 10);
}

- (void)testDeleteTransactionCommit
{
    [CTPersistanceTransaction performTranscationWithBlock:^(BOOL *shouldRollback) {
        [self.testTable deleteWithWhereCondition:@"name = :name" conditionParams:@{@":name":@"casa"} error:NULL];
    }
                                             queryCommand:self.testTable.queryCommand
                                                 lockType:CTPersistanceTransactionLockTypeDefault];
    
    NSInteger count = [self.testTable countWithWhereCondition:@"name = :name" conditionParams:@{@":name":@"casa"} error:NULL];
    XCTAssertEqual(count, 0);
}

- (void)testUpdateTransactionCommit
{
    NSArray <TestRecord *> *recordList = (NSArray <TestRecord *> *)[self.testTable findAllWithError:NULL];
    [CTPersistanceTransaction performTranscationWithBlock:^(BOOL *shouldRollback) {
        [recordList enumerateObjectsUsingBlock:^(TestRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.age = @(42);
            [self.testTable updateRecord:obj error:NULL];
        }];
        *shouldRollback = NO;
    }
                                             queryCommand:self.testTable.queryCommand
                                                 lockType:CTPersistanceTransactionLockTypeDefault];
    
    NSInteger count = [self.testTable countWithWhereCondition:@"age = 42" conditionParams:NULL error:NULL];
    XCTAssertEqual(count, 10);
}

- (void)testInsertTransactionRollback
{
    [CTPersistanceTransaction performTranscationWithBlock:^(BOOL *shouldRollback) {
        NSInteger count = 10;
        while (count --> 0) {
            [self.testTable insertValue:@"casa" forKey:@"name" error:NULL];
        }
        *shouldRollback = YES;
    }
                                             queryCommand:self.testTable.queryCommand
                                                 lockType:CTPersistanceTransactionLockTypeDefault];
    
    NSInteger count = [self.testTable countWithWhereCondition:@"name = :name" conditionParams:@{@":name":@"casa"} error:NULL];
    XCTAssertEqual(count, 0);
}

- (void)testDeleteTransactionRollback
{
    [CTPersistanceTransaction performTranscationWithBlock:^(BOOL *shouldRollback) {
        [self.testTable deleteWithWhereCondition:@"primaryKey > 0" conditionParams:NULL error:NULL];
        *shouldRollback = YES;
    }
                                             queryCommand:self.testTable.queryCommand
                                                 lockType:CTPersistanceTransactionLockTypeDefault];
    
    NSInteger count = [self.testTable countWithWhereCondition:@"primaryKey > 0" conditionParams:NULL error:NULL];
    XCTAssertEqual(count, 10);
}

- (void)testUpdateTransactionRollback
{
    NSArray <TestRecord *> *recordList = (NSArray <TestRecord *> *)[self.testTable findAllWithError:NULL];
    [CTPersistanceTransaction performTranscationWithBlock:^(BOOL *shouldRollback) {
        [recordList enumerateObjectsUsingBlock:^(TestRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.age = @(42);
            [self.testTable updateRecord:obj error:NULL];
        }];
        *shouldRollback = YES;
    }
                                             queryCommand:self.testTable.queryCommand
                                                 lockType:CTPersistanceTransactionLockTypeDefault];
    
    NSInteger count = [self.testTable countWithWhereCondition:@"age = 42" conditionParams:NULL error:NULL];
    XCTAssertEqual(count, 0);
}

@end
