//
//  MigrationStep4_0.m
//  CTPersistance
//
//  Created by casa on 2016/12/5.
//  Copyright © 2016年 casa. All rights reserved.
//

#import "MigrationStep4_0.h"
#import "TestTable.h"

@implementation MigrationStep4_0

#pragma mark - CTPersistanceMigrationStep
- (void)goUpWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand error:(NSError *__autoreleasing *)error
{
    TestTable *table = [[TestTable alloc] initWithQueryCommand:queryCommand];
    [[queryCommand addColumn:@"migration4_0" columnInfo:@"TEXT" tableName:table.tableName] executeWithError:error];
}

- (void)goDownWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand error:(NSError *__autoreleasing *)error
{
    
}

@end
