//
//  CTPersistanceTransaction.h
//  CTPersistance
//
//  Created by casa on 15/10/13.
//  Copyright © 2015年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CTPersistanceQueryCommand.h"

/**
 *  specify the lock type when transaction begins.
 */
typedef NS_ENUM(NSUInteger, CTPersistanceTransactionLockType){
    /**
     *  perform BEGIN DEFERRED TRANSACTION, which uses SHARED lock.
     */
    CTPersistanceTransactionLockTypeDefault,
    /**
     *  perform BEGIN DEFERRED TRANSACTION, which uses SHARED lock.
     */
    CTPersistanceTransactionLockTypeDeferred,
    /**
     *  perform BEGIN IMMEDIATE TRANSACTION, which uses RESERVED lock.
     */
    CTPersistanceTransactionLockTypeImmediate,
    /**
     *  perform BEGIN EXCLUSIVE TRANSACTION, which uses EXCLUSIVE lock.
     */
    CTPersistanceTransactionLockTypeExclusive,
};

/**
 *  a class to perform transaction.
 */
@interface CTPersistanceTransaction : NSObject

/**
 *  perform transaction
 *
 *  @param transactionBlock transaction block
 *  @param queryCommand     CTPersistanceQueryCommand instance
 *  @param lockType         the lock type of transaction, use CTPersistanceTransactionLockTypeDefault if you are not sure which lock to use
 */
+ (void)performTranscationWithBlock:(void(^)(BOOL *shouldRollback))transactionBlock
                       queryCommand:(CTPersistanceQueryCommand *)queryCommand
                           lockType:(CTPersistanceTransactionLockType)lockType;

@end
