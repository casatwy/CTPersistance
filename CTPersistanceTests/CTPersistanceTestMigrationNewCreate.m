//
//  CTPersistanceTestMigrationNewCreate.m
//  CTPersistanceTests
//
//  Created by 吴明亮 on 2018/6/4.
//  Copyright © 2018 casa. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CTPersistance.h"
#import "CTPersistanceDatabasePool.h"
#import "TestNewRecordVersionTable.h"

@interface CTPersistanceTestMigrationNewCreate : XCTestCase

@end

@implementation CTPersistanceTestMigrationNewCreate

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNewCreate {
    TestNewRecordVersionTable *testTable = [[TestNewRecordVersionTable alloc] init];
}

@end
