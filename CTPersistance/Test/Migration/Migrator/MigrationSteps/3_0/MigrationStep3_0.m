//
//  MigrationStep3_0.m
//  CTPersistance
//
//  Created by casa on 2016/12/5.
//  Copyright © 2016年 casa. All rights reserved.
//

#import "MigrationStep3_0.h"
#import "TestTable.h"

@implementation MigrationStep3_0

#pragma mark - CTPersistanceMigrationStep
- (void)goUpWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand error:(NSError *__autoreleasing *)error
{
    TestTable *table = [[TestTable alloc] initWithQueryCommand:queryCommand];
    [[queryCommand addColumn:@"migration3_0" columnInfo:@"TEXT" tableName:table.tableName] executeWithError:error];
}

- (void)goDownWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand error:(NSError *__autoreleasing *)error
{
    
}

@end
