//
//  TestCaseWhereCondition.m
//  CTPersistance
//
//  Created by casa on 15/10/15.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "TestCaseWhereCondition.h"
#import "NSString+SQL.h"
#import <UIKit/UIKit.h>

@implementation TestCaseWhereCondition

- (void)test
{
    NSString *whereCondition = @":key = :value";
    NSString *key = @"hello";
    NSString *value = @"world";
    
    /* test 6001 */
    NSString *result = [whereCondition stringWithSQLParams:NSDictionaryOfVariableBindings(key, value)];
    if ([result isEqualToString:@"'hello' = 'world'"]) {
        NSLog(@"6001 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    
    /* test 6002 */
    whereCondition = @":key = :keyvalue";
    result = [whereCondition stringWithSQLParams:NSDictionaryOfVariableBindings(key)];
    if ([result isEqualToString:@"'hello' = :keyvalue"]) {
        NSLog(@"6002 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    
    /* test 6003 */
    whereCondition = @":key = :key_value";
    NSString *key_value = @"world";
    result = [whereCondition stringWithSQLParams:NSDictionaryOfVariableBindings(key, key_value)];
    if ([result isEqualToString:@"'hello' = 'world'"]) {
        NSLog(@"6003 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    
    /* test 6004 */
    whereCondition = @":key = :key_value";
    key = @"world";
    result = [whereCondition stringWithSQLParams:NSDictionaryOfVariableBindings(key)];
    if ([result isEqualToString:@"'world' = :key_value"]) {
        NSLog(@"6004 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    
    /* test 6005 */
    whereCondition = @":key = :key_value";
    result = [whereCondition stringWithSQLParams:@{}];
    if ([result isEqualToString:@":key = :key_value"]) {
        NSLog(@"6005 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    
    /* test 6006 */
    whereCondition = @":key = :key_value";
    result = [whereCondition stringWithSQLParams:nil];
    if ([result isEqualToString:@":key = :key_value"]) {
        NSLog(@"6006 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    
    /* test 6007 */
    whereCondition = @":key = :key_value :key :key :k :key_value";
    key = @"casa";
    result = [whereCondition stringWithSQLParams:NSDictionaryOfVariableBindings(key)];
    if ([result isEqualToString:@"'casa' = :key_value 'casa' 'casa' :k :key_value"]) {
        NSLog(@"6007 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
    
    /* test 6008 */
    whereCondition = @":key=:keyvalue";
    key = @"hello";
    NSString *keyvalue = @"world";
    result = [whereCondition stringWithSQLParams:NSDictionaryOfVariableBindings(key, keyvalue)];
    if ([result isEqualToString:@"'hello'='world'"]) {
        NSLog(@"6008 success");
    } else {
        NSException *exception = [[NSException alloc] init];
        @throw exception;
    }
}

@end
