//
//  Target_MigrationTestDatabase_version2.m
//  CTPersistance
//
//  Created by casa on 2017/8/3.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "Target_MigrationTestDatabase_version2.h"

extern NSString * const kCTPersistanceMigrationTestCaseVersionKey;

@implementation Target_MigrationTestDatabase_version2

- (CTPersistanceMigrator *)Action_fetchMigrator:(NSDictionary *)params
{
    NSString *migratorClassName = [[NSUserDefaults standardUserDefaults] stringForKey:kCTPersistanceMigrationTestCaseVersionKey];
    Class migratorClass = NSClassFromString(migratorClassName);
    return [[migratorClass alloc] init];
}

@end
