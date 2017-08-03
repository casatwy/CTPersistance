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
    [self prepare];
}

- (void)tearDown
{
    [super tearDown];
    [self clean];
}

- (void)prepare
{
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

- (void)clean
{
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
    [self prepare];

    [[NSUserDefaults standardUserDefaults] setObject:@"TestMiagratorVersion_1_to_2" forKey:kCTPersistanceMigrationTestCaseVersionKey];
    CTPersistanceTable *testTable = [[TestTableVersion1 alloc] init];
    NSArray <NSDictionary *> *columnInfo = [testTable columnInfoInDataBase];

    __block BOOL founded = NO;
    [columnInfo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull info, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([info[@"name"] isEqualToString:@"version2"]) {
            founded = YES;
            *stop = YES;
        }
    }];

    XCTAssertTrue(founded);
    XCTAssertEqual(columnInfo.count, 3);

    [self clean];
}

- (void)testMiagration_1_to_3
{
    [self prepare];

    [[NSUserDefaults standardUserDefaults] setObject:@"TestMiagratorVersion_1_to_3" forKey:kCTPersistanceMigrationTestCaseVersionKey];
    CTPersistanceTable *testTable = [[TestTableVersion1 alloc] init];
    NSArray <NSDictionary *> *columnInfo = [testTable columnInfoInDataBase];

    __block BOOL founded = NO;
    [columnInfo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull info, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([info[@"name"] isEqualToString:@"version3"]) {
            founded = YES;
            *stop = YES;
        }
    }];

    XCTAssertTrue(founded);
    XCTAssertEqual(columnInfo.count, 4);

    [self clean];
}

- (void)testMiagration_1_to_4
{
    [self prepare];

    [[NSUserDefaults standardUserDefaults] setObject:@"TestMiagratorVersion_1_to_4" forKey:kCTPersistanceMigrationTestCaseVersionKey];
    CTPersistanceTable *testTable = [[TestTableVersion1 alloc] init];
    NSArray <NSDictionary *> *columnInfo = [testTable columnInfoInDataBase];

    __block BOOL founded = NO;
    [columnInfo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull info, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([info[@"name"] isEqualToString:@"version4"]) {
            founded = YES;
            *stop = YES;
        }
    }];

    XCTAssertTrue(founded);
    XCTAssertEqual(columnInfo.count, 5);

    [self clean];
}

- (void)testMiagration_2_to_3
{
    [self prepare];

    [[NSUserDefaults standardUserDefaults] setObject:@"TestMiagratorVersion_2_to_3" forKey:kCTPersistanceMigrationTestCaseVersionKey];
    CTPersistanceTable *testTable = [[TestTableVersion2 alloc] init];
    NSArray <NSDictionary *> *columnInfo = [testTable columnInfoInDataBase];

    __block BOOL founded = NO;
    [columnInfo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull info, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([info[@"name"] isEqualToString:@"version3"]) {
            founded = YES;
            *stop = YES;
        }
    }];

    XCTAssertTrue(founded);
    XCTAssertEqual(columnInfo.count, 4);

    [self clean];
}

- (void)testMiagration_2_to_4
{
    [self prepare];

    [[NSUserDefaults standardUserDefaults] setObject:@"TestMiagratorVersion_2_to_4" forKey:kCTPersistanceMigrationTestCaseVersionKey];
    CTPersistanceTable *testTable = [[TestTableVersion2 alloc] init];
    NSArray <NSDictionary *> *columnInfo = [testTable columnInfoInDataBase];

    __block BOOL founded = NO;
    [columnInfo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull info, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([info[@"name"] isEqualToString:@"version4"]) {
            founded = YES;
            *stop = YES;
        }
    }];

    XCTAssertTrue(founded);
    XCTAssertEqual(columnInfo.count, 5);

    [self clean];
}

- (void)testMiagration_3_to_4
{
    [self prepare];

    [[NSUserDefaults standardUserDefaults] setObject:@"TestMiagratorVersion_3_to_4" forKey:kCTPersistanceMigrationTestCaseVersionKey];
    CTPersistanceTable *testTable = [[TestTableVersion3 alloc] init];
    NSArray <NSDictionary *> *columnInfo = [testTable columnInfoInDataBase];

    __block BOOL founded = NO;
    [columnInfo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull info, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([info[@"name"] isEqualToString:@"version4"]) {
            founded = YES;
            *stop = YES;
        }
    }];

    XCTAssertTrue(founded);
    XCTAssertEqual(columnInfo.count, 5);

    [self clean];
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
