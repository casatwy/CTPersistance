//
//  Target_MigrationTestDatabaseNewCreate.m
//  CTPersistanceTests
//
//  Created by 吴明亮 on 2018/6/4.
//  Copyright © 2018 casa. All rights reserved.
//

#import "Target_MigrationTestDatabaseNewCreate.h"
#import "TestMigration_NewCreate.h"

@implementation Target_MigrationTestDatabaseNewCreate

- (CTPersistanceMigrator *)Action_fetchMigrator:(NSDictionary *)params {
    return [[TestMigration_NewCreate alloc] init];
}

@end
