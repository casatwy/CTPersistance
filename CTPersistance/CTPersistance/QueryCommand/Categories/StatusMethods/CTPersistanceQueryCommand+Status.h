//
//  CTPersistanceQueryCommand+Status.h
//  CTPersistance
//
//  Created by casa on 15/10/12.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceQueryCommand.h"

@interface CTPersistanceQueryCommand (Status)

/**
 *  return last insert row id
 *
 *  @return return last insert row id
 */
- (NSNumber *)lastInsertRowId;
- (NSNumber *)rowsChanged;

@end
