//
//  CTPersistanceTable+Transaction.m
//  CTPersistance
//
//  Created by casa on 15/10/12.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceTable+Transaction.h"
#import "CTPersistanceQueryCommand.h"

@implementation CTPersistanceTable (Transaction)

- (void)transactionBegin
{
    NSError *error = nil;
    [self.queryCommand resetQueryCommand];
    [self.queryCommand.sqlString appendString:@"BEGIN transaction;"];
    [self.queryCommand executeWithError:&error];
    if (error) {
        NSLog(@"error");
    }
}

- (void)transactionCommit
{
    NSError *error = nil;
    [self.queryCommand resetQueryCommand];
    [self.queryCommand.sqlString appendString:@"COMMIT transaction;"];
    [self.queryCommand executeWithError:&error];
    if (error) {
        NSLog(@"error");
    }
}

- (void)transactionRollback
{
    NSError *error = nil;
    [self.queryCommand resetQueryCommand];
    [self.queryCommand.sqlString appendString:@"ROLLBACK transaction;"];
    [self.queryCommand executeWithError:&error];
    if (error) {
        NSLog(@"error");
    }
}

@end
