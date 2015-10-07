//
//  NSString+ReqularExpression.m
//  CTPersistance
//
//  Created by casa on 15/10/7.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "NSString+ReqularExpression.h"

@implementation NSString (ReqularExpression)

- (BOOL)isMatchWithRegularExpression:(NSString *)regularExpressionPattern
{
    NSError *error = nil;
    NSUInteger option = NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators | NSRegularExpressionUseUnixLineSeparators | NSRegularExpressionAnchorsMatchLines;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regularExpressionPattern options:option error:&error];
    NSUInteger numberOfMatches = [regularExpression numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)];
    if (numberOfMatches > 0) {
        return YES;
    } else {
        return NO;
    }
}

@end
