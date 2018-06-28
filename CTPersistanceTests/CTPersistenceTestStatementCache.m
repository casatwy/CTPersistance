//
//  CTPersistenceTestStatementCache.m
//  CTPersistanceTests
//
//  Created by zl on 2018/6/28.
//  Copyright © 2018年 casa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CTPersistance.h"

@interface CTPersistenceTestStatementCache : XCTestCase

@end

@implementation CTPersistenceTestStatementCache

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    
    CTPersistanceQueryCommand *queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:@"testStatementCache.sqlite"];
    NSString *tableName = @"test_statement_cache_t";
    
    NSString *deleteSqlString = [NSString stringWithFormat:@"delete from `%@`;",tableName];
    [[queryCommand compileSqlString:deleteSqlString bindValueList:nil error:NULL] executeWithError:NULL];
}

- (void)testStatementCache {
    CTPersistanceQueryCommand *queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:@"testStatementCache.sqlite"];
    NSDictionary *columnInfo =  @{@"book_id": @"INTEGER"};
    NSString *tableName = @"test_statement_cache_t";
    
    [[queryCommand createTable:tableName columnInfo:columnInfo error:NULL] executeWithError:NULL];
    
    NSDictionary *item0 = @{@"book_id" : @0};
    NSDictionary *item1 = @{@"book_id" : @1};
    NSDictionary *item2 = @{@"book_id" : @2};
    
    CTPersistanceSqlStatement *statement = [queryCommand insertTable:tableName columnInfo:columnInfo dataList:@[item0] error:NULL];
    [statement executeWithError:NULL];
    
    [[queryCommand insertTable:tableName columnInfo:columnInfo dataList:@[item1] error:NULL] executeWithError:NULL];
    [[queryCommand insertTable:tableName columnInfo:columnInfo dataList:@[item2] error:NULL] executeWithError:NULL];
    
    XCTAssertEqual([statement useCount], 3);
}

@end
