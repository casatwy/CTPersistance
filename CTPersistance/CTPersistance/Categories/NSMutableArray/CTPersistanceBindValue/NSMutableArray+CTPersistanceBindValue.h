//
//  NSMutableArray+CTPersistanceBindValue.h
//  CTPersistance
//
//  Created by casa on 2017/7/30.
//  Copyright © 2017年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (CTPersistanceBindValue)

- (void)printBindInfo;
- (void)addBindKey:(NSString *)bindKey bindValue:(id)bindValue;

@end
