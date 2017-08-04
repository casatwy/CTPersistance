//
//  NSString+Where.h
//  CTPersistance
//
//  Created by casa on 2017/8/4.
//  Copyright © 2017年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Where)

- (NSString *)whereStringWithConditionParams:(NSDictionary *)conditionParams bindValueList:(NSMutableArray <NSInvocation *> *)bindValueList;

@end
