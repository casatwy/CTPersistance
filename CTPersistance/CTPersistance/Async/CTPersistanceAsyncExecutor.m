//
//  CTPersistanceAsyncAction.m
//  CTPersistance
//
//  Created by casa on 15/10/17.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceAsyncExecutor.h"

@interface CTPersistanceAsyncExecutor ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation CTPersistanceAsyncExecutor

#pragma mark - public methods
+ (instancetype)sharedInstance
{
    static CTPersistanceAsyncExecutor *executor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        executor = [[CTPersistanceAsyncExecutor alloc] init];
    });
    return executor;
}

- (void)performAsyncAction:(void (^)(void))action shouldWaitUntilDone:(BOOL)shouldWaitUntilDone
{
    __block BOOL shouldWait = shouldWaitUntilDone;
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        action();
        shouldWait = NO;
    }];
    
    [self.operationQueue addOperation:operation];
    
    while (shouldWait) {
    }
}

#pragma mark - getters and setters
- (NSOperationQueue *)operationQueue
{
    if (_operationQueue == nil) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 1;
    }
    return _operationQueue;
}

@end
