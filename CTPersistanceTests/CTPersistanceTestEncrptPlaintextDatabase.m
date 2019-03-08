//
//  CTPersistanceTestEncrptPlaintextDatabase.m
//  CTPersistanceTests
//
//  Created by 周中广 on 2019/3/8.
//  Copyright © 2019 casa. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "EncryptPlaintextDatabaseTestTable.h"

NSString * const kCTPersistanceEncryptKey = @"kCTPersistanceEncryptKey";


@interface CTPersistanceTestEncrptPlaintextDatabase : XCTestCase

@end

@implementation CTPersistanceTestEncrptPlaintextDatabase

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    [self clean];
    [super tearDown];
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testEncryptPlaintextDatabase {
    // no encryption
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kCTPersistanceEncryptKey];
    
    // create a plaintext database and insert three record
    EncryptPlaintextDatabaseTestTable *insertTestTable = [[EncryptPlaintextDatabaseTestTable alloc] init];
    TestRecord *record = [[TestRecord alloc] init];
    record.name = @"casa";
    
    NSError *insertError;
    [insertTestTable insertRecord:record error:&insertError];
    
    XCTAssertNil(insertError);
    
    // close database
    [[CTPersistanceDatabasePool sharedInstance] closeAllDatabase];
    
    // open plaintext database and fetch record
    EncryptPlaintextDatabaseTestTable *fetchTable = [[EncryptPlaintextDatabaseTestTable alloc] init];
    
    NSError *findError;
    NSArray *array = [fetchTable findAllWithError:&findError];
    XCTAssertNil(findError);
    NSLog(@"%@", array);
    
    // close database
    [[CTPersistanceDatabasePool sharedInstance] closeAllDatabase];
    
    // start encrypt existing plaintext database
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kCTPersistanceEncryptKey];
    
    // convert plaintext database to encypted database and fetch record
    EncryptPlaintextDatabaseTestTable *encryptedFetchTable = [[EncryptPlaintextDatabaseTestTable alloc] init];
    
    NSError *encryptedFindError;
    NSArray *encryptedArray = [encryptedFetchTable findAllWithError:&findError];
    XCTAssertNil(encryptedFindError);
    NSLog(@"%@", encryptedArray);
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)clean {
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"EncryptPlaintextTestDataBase.sqlite"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSLog(@"dfjl");
    }
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
}

@end
