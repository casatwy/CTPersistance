//
//  NSString+SafeSQL.m
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "NSString+SQL.h"

@implementation NSString (SQL)

- (NSString *)safeSQLEncode
{
    NSString *safeSQL = [self copy];
    safeSQL = [safeSQL stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
    safeSQL = [safeSQL stringByReplacingOccurrencesOfString:@";" withString:@""];
    return safeSQL;
}

- (NSString *)safeSQLDecode
{
    NSString *safeSQL = [self copy];
    safeSQL = [safeSQL stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
    return safeSQL;
}

- (NSString *)safeSQLMetaString
{
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"'`"];
    return [[self componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
}

- (NSString *)stringWithSQLParams:(NSDictionary *)params
{
    NSMutableArray *keyList = [[NSMutableArray alloc] init];
    
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@":[\\w]*" options:0 error:NULL];
    NSArray *list = [expression matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    [list enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull checkResult, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *subString = [self substringWithRange:checkResult.range];
        [keyList addObject:[subString substringWithRange:NSMakeRange(1, subString.length-1)]];
    }];
    
    NSMutableString *resultString = [self mutableCopy];
    [keyList enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        if (params[key]) {
            NSRegularExpression *expressionForReplace = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@":%@\\b", key] options:0 error:NULL];
            [expressionForReplace replaceMatchesInString:resultString options:0 range:NSMakeRange(0, resultString.length) withTemplate:params[key]];
        }
    }];
    
    return resultString;
}

@end
