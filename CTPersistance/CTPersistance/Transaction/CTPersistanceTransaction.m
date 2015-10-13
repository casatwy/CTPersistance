//
//  CTPersistanceTransaction.m
//  CTPersistance
//
//  Created by casa on 15/10/13.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceTransaction.h"

@implementation CTPersistanceTransaction

+ (void)performTranscationWithBlock:(void (^)(BOOL *))transactionBlock queryCommand:(CTPersistanceQueryCommand *)queryCommand lockType:(CTPersistanceTransactionLockType)lockType
{
    if (queryCommand == nil || transactionBlock == nil) {
        return;
    }
    
    [queryCommand resetQueryCommand];
    switch (lockType) {
        case CTPersistanceTransactionLockTypeExclusive:
        {
            [queryCommand.sqlString appendString:@"BEGIN EXCLUSIVE TRANSACTION"];
            break;
        }
            
        case CTPersistanceTransactionLockTypeImmediate:
        {
            [queryCommand.sqlString appendString:@"BEGIN IMMEDIATE TRANSACTION"];
            break;
        }
            
        case CTPersistanceTransactionLockTypeDeferred:
        case CTPersistanceTransactionLockTypeDefault:
        default:
        {
            [queryCommand.sqlString appendString:@"BEGIN DEFERRED TRANSACTION"];
            break;
        }
    }
    [queryCommand executeWithError:NULL];
    
    BOOL shouldRollback = NO;
    transactionBlock(&shouldRollback);

    if (shouldRollback) {
        [queryCommand resetQueryCommand];
        [queryCommand.sqlString appendString:@"ROLLBACK TRANSACTION"];
        [queryCommand executeWithError:NULL];
    }
}

@end
