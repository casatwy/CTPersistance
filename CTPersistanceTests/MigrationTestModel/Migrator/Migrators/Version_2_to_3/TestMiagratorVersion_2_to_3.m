//
//  TestMiagratorVersion_2_to_3.m
//  CTPersistance
//
//  Created by casa on 2017/8/3.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "TestMiagratorVersion_2_to_3.h"
#import "MigrationStep_3.h"

@implementation TestMiagratorVersion_2_to_3

- (NSArray *)migrationVersionList
{
    return @[
             kCTPersistanceInitVersion,
             @"3",
             @"4",
             ];
}

- (NSDictionary *)migrationStepDictionary
{
    return @{
             @"3":[MigrationStep_3 class],
             };
}

@end
