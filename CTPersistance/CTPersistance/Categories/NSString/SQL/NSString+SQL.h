//
//  NSString+SafeSQL.h
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SQL)

- (NSString *)safeSQLEncode;
- (NSString *)safeSQLDecode;
- (NSString *)safeSQLMetaString;

- (NSString *)stringWithSQLParams:(NSDictionary *)params;

@end
