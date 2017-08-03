//
//  TestMiagratorVersion_1_to_3.m
//  CTPersistance
//
//  Created by casa on 2017/8/3.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "TestMiagratorVersion_1_to_3.h"
#import "MigrationStep_2.h"
#import "MigrationStep_3.h"

@implementation TestMiagratorVersion_1_to_3

- (NSArray *)migrationVersionList
{
    return @[kCTPersistanceInitVersion, @"2", @"3"];
}

- (NSDictionary *)migrationStepDictionary
{
    return @{
             @"2":[MigrationStep_2 class],
             @"3":[MigrationStep_3 class]
             };
}

@end
