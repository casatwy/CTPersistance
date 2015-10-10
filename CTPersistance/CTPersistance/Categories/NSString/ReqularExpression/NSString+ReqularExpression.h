//
//  NSString+ReqularExpression.h
//  CTPersistance
//
//  Created by casa on 15/10/7.
//  Copyright © 2015年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  category for Regular Expression
 */
@interface NSString (ReqularExpression)

/**
 *  check whether the string is match to regularExpressionPattern with NSRegularExpress
 *
 *  the match option is NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators | NSRegularExpressionUseUnixLineSeparators | NSRegularExpressionAnchorsMatchLines
 *
 *  @param regularExpressionPattern regular express pattern
 *
 *  @return return YES if matches, NO if not.
 *
 */
- (BOOL)isMatchWithRegularExpression:(NSString *)regularExpressionPattern;

@end
