//
//  CTPersistanceAsyncAction.m
//  CTPersistance
//
//  Created by casa on 15/10/17.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceAsyncExecutor.h"

@interface CTPersistanceAsyncExecutor ()

#if OS_OBJECT_HAVE_OBJC_SUPPORT == 1
@property (nonatomic, strong) dispatch_queue_t queue;
#else
@property (nonatomic, assign) dispatch_queue_t queue;
#endif

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.queue = dispatch_queue_create("CTPersistanceAsyncThread", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

#pragma mark - public methods
- (void)write:(void (^)(void))writeAction
{
    dispatch_barrier_async(self.queue, ^{
        writeAction();
    });
}

- (void)read:(void (^)(void))readAction
{
    dispatch_async(self.queue, ^{
        readAction();
    });
}

- (void)syncRead:(void (^)(void))readAction {
    dispatch_sync(self.queue, ^{
        readAction();
    });
}

@end
