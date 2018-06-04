//
//  CTPersistanceTestTableIndex.m
//  CTPersistanceTests
//
//  Created by casa on 2017/11/17.
//  Copyright © 2017年 casa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestTable.h"

@interface CTPersistanceTestTableIndex : XCTestCase

@property (nonatomic, strong) TestTable *testTable;

@end

@implementation CTPersistanceTestTableIndex

- (void)setUp {
    [super setUp];
    self.testTable = [[TestTable alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIndex {
    NSArray <NSDictionary *> *result = [self.testTable fetchWithSQL:@"SELECT * FROM sqlite_master WHERE type='index';" error:NULL];
    XCTAssertEqual([result count], 2);
}

@end
