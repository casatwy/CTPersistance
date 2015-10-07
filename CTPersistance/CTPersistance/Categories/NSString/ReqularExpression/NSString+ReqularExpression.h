//
//  NSString+ReqularExpression.h
//  CTPersistance
//
//  Created by casa on 15/10/7.
//  Copyright © 2015年 casa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (ReqularExpression)

- (BOOL)isMatchWithRegularExpression:(NSString *)regularExpressionPattern;

@end
