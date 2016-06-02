//
//  MigrationStep1_0.m
//  CTPersistance
//
//  Created by casa on 15/10/7.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "MigrationStep1_0.h"
#import "CTPersistanceTable+Find.h"

#import "TestTable.h"

@implementation MigrationStep1_0

- (void)goUpWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand error:(NSError *__autoreleasing *)error
{
    TestTable *testTable = [[TestTable alloc] initWithQueryCommand:queryCommand];
    [[queryCommand addColumn:@"migration1_0" columnInfo:@"TEXT" tableName:testTable.tableName] executeWithError:error];
    [testTable findWithPrimaryKey:@(1) error:NULL];
}

- (void)goDownWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand error:(NSError *__autoreleasing *)error
{
    
}

@end
