//
//  TestMigration_NewCreate.m
//  CTPersistanceTests
//
//  Created by 吴明亮 on 2018/6/4.
//  Copyright © 2018 casa. All rights reserved.
//

#import "TestMigration_NewCreate.h"
#import "MigrationStep_2.h"

@implementation TestMigration_NewCreate

- (NSArray *)migrationVersionList
{
    return @[kCTPersistanceInitVersion, @"2"];
}

- (NSDictionary *)migrationStepDictionary
{
    return @{@"2":[MigrationStep_2 class]};
}

@end
