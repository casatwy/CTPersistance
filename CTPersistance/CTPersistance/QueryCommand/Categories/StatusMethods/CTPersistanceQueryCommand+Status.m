//
//  CTPersistanceQueryCommand+Status.m
//  CTPersistance
//
//  Created by casa on 15/10/12.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceQueryCommand+Status.h"
#import "sqlite3.h"

@implementation CTPersistanceQueryCommand (Status)

- (NSNumber *)lastInsertRowId
{
    return @(sqlite3_last_insert_rowid(self.database.database));
}

- (NSNumber *)rowsChanged
{
    return @(sqlite3_changes(self.database.database));
}

@end
