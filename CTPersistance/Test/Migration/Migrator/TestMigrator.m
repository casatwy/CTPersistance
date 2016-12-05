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
#import "MigrationStep3_0.h"
#import "MigrationStep4_0.h"
#import "TestCaseMigration.h"

@implementation TestMigrator

#pragma mark - CTPersistanceMigratorProtocol
- (NSDictionary *)migrationStepDictionary
{
    NSDictionary *result = @{};
    
    if ([TestCaseMigration sharedInstance].currentVersion == 1) {
        result = @{@"1.0":[MigrationStep1_0 class]};
    }
    
    if ([TestCaseMigration sharedInstance].currentVersion == 2) {
        result = @{
                   @"1.0":[MigrationStep1_0 class],
                   @"2.0":[MigrationStep2_0 class],
                   };
    }
    
    if ([TestCaseMigration sharedInstance].currentVersion == 3) {
        result = @{
                   @"1.0":[MigrationStep1_0 class],
                   @"2.0":[MigrationStep2_0 class],
                   @"3.0":[MigrationStep3_0 class],
                   };
    }
    
    if ([TestCaseMigration sharedInstance].currentVersion == 4) {
        result = @{
                   @"1.0":[MigrationStep1_0 class],
                   @"2.0":[MigrationStep2_0 class],
                   @"3.0":[MigrationStep3_0 class],
                   @"4.0":[MigrationStep4_0 class],
                   };
    }
    return result;
}

- (NSArray *)migrationVersionList
{
    NSArray *result = @[kCTPersistanceInitVersion];

    if ([TestCaseMigration sharedInstance].currentVersion == 1) {
        result = @[kCTPersistanceInitVersion, @"1.0"];
    }

    if ([TestCaseMigration sharedInstance].currentVersion == 2) {
        result = @[kCTPersistanceInitVersion, @"1.0", @"2.0"];
    }

    if ([TestCaseMigration sharedInstance].currentVersion == 3) {
        result = @[kCTPersistanceInitVersion, @"1.0", @"2.0", @"3.0"];
    }

    if ([TestCaseMigration sharedInstance].currentVersion == 4) {
        result = @[kCTPersistanceInitVersion, @"1.0", @"2.0", @"3.0", @"4.0"];
    }

    return result;
}

@end
