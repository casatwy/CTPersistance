//
//  Target_MigrationTestDatabase_version1.m
//  CTPersistance
//
//  Created by casa on 2017/8/3.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "Target_MigrationTestDatabase_version1_sqlite.h"
#import <objc/runtime.h>

extern NSString * const kCTPersistanceMigrationTestCaseVersionKey;

@implementation Target_MigrationTestDatabase_version1_sqlite

- (CTPersistanceMigrator *)Action_fetchMigrator:(NSDictionary *)params
{
    NSString *migratorClassName = [[NSUserDefaults standardUserDefaults] stringForKey:kCTPersistanceMigrationTestCaseVersionKey];
    Class migratorClass = NSClassFromString(migratorClassName);
    return [[migratorClass alloc] init];
}

@end
