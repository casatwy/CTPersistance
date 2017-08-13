//
//  Target_CTPersistanceConfiguration.m
//  CTPersistance
//
//  Created by casa on 2017/8/10.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "Target_CTPersistanceConfiguration.h"

extern NSString * const kCTPersistanceMigrationTestCaseVersionKey;

@implementation Target_CTPersistanceConfiguration

- (NSString *)Action_secretKey:(NSDictionary *)params
{
    return nil;
}

- (CTPersistanceMigrator *)Action_fetchMigrator:(NSDictionary *)params
{
    NSString *migratorClassName = [[NSUserDefaults standardUserDefaults] stringForKey:kCTPersistanceMigrationTestCaseVersionKey];
    Class migratorClass = NSClassFromString(migratorClassName);
    return [[migratorClass alloc] init];
}

@end
