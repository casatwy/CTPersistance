//
//  NSString+SafeSQL.h
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SQL)

/**
 *  make string safe as a SQL string which will turn (') to (\') and (\) to (\\) and remove every (;).
 *
 *  @return return the encoded string.
 *
 *  @see safeSQLDecode:
 */
- (NSString *)safeSQLEncode;

/**
 *  decode the string which is encoded for SQL.
 *
 *  @return return the decoded string.
 *
 *  @see safeSQLDecode:
 *  @see safeSQLMetaString:
 */
- (NSString *)safeSQLDecode;

/**
 *  make string safe for SQL using which will remove (`) and (')
 *
 *  @return return the string which has removed (`) and (')
 */
- (NSString *)safeSQLMetaString;

/**
 *  put params in String.
 
 Example:
    NSString *string = @"hello :something";
    NSDictionary *params = @{
        @"something":@"world"
    };
    NSString *newString = [string stringWithSQLParams:params];
    NSLog
 *
 *  @param params params in String to replace
 *
 *  @return return a string.
 */
- (NSString *)stringWithSQLParams:(NSDictionary *)params;

@end
