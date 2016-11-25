//
//  TestMigrator.m
//  CTPersistance
//
//  Created by casa on 15/10/7.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "TestMigrator.h"

#import "CTPersistanceConfiguration.h"
#import "MigrationStep1_0.h"
#import "MigrationStep2_0.h"

@implementation TestMigrator

#pragma mark - CTPersistanceMigratorProtocol
- (NSDictionary *)migrationStepDictionary
{
    return @{
             @"1.0":[MigrationStep1_0 class],
//             @"2.0":[MigrationStep2_0 class]
             };
}

- (NSArray *)migrationVersionList
{
//    return @[kCTPersistanceInitVersion];
    return @[kCTPersistanceInitVersion, @"1.0"];
//    return @[kCTPersistanceInitVersion, @"1.0", @"2.0"];
}

@end
