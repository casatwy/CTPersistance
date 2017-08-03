//
//  CTPersistanceTable+Schema.m
//  CTPersistance
//
//  Created by casa on 2017/8/3.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "CTPersistanceTable+Schema.h"
#import "CTPersistanceQueryCommand+ReadMethods.h"

@implementation CTPersistanceTable (Schema)

- (NSArray <NSDictionary *> *)columnInfoInDataBase
{
    CTPersistanceQueryCommand *queryCommand = self.queryCommand;
    if (self.isFromMigration == NO) {
        queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:[self.child databaseName]];
    }

    NSString *sqlString = [NSString stringWithFormat:@"PRAGMA table_info(`%@`);", self.child.tableName];
    NSArray *columnInfo = [[queryCommand readWithSQL:sqlString bindValueList:nil error:NULL] fetchWithError:NULL];

    return columnInfo;
}

@end
