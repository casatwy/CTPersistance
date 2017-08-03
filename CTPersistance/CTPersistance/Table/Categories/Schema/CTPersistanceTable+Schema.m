//
//  CTPersistanceTable+Schema.m
//  CTPersistance
//
//  Created by casa on 2017/8/3.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "CTPersistanceTable+Schema.h"
#import "CTPersistanceQueryCommand+SchemaManipulations.h"

@implementation CTPersistanceTable (Schema)

- (NSArray <NSDictionary *> *)columnInfoInDataBase
{
    CTPersistanceQueryCommand *queryCommand = self.queryCommand;
    if (self.isFromMigration == NO) {
        queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:[self.child databaseName]];
    }

    NSArray *columnInfo = [[queryCommand columnInfoWithTableName:self.child.tableName] fetchWithError:NULL];

    return columnInfo;
}

@end
