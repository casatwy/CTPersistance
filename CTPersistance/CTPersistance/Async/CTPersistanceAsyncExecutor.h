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

- (void)write:(void (^)(void))writeAction;

- (void)read:(void (^)(void))readAction;

- (void)syncRead:(void (^)(void))readAction;

@end
