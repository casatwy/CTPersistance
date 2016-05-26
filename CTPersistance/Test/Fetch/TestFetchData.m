//
//  TestFetchData.m
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "TestFetchData.h"
#import "CTPersistance.h"
#import "TestTable.h"
#import <UIKit/UIKit.h>

@implementation TestFetchData

- (void)test
{
    NSLog(@"Start Fetch Test");
    
    TestTable *table = [[TestTable alloc] init];
    NSError *error = nil;
    
    /* test 2001 */
    NSString *whereCondition = @":primaryKey > 50";
    NSString *primaryKey = [table primaryKeyName];
    NSDictionary *whereConditionParams = NSDictionaryOfVariableBindings(primaryKey);
    NSArray *fetchedRecordList = [table findAllWithWhereCondition:whereCondition conditionParams:whereConditionParams isDistinct:NO error:&error];
    if ([fetchedRecordList count] > 0 && error == nil) {
        NSLog(@"2001 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    
    /* test 2002 */
    error = nil;
    whereCondition = @":primaryKey > :value";
    primaryKey = [table primaryKeyName];
    NSNumber *value = @(50);
    whereConditionParams = NSDictionaryOfVariableBindings(primaryKey, value);
    fetchedRecordList = [table findAllWithWhereCondition:whereCondition conditionParams:whereConditionParams isDistinct:NO error:&error];
    if ([fetchedRecordList count] > 0 && error == nil) {
        NSLog(@"2002 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    
    /* test 2003 */
    error = nil;
    whereCondition = @":primaryKey > :minValue and :primaryKey < :maxValue";
    primaryKey = [table primaryKeyName];
    NSNumber *minValue = @(10);
    NSString *maxValue = @"20";
    whereConditionParams = NSDictionaryOfVariableBindings(primaryKey, minValue, maxValue);
    fetchedRecordList = [table findAllWithWhereCondition:whereCondition conditionParams:whereConditionParams isDistinct:NO error:&error];
    if ([fetchedRecordList count] == 9 && error == nil) {
        NSLog(@"2003 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    
    /* test 2004 */
    error = nil;
    NSString *sqlString = @"SELECT * FROM :tableName WHERE :age > :minAgeValue and :age < :maxAgeValue;";
    NSString *tableName = [table tableName];
    NSString *age = @"age";
    NSNumber *minAgeValue = @(10);
    NSNumber *maxAgeValue = @(20);
    NSDictionary *params = NSDictionaryOfVariableBindings(tableName, age, minAgeValue, maxAgeValue);
    fetchedRecordList = [table findAllWithSQL:sqlString params:params error:&error];
    if ([fetchedRecordList count] > 0 && error == nil) {
        NSLog(@"2004 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    
    /* test 2005 */
    error = nil;
    sqlString = @"SELECT * FROM :tableName WHERE :age > :minAgeValue and :age < :maxAgeValue;";
    tableName = [table tableName];
    age = @"age";
    minAgeValue = @(10);
    maxAgeValue = @(20);
    params = NSDictionaryOfVariableBindings(age, minAgeValue, maxAgeValue);
    fetchedRecordList = [table findAllWithSQL:sqlString params:params error:&error];
    if ([fetchedRecordList count] > 0 || error == nil) {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    } else {
        NSLog(@"2005 success");
    }
    
    /* test 2006 */
    error = nil;
    sqlString = @"SELECT * FROM :tableName WHERE :age > :minAgeValue and :age < :maxAgeValue;";
    tableName = [table tableName];
    age = @"age";
    minAgeValue = @(10);
    maxAgeValue = @(20);
    params = NSDictionaryOfVariableBindings(tableName, minAgeValue, maxAgeValue);
    fetchedRecordList = [table findAllWithSQL:sqlString params:params error:&error];
    if ([fetchedRecordList count] > 0) {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    } else {
        NSLog(@"2006 success");
    }
    
    /* test 2007 */
    error = nil;
    sqlString = @"SELECT * FROM :tableName WHERE :age > :minAgeValue and :age < :maxAgeValue;";
    tableName = [table tableName];
    age = @"age";
    minAgeValue = @(10);
    maxAgeValue = @(20);
    params = NSDictionaryOfVariableBindings(tableName, age, maxAgeValue);
    fetchedRecordList = [table findAllWithSQL:sqlString params:params error:&error];
    if ([fetchedRecordList count] > 0) {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    } else {
        NSLog(@"2007 success");
    }
    
    /* test 2008 */
    error = nil;
    sqlString = @"SELECT * FROM :tableName WHERE :age > :minAgeValue and :age < :maxAgeValue;";
    tableName = [table tableName];
    age = @"age";
    minAgeValue = @(10);
    maxAgeValue = @(20);
    params = NSDictionaryOfVariableBindings(tableName, age, minAgeValue, maxAgeValue);
    fetchedRecordList = [table findAllWithSQL:nil params:params error:&error];
    if ([fetchedRecordList count] > 0) {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    } else {
        NSLog(@"2008 success");
    }
    
    /* test 2009 */
    error = nil;
    sqlString = @"SELECT * FROM :tableName WHERE :age > :minAgeValue and :age < :maxAgeValue;";
    tableName = [table tableName];
    age = @"age";
    minAgeValue = @(10);
    maxAgeValue = @(20);
    params = NSDictionaryOfVariableBindings(tableName, age, minAgeValue, maxAgeValue);
    fetchedRecordList = [table findAllWithSQL:sqlString params:nil error:&error];
    if ([fetchedRecordList count] > 0 || error == nil) {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    } else {
        NSLog(@"2009 success");
    }
    
    /* test 2010 */
    error = nil;
    sqlString = @"SELECT * FROM test WHERE age > 10 and age < 20;";
    fetchedRecordList = [table findAllWithSQL:sqlString params:nil error:&error];
    if ([fetchedRecordList count] > 0) {
        NSLog(@"2010 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    
    /* test 2011 */
    error = nil;
    whereCondition = @":primaryKey > 50";
    primaryKey = [table primaryKeyName];
    whereConditionParams = NSDictionaryOfVariableBindings(primaryKey);
    TestRecord *record = (TestRecord *)[table findFirstRowWithWhereCondition:whereCondition conditionParams:whereConditionParams isDistinct:NO error:&error];
    if (record && error == nil) {
        NSLog(@"2011 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    
    /* test 2012 */
    error = nil;
    whereCondition = @":primaryKey > :value";
    primaryKey = [table primaryKeyName];
    value = @(50);
    whereConditionParams = NSDictionaryOfVariableBindings(primaryKey, value);
    record = (TestRecord *)[table findFirstRowWithWhereCondition:whereCondition conditionParams:whereConditionParams isDistinct:NO error:&error];
    if (record && error == nil) {
        NSLog(@"2012 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    
    /* test 2013 */
    error = nil;
    whereCondition = @":primaryKey > :minValue and :primaryKey < :maxValue";
    primaryKey = [table primaryKeyName];
    minValue = @(10);
    maxValue = @"20";
    whereConditionParams = NSDictionaryOfVariableBindings(primaryKey, minValue, maxValue);
    record = (TestRecord *)[table findFirstRowWithWhereCondition:whereCondition conditionParams:whereConditionParams isDistinct:NO error:&error];
    if (record && error == nil) {
        NSLog(@"2013 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    
    /* test 2014 */
    error = nil;
    sqlString = @"SELECT * FROM :tableName WHERE :age > :minAgeValue and :age < :maxAgeValue;";
    tableName = [table tableName];
    age = @"age";
    minAgeValue = @(10);
    maxAgeValue = @(20);
    params = NSDictionaryOfVariableBindings(tableName, age, minAgeValue, maxAgeValue);
    record = (TestRecord *)[table findFirstRowWithSQL:sqlString params:params error:&error];
    if (record && error == nil) {
        NSLog(@"2014 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    
    /* test 2015 */
    error = nil;
    sqlString = @"SELECT * FROM :tableName WHERE :age > :minAgeValue and :age < :maxAgeValue;";
    tableName = [table tableName];
    age = @"age";
    minAgeValue = @(10);
    maxAgeValue = @(20);
    params = NSDictionaryOfVariableBindings(age, minAgeValue, maxAgeValue);
    record = (TestRecord *)[table findFirstRowWithSQL:sqlString params:params error:&error];
    if (error == nil) {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    } else {
        NSLog(@"2015 success");
    }
    
    /* test 2016 */
    error = nil;
    sqlString = @"SELECT * FROM :tableName WHERE :age > :minAgeValue and :age < :maxAgeValue;";
    tableName = [table tableName];
    age = @"age";
    minAgeValue = @(10);
    maxAgeValue = @(20);
    params = NSDictionaryOfVariableBindings(tableName, minAgeValue, maxAgeValue);
    record = (TestRecord *)[table findFirstRowWithSQL:sqlString params:params error:&error];
    if (record) {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    } else {
        NSLog(@"2016 success");
    }
    
    /* test 2017 */
    error = nil;
    sqlString = @"SELECT * FROM :tableName WHERE :age > :minAgeValue and :age < :maxAgeValue;";
    tableName = [table tableName];
    age = @"age";
    minAgeValue = @(10);
    maxAgeValue = @(20);
    params = NSDictionaryOfVariableBindings(tableName, age, maxAgeValue);
    record = (TestRecord *)[table findFirstRowWithSQL:sqlString params:params error:&error];
    if (record) {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    } else {
        NSLog(@"2017 success");
    }
    
    /* test 2018 */
    error = nil;
    sqlString = @"SELECT * FROM :tableName WHERE :age > :minAgeValue and :age < :maxAgeValue;";
    tableName = [table tableName];
    age = @"age";
    minAgeValue = @(10);
    maxAgeValue = @(20);
    params = NSDictionaryOfVariableBindings(tableName, age, minAgeValue, maxAgeValue);
    record = (TestRecord *)[table findFirstRowWithSQL:nil params:params error:&error];
    if (error == nil) {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    } else {
        NSLog(@"2018 success");
    }
    
    /* test 2019 */
    error = nil;
    sqlString = @"SELECT * FROM :tableName WHERE :age > :minAgeValue and :age < :maxAgeValue;";
    tableName = [table tableName];
    age = @"age";
    minAgeValue = @(10);
    maxAgeValue = @(20);
    params = NSDictionaryOfVariableBindings(tableName, age, minAgeValue, maxAgeValue);
    record = (TestRecord *)[table findFirstRowWithSQL:sqlString params:nil error:&error];
    if (error == nil) {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    } else {
        NSLog(@"2019 success");
    }
    
    /* test 2020 */
    error = nil;
    sqlString = @"SELECT * FROM test WHERE age > 10 and age < 20;";
    record = (TestRecord *)[table findFirstRowWithSQL:sqlString params:nil error:&error];
    if (error == nil) {
        NSLog(@"2020 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }

    /* test 2021 */
    error = nil;
    NSArray *recordList = [table findAllWithKeyName:@"name" value:@"1" error:&error];
    if (recordList.count == 0) {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    } else {
        NSLog(@"2021 success");
    }
    
    NSLog(@"End Fetch Test");
}

@end
