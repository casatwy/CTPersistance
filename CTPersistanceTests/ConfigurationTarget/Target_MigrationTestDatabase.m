//
//  Target_CTPersistanceConfiguration.m
//  CTPersistance
//
//  Created by casa on 2017/8/10.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "Target_MigrationTestDatabase.h"

extern NSString * const kCTPersistanceMigrationTestCaseVersionKey;

@implementation Target_MigrationTestDatabase

- (NSString *)Action_secretKey:(NSDictionary *)params
{
    return nil;
}

- (CTPersistanceMigrator *)Action_fetchMigrator:(NSDictionary *)params
{
    NSString *migratorClassName = [[NSUserDefaults standardUserDefaults] stringForKey:kCTPersistanceMigrationTestCaseVersionKey];
    if (migratorClassName == nil) {
        migratorClassName = @"TestMiagratorVersion_1_to_4";
    }
    Class migratorClass = NSClassFromString(migratorClassName);
    return [[migratorClass alloc] init];
}

@end
