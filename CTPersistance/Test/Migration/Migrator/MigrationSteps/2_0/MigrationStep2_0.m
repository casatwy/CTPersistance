//
//  MigrationStep2_0.m
//  CTPersistance
//
//  Created by casa on 15/10/7.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "MigrationStep2_0.h"
#import "TestTable.h"

@implementation MigrationStep2_0

- (void)goUpWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand error:(NSError *__autoreleasing *)error
{
    TestTable *table = [[TestTable alloc] initWithQueryCommand:queryCommand];
    [[queryCommand addColumn:@"migration2_0" columnInfo:@"TEXT" tableName:table.tableName] executeWithError:error];
}

- (void)goDownWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand error:(NSError *__autoreleasing *)error
{
    
}

@end
