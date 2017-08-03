//
//  CTPersistanceMigration.m
//  CTPersistance
//
//  Created by casa on 2017/8/3.
//  Copyright © 2017年 casa. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TestTableVersion1.h"
#import "TestTableVersion2.h"
#import "TestTableVersion3.h"
#import "TestTableVersion4.h"

#import "CTPersistance.h"
#import "CTPersistanceDatabasePool.h"

NSString * const kCTPersistanceMigrationTestCaseVersionKey = @"kCTPersistanceMigrationTestCaseVersionKey";

@interface CTPersistanceTestMigration : XCTestCase

@end

@implementation CTPersistanceTestMigration

- (void)setUp
{
    [super setUp];

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCTPersistanceMigrationTestCaseVersionKey];

    CTPersistanceTable *testTable = [[TestTableVersion1 alloc] init];
    [testTable insertValue:@"test" forKey:@"version1" error:NULL];

    testTable = [[TestTableVersion2 alloc] init];
    [testTable insertValue:@"test" forKey:@"version1" error:NULL];

    testTable = [[TestTableVersion3 alloc] init];
    [testTable insertValue:@"test" forKey:@"version1" error:NULL];

    testTable = [[TestTableVersion4 alloc] init];
    [testTable insertValue:@"test" forKey:@"version1" error:NULL];

    [[CTPersistanceDatabasePool sharedInstance] closeAllDatabase];
}

- (void)tearDown
{
    [super tearDown];

    NSInteger version = 4;

    while (version --> 0) {
        [self removeDatabase:version+1];
    }

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCTPersistanceMigrationTestCaseVersionKey];
}

- (void)removeDatabase:(NSInteger)version
{
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"MigrationTestDatabase_version%ld.sqlite",(long)version]];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
}

- (void)testMiagration_1_to_2
{
    [[NSUserDefaults standardUserDefaults] setObject:@"TestMiagratorVersion_1_to_2" forKey:kCTPersistanceMigrationTestCaseVersionKey];
    CTPersistanceTable *testTable = [[TestTableVersion1 alloc] init];
    [testTable insertValue:@"test" forKey:@"version1" error:NULL];
    // This is an example of a functional test case.
}

- (void)testMiagration_1_to_3
{
    // This is an example of a functional test case.
}

- (void)testMiagration_1_to_4
{
    // This is an example of a functional test case.
}

- (void)testMiagration_2_to_3
{
    // This is an example of a functional test case.
}

- (void)testMiagration_2_to_4
{
    // This is an example of a functional test case.
}

- (void)testMiagration_3_to_4
{
    // This is an example of a functional test case.
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
