//
//  TestCaseTransaction.m
//  CTPersistance
//
//  Created by casa on 15/10/12.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "TestCaseTransaction.h"

#import "CTPersistanceTransaction.h"

#import "TestTable.h"
#import "TestRecord.h"

@implementation TestCaseTransaction

- (void)test
{
    TestTable *testTable = [[TestTable alloc] init];
    CTPersistanceQueryCommand *queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:testTable.databaseName];
    
    NSLog(@"transaction start1");
    [CTPersistanceTransaction performTranscationWithBlock:^(BOOL *shouldRollback) {
        NSUInteger count = 10000;
        while (count --> 0) {
            TestRecord *record = [[TestRecord alloc] init];
            record.age = @(count);
            record.name = @"casa";
            record.tomas = @"casa";
            [testTable insertRecord:record error:NULL];
        }
        *shouldRollback = YES;
    } queryCommand:queryCommand lockType:CTPersistanceTransactionLockTypeDefault];
    NSLog(@"transaction end1");
    
    NSLog(@"transaction start2");
    [CTPersistanceTransaction performTranscationWithBlock:^(BOOL *shouldRollback) {
        NSUInteger count = 10000;
        while (count --> 0) {
            TestRecord *record = [[TestRecord alloc] init];
            record.age = @(count);
            record.name = @"casa";
            record.tomas = @"casa";
            [testTable insertRecord:record error:NULL];
        }
        *shouldRollback = NO;
    } queryCommand:queryCommand lockType:CTPersistanceTransactionLockTypeDefault];
    NSLog(@"transaction end2");
    
    [testTable deleteWithWhereCondition:@"primaryKey > 1000" conditionParams:nil error:NULL];
}

@end
