//
//  CTPersistanceTestChangeKey.m
//  CTPersistanceTests
//
//  Created by casa on 2018/5/8.
//  Copyright © 2018年 casa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <sqlite3.h>
#import "CTPersistanceDataBase.h"
#import "CTPersistanceQueryCommand+SchemaManipulations.h"

extern SQLITE_API int sqlite3_key(sqlite3 *db, const void *pKey, int nKey);

@interface CTPersistanceTestChangeKey : XCTestCase

@property (nonatomic, unsafe_unretained) sqlite3 *database;
@property (nonatomic, strong) NSString *databaseFilePath;

@end

@implementation CTPersistanceTestChangeKey

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.databaseFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:self.databaseFilePath error:NULL];
    }
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    sqlite3_close_v2(_database);
    _database = NULL;
    _databaseFilePath = nil;
    [super tearDown];
}

- (void)testKey0ToKey4 {
    [self createDatabaseWithKey:@"0"];
    
    NSError *error = nil;
    CTPersistanceDataBase *database = [[CTPersistanceDataBase alloc] initWithDatabaseName:@"TestDatabase.sqlite" swiftModuleName:nil error:&error];
    [database closeDatabase];
    
    database = [[CTPersistanceDataBase alloc] initWithDatabaseName:@"TestDatabase.sqlite" swiftModuleName:nil error:&error];
    CTPersistanceQueryCommand *queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabase:database];
    NSArray *result = [[queryCommand showTablesWithError:&error] fetchWithError:&error];
    
    XCTAssertGreaterThan(result.count, 0);
    
    [database closeDatabase];
}

- (void)testKey1ToKey4 {
    [self createDatabaseWithKey:@"1"];
    
    NSError *error = nil;
    CTPersistanceDataBase *database = [[CTPersistanceDataBase alloc] initWithDatabaseName:@"TestDatabase.sqlite" swiftModuleName:nil error:&error];
    [database closeDatabase];
    
    database = [[CTPersistanceDataBase alloc] initWithDatabaseName:@"TestDatabase.sqlite" swiftModuleName:nil error:&error];
    CTPersistanceQueryCommand *queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabase:database];
    NSArray *result = [[queryCommand showTablesWithError:&error] fetchWithError:&error];
    
    XCTAssertGreaterThan(result.count, 0);
    
    [database closeDatabase];
}

- (void)testKey2ToKey4 {
    [self createDatabaseWithKey:@"2"];
    
    NSError *error = nil;
    CTPersistanceDataBase *database = [[CTPersistanceDataBase alloc] initWithDatabaseName:@"TestDatabase.sqlite" swiftModuleName:nil error:&error];
    [database closeDatabase];
    
    database = [[CTPersistanceDataBase alloc] initWithDatabaseName:@"TestDatabase.sqlite" swiftModuleName:nil error:&error];
    CTPersistanceQueryCommand *queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabase:database];
    NSArray *result = [[queryCommand showTablesWithError:&error] fetchWithError:&error];
    
    XCTAssertGreaterThan(result.count, 0);
    
    [database closeDatabase];
}

- (void)testKey3ToKey4 {
    [self createDatabaseWithKey:@"3"];
    
    NSError *error = nil;
    CTPersistanceDataBase *database = [[CTPersistanceDataBase alloc] initWithDatabaseName:@"TestDatabase.sqlite" swiftModuleName:nil error:&error];
    [database closeDatabase];
    
    database = [[CTPersistanceDataBase alloc] initWithDatabaseName:@"TestDatabase.sqlite" swiftModuleName:nil error:&error];
    CTPersistanceQueryCommand *queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabase:database];
    NSArray *result = [[queryCommand showTablesWithError:&error] fetchWithError:&error];
    
    XCTAssertGreaterThan(result.count, 0);
    
    [database closeDatabase];
}

- (void)testNewDatabase {
    NSError *error = nil;
    
    CTPersistanceDataBase *database = [[CTPersistanceDataBase alloc] initWithDatabaseName:@"TestDatabase.sqlite" swiftModuleName:nil error:&error];
    CTPersistanceQueryCommand *queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabase:database];
    NSArray *result = [[queryCommand showTablesWithError:&error] fetchWithError:&error];
    
    XCTAssertGreaterThan(result.count, 0);
}

#pragma mark - private methods
- (void)createDatabaseWithKey:(NSString *)key
{
    sqlite3 *database = NULL;
    const char *path = [self.databaseFilePath UTF8String];
    sqlite3_open_v2(path, &(database),
                    SQLITE_OPEN_CREATE |
                    SQLITE_OPEN_READWRITE |
                    SQLITE_OPEN_NOMUTEX |
                    SQLITE_OPEN_SHAREDCACHE,
                    NULL);
    sqlite3_key(database, [key UTF8String], (int)key.length);
    
    NSString *sqlString = @"CREATE TABLE IF NOT EXISTS `test` (`name` TEXT);";
    sqlite3_stmt *statement = nil;
    sqlite3_prepare_v2(database, [sqlString UTF8String], (int)sqlString.length, &statement, NULL);
    sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    sqlite3_close_v2(database);
    database = NULL;
}

#pragma mark - getters and setters
- (NSString *)databaseFilePath
{
    if (_databaseFilePath == nil) {
        _databaseFilePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"TestDatabase.sqlite"];
    }
    return _databaseFilePath;
}

@end
