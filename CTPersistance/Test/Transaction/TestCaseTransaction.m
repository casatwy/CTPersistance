//
//  TestCaseTransaction.m
//  CTPersistance
//
//  Created by casa on 15/10/12.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "TestCaseTransaction.h"

#import "CTPersistance.h"

#import "TestTable.h"
#import "TestRecord.h"

@implementation TestCaseTransaction

- (void)test
{
    NSError *error = nil;
    TestTable *table = [[TestTable alloc] init];
    
    NSMutableArray *recordList = [[NSMutableArray alloc] init];
    NSInteger count = 3;
    while (count --> 0) {
        TestRecord *record = [[TestRecord alloc] init];
        record.name = [NSString stringWithFormat:@"%ld", (long)count];
        record.age = @(count);
        record.tomas = @"tomas";
        [recordList addObject:record];
    }
    [recordList[1] setTomas:nil];
    
    [table transactionBegin];
    [recordList enumerateObjectsUsingBlock:^(TestRecord * _Nonnull record, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError *error;
        [table insertRecord:record error:&error];
        if (record.primaryKey == nil) {
            NSLog(@"error is %@", error);
//            [table transactionRollback];
            *stop = YES;
        }
    }];
    [table transactionCommit];
    
}

@end
