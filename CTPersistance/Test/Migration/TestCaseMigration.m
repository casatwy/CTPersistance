//
//  TestMigration.m
//  CTPersistance
//
//  Created by casa on 2016/12/5.
//  Copyright © 2016年 casa. All rights reserved.
//

#import "TestCaseMigration.h"
#import "TestTable.h"
#import "CTPersistanceDatabasePool.h"

@implementation TestCaseMigration

+ (instancetype)sharedInstance
{
    static TestCaseMigration *migration = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        migration = [[TestCaseMigration alloc] init];
    });
    return migration;
}

- (void)testMigrateFromNoneDataBase
{
    [self clean];
    [self prepareForNoneDataBase];
    TestTable *table = [[TestTable alloc] init];
    NSError *error = nil;
    NSString *sql = [NSString stringWithFormat:@"PRAGMA table_info(%@);", table.tableName];
    NSArray *result = [table fetchWithSQL:sql error:&error];
    if (result.count != 4) {
        @throw [[NSException alloc] init];
    }
    [self clean];
}

- (void)testMigrateFromVersion1ToVersion2
{
    [self clean];
    [self prepareFor1To2];
    TestTable *table = [[TestTable alloc] init];
    NSError *error = nil;
    NSString *sql = [NSString stringWithFormat:@"PRAGMA table_info(%@);", table.tableName];
    NSArray *result = [table fetchWithSQL:sql error:&error];
    if (result.count != 5) {
        @throw [[NSException alloc] init];
    }
    [self clean];
}

- (void)testMigrateFromVersion1ToVersion3
{
    [self clean];
    [self prepareFor1To3];
    TestTable *table = [[TestTable alloc] init];
    NSError *error = nil;
    NSString *sql = [NSString stringWithFormat:@"PRAGMA table_info(%@);", table.tableName];
    NSArray *result = [table fetchWithSQL:sql error:&error];
    if (result.count != 6) {
        @throw [[NSException alloc] init];
    }
    [self clean];
}

- (void)testMigrateFromVersion1ToVersion4
{
    [self clean];
    [self prepareFor1To4];
    TestTable *table = [[TestTable alloc] init];
    NSError *error = nil;
    NSString *sql = [NSString stringWithFormat:@"PRAGMA table_info(%@);", table.tableName];
    NSArray *result = [table fetchWithSQL:sql error:&error];
    if (result.count != 7) {
        @throw [[NSException alloc] init];
    }
    [self clean];
}

- (void)testMigrateFromVersion2ToVersion3
{
    [self clean];
    [self prepareFor2To3];
    TestTable *table = [[TestTable alloc] init];
    NSError *error = nil;
    NSString *sql = [NSString stringWithFormat:@"PRAGMA table_info(%@);", table.tableName];
    NSArray *result = [table fetchWithSQL:sql error:&error];
    if (result.count != 5) {
        @throw [[NSException alloc] init];
    }
    [self clean];
}

- (void)testMigrateFromVersion2ToVersion4
{
    [self clean];
    [self prepareFor2To4];
    TestTable *table = [[TestTable alloc] init];
    NSError *error = nil;
    NSString *sql = [NSString stringWithFormat:@"PRAGMA table_info(%@);", table.tableName];
    NSArray *result = [table fetchWithSQL:sql error:&error];
    if (result.count != 6) {
        @throw [[NSException alloc] init];
    }
    [self clean];
}

- (void)testMigrateFromVersion3ToVersion4
{
    [self clean];
    [self prepareFor3To4];
    TestTable *table = [[TestTable alloc] init];
    NSError *error = nil;
    NSString *sql = [NSString stringWithFormat:@"PRAGMA table_info(%@);", table.tableName];
    NSArray *result = [table fetchWithSQL:sql error:&error];
    if (result.count != 5) {
        @throw [[NSException alloc] init];
    }
    [self clean];
}

- (void)testMigrateFromVersion4ToVersion4
{
    [self clean];
    [self prepareFor4To4];
    TestTable *table = [[TestTable alloc] init];
    NSError *error = nil;
    NSString *sql = [NSString stringWithFormat:@"PRAGMA table_info(%@);", table.tableName];
    NSArray *result = [table fetchWithSQL:sql error:&error];
    if (result.count != 4) {
        @throw [[NSException alloc] init];
    }
    [self clean];
}

#pragma mark - private methods
- (void)clean
{
    [[CTPersistanceDatabasePool sharedInstance] closeAllDatabase];
    NSString *databaseFilePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"testdatabase.sqlite"];
    NSError *error = NULL;
    if ([[NSFileManager defaultManager] fileExistsAtPath:databaseFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:databaseFilePath error:&error];
    }
    if (error) {
        NSLog(@"error is %@", error);
        @throw [[NSException alloc] init];
    }
}

- (void)prepareForNoneDataBase
{
    [self clean];
}

- (void)prepareFor1To2
{
    self.currentVersion = 2;
    NSString *originFilePath = [[NSBundle mainBundle] pathForResource:@"testdatabase_1" ofType:@"sqlite"];
    NSString *targetFilePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"testdatabase.sqlite"];
    NSError *error = nil;
    [[NSFileManager defaultManager] copyItemAtPath:originFilePath toPath:targetFilePath error:&error];
    if (error) {
        NSLog(@"error is %@", error);
        @throw [[NSException alloc] init];
    }
}

- (void)prepareFor1To3
{
    self.currentVersion = 3;
    NSString *originFilePath = [[NSBundle mainBundle] pathForResource:@"testdatabase_1" ofType:@"sqlite"];
    NSString *targetFilePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"testdatabase.sqlite"];
    NSError *error = nil;
    [[NSFileManager defaultManager] copyItemAtPath:originFilePath toPath:targetFilePath error:&error];
    if (error) {
        NSLog(@"error is %@", error);
        @throw [[NSException alloc] init];
    }
}

- (void)prepareFor1To4
{
    self.currentVersion = 4;
    NSString *originFilePath = [[NSBundle mainBundle] pathForResource:@"testdatabase_1" ofType:@"sqlite"];
    NSString *targetFilePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"testdatabase.sqlite"];
    NSError *error = nil;
    [[NSFileManager defaultManager] copyItemAtPath:originFilePath toPath:targetFilePath error:&error];
    if (error) {
        NSLog(@"error is %@", error);
        @throw [[NSException alloc] init];
    }
}

- (void)prepareFor2To3
{
    self.currentVersion = 3;
    NSString *originFilePath = [[NSBundle mainBundle] pathForResource:@"testdatabase_2" ofType:@"sqlite"];
    NSString *targetFilePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"testdatabase.sqlite"];
    NSError *error = nil;
    [[NSFileManager defaultManager] copyItemAtPath:originFilePath toPath:targetFilePath error:&error];
    if (error) {
        NSLog(@"error is %@", error);
        @throw [[NSException alloc] init];
    }
}

- (void)prepareFor2To4
{
    self.currentVersion = 4;
    NSString *originFilePath = [[NSBundle mainBundle] pathForResource:@"testdatabase_2" ofType:@"sqlite"];
    NSString *targetFilePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"testdatabase.sqlite"];
    NSError *error = nil;
    [[NSFileManager defaultManager] copyItemAtPath:originFilePath toPath:targetFilePath error:&error];
    if (error) {
        NSLog(@"error is %@", error);
        @throw [[NSException alloc] init];
    }
}

- (void)prepareFor3To4
{
    self.currentVersion = 4;
    NSString *originFilePath = [[NSBundle mainBundle] pathForResource:@"testdatabase_3" ofType:@"sqlite"];
    NSString *targetFilePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"testdatabase.sqlite"];
    NSError *error = nil;
    [[NSFileManager defaultManager] copyItemAtPath:originFilePath toPath:targetFilePath error:&error];
    if (error) {
        NSLog(@"error is %@", error);
        @throw [[NSException alloc] init];
    }
}

- (void)prepareFor4To4
{
    self.currentVersion = 4;
    NSString *originFilePath = [[NSBundle mainBundle] pathForResource:@"testdatabase_4" ofType:@"sqlite"];
    NSString *targetFilePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"testdatabase.sqlite"];
    NSError *error = nil;
    [[NSFileManager defaultManager] copyItemAtPath:originFilePath toPath:targetFilePath error:&error];
    if (error) {
        NSLog(@"error is %@", error);
        @throw [[NSException alloc] init];
    }
}

@end
