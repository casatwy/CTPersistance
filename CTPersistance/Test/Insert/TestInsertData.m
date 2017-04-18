//
//  TestInsertDataCenter.m
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "TestInsertData.h"

#import "TestTable.h"
#import "CTPersistance.h"

@implementation TestInsertData

- (void)test
{
    NSError *error = nil;
    
    /* test 1001 */
    TestTable *table = [[TestTable alloc] init];
    TestRecord *record = [[TestRecord alloc] init];
    record.age = @(1);
    record.name = @"1";
    record.tomas = @"1";
    [table insertRecord:record error:&error];
    if ([record.primaryKey integerValue] > 0) {
        NSLog(@"1001 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    
    /* test 1002 */
    error = nil;
    record = [[TestRecord alloc] init];
    [table insertRecord:record error:&error];
    if (error) {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    } else {
        NSLog(@"1002 success");
    }
    
    /* test 1003 */
    error = nil;
    [table insertRecord:nil error:&error];
    if (error) {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    } else {
        NSLog(@"1003 success");
    }
    
    /* test 1004 */
    error = nil;
    NSMutableArray *recordList = [[NSMutableArray alloc] init];
    NSUInteger count = 100;
    while (count --> 0) {
        record = [[TestRecord alloc] init];
        record.age = @(count);
        record.name = [NSString stringWithFormat:@"%ld", (unsigned long)count];
        record.tomas = record.name;
        [recordList addObject:record];
    }
    [table insertRecordList:recordList error:&error];
    if (error == nil) {
        NSLog(@"1004 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    
    /* test 1005 */
    error = nil;
    [table insertRecordList:nil error:&error];
    if (error) {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    } else {
        NSLog(@"1005 success");
    }
    
    /* test 1006 */
    error = nil;
    record = [[TestRecord alloc] init];
    record.age = @(1);
    record.name = @"1";
    [table insertRecord:record error:&error];
    if (error == nil) {
        NSLog(@"1006 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    
    /* test 1007*/
    error = nil;
    record = [[TestRecord alloc] init];
    record.age = @(1);
    record.name = @"I'm";
    record.tomas = @"tomas";
    [table insertRecord:record error:&error];
    if (error == nil && [record.name isEqualToString:@"I'm"]) {
        NSLog(@"1007 success");
        record = (TestRecord *)[table findWithPrimaryKey:record.primaryKey error:&error];
        NSLog(@"%@", [record dictionaryRepresentationWithTable:table]);
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }

    /* test 1008 */
    error = nil;
    record = [[TestRecord alloc] init];
    record.age = @(1);
    record.name = @"I'm";
    record.tomas = @"123-456-789";
    [table insertRecord:record error:&error];
    if (error == nil) {
        record = (TestRecord *)[[table findAllWithKeyName:@"tomas" value:@"123-456-789" error:&error] firstObject];
        if ([record.tomas isEqualToString:@"123-456-789"]) {
            NSLog(@"1008 success");
        }
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }

    /* test 1009 */
    error = nil;
    record = [[TestRecord alloc] init];
    record.age = @(1);
    record.name = @"I'm";
    record.tomas = @"123.456.789";
    [table insertRecord:record error:&error];
    if (error == nil) {
        record = (TestRecord *)[[table findAllWithKeyName:@"tomas" value:@"123.456.789" error:&error] firstObject];
        if ([record.tomas isEqualToString:@"123.456.789"]) {
            NSLog(@"1009 success");
        }
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
}

@end
