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
    
    switch (lockType) {
        case CTPersistanceTransactionLockTypeExclusive:
        {
            [[queryCommand compileSqlString:@"BEGIN EXCLUSIVE TRANSACTION;" bindValueList:nil error:NULL] executeWithError:NULL];
            break;
        }
            
        case CTPersistanceTransactionLockTypeImmediate:
        {
            [[queryCommand compileSqlString:@"BEGIN IMMEDIATE TRANSACTION;" bindValueList:nil error:NULL] executeWithError:NULL];
            break;
        }
            
        case CTPersistanceTransactionLockTypeDeferred:
        case CTPersistanceTransactionLockTypeDefault:
        default:
        {
            [[queryCommand compileSqlString:@"BEGIN DEFERRED TRANSACTION;" bindValueList:nil error:NULL] executeWithError:NULL];
            break;
        }
    }
    
    BOOL shouldRollback = NO;
    transactionBlock(&shouldRollback);

    if (shouldRollback) {
        [[queryCommand compileSqlString:@"ROLLBACK TRANSACTION;" bindValueList:nil error:NULL] executeWithError:NULL];
    } else {
        [[queryCommand compileSqlString:@"COMMIT TRANSACTION;" bindValueList:nil error:NULL] executeWithError:NULL];
    }
}

@end
