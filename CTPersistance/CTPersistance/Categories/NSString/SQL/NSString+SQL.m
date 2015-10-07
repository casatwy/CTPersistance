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
    return [[[self stringByReplacingOccurrencesOfString:@"`" withString:@""] stringByReplacingOccurrencesOfString:@"'" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)stringWithSQLParams:(NSDictionary *)params
{
    NSMutableString *string = [self mutableCopy];
    [params enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull value, BOOL * _Nonnull stop) {
        NSString *alterKey = [NSString stringWithFormat:@":%@", key];
        if ([value isKindOfClass:[NSString class]]) {
            value = [value safeSQLEncode];
        }
        [string replaceOccurrencesOfString:alterKey withString:[NSString stringWithFormat:@"%@", value] options:0 range:NSMakeRange(0, string.length)];
    }];
    return [string copy];
}

@end
