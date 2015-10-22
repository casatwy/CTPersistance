//
//  CTPersistanceAsyncAction.h
//  CTPersistance
//
//  Created by casa on 15/10/17.
//  Copyright © 2015年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  aysnc action executor for multi-thread
 */
@interface CTPersistanceAsyncExecutor : NSObject

/**
 *  you should always use shared instance to perform asynchronize action
 *
 *  @return return the shared instance
 */
+ (instancetype)sharedInstance;

/**
 *  perform aync action.
 *
 *  you must always create CTPersistanceTable in action block, do not use outside table instance in this block.
 *
 *  @param action              the action block to be performed
 *  @param shouldWaitUntilDone if YES, this method will not end until action block has finished.
 */
- (void)performAsyncAction:(void (^)(void))action shouldWaitUntilDone:(BOOL)shouldWaitUntilDone;

@end
