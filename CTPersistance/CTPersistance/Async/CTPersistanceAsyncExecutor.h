//
//  CTPersistanceAsyncAction.h
//  CTPersistance
//
//  Created by casa on 15/10/17.
//  Copyright © 2015年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTPersistanceAsyncExecutor : NSObject

+ (instancetype)sharedInstance;
- (void)performAsyncAction:(void (^)(void))action shouldWaitUntilDone:(BOOL)shouldWaitUntilDone;

@end
