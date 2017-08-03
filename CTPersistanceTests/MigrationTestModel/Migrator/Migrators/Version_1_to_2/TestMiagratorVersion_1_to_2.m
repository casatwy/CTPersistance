//
//  TestMiagratorVersion_1_to_2.m
//  CTPersistance
//
//  Created by casa on 2017/8/3.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "TestMiagratorVersion_1_to_2.h"
#import "MigrationStep_2.h"

@implementation TestMiagratorVersion_1_to_2

- (NSArray *)migrationVersionList
{
    return @[kCTPersistanceInitVersion, @"2"];
}

- (NSDictionary *)migrationStepDictionary
{
    return @{@"2":[MigrationStep_2 class]};
}

@end
