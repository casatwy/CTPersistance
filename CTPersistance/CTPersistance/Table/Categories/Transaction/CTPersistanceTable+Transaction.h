//
//  CTPersistanceTable+Transaction.h
//  CTPersistance
//
//  Created by casa on 15/10/12.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceTable.h"

@interface CTPersistanceTable (Transaction)

- (void)transactionBegin;
- (void)transactionCommit;
- (void)transactionRollback;

@end
