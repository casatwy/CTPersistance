//
//  main.m
//  CTPersistance
//
//  Created by casa on 15/10/3.
//  Copyright © 2015年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TestInsertData.h"
#import "TestFetchData.h"
#import "TestDeleteData.h"
#import "TestUpdateData.h"
#import "TestCaseRecord.h"
#import "TestCaseTransaction.h"
#import "TestCaseWhereCondition.h"
#import "TestCaseAsync.h"
#import "TestCaseMigration.h"

int main(int argc, char * argv[]) {
    
    TestInsertData *testInsertData = [[TestInsertData alloc] init];
    [testInsertData test];
    
    TestFetchData *testFetchData = [[TestFetchData alloc] init];
    [testFetchData test];
    
    TestUpdateData *testUpldateData = [[TestUpdateData alloc] init];
    [testUpldateData test];
    
    TestDeleteData *testDeleteData = [[TestDeleteData alloc] init];
    [testDeleteData test];
    
    TestCaseRecord *testCaseRecord = [[TestCaseRecord alloc] init];
    [testCaseRecord test];
    
    TestCaseTransaction *transaction = [[TestCaseTransaction alloc] init];
    [transaction test];
    
    TestCaseWhereCondition *whereCondition = [[TestCaseWhereCondition alloc] init];
    [whereCondition test];
    
    TestCaseAsync *async = [[TestCaseAsync alloc] init];
    [async test];
    
    TestCaseMigration *migration = [TestCaseMigration sharedInstance];
    [migration testMigrateFromNoneDataBase];
    [migration testMigrateFromVersionOriginToVersion4];
    [migration testMigrateFromVersion1ToVersion2];
    [migration testMigrateFromVersion1ToVersion3];
    [migration testMigrateFromVersion1ToVersion4];
    [migration testMigrateFromVersion2ToVersion3];
    [migration testMigrateFromVersion2ToVersion4];
    [migration testMigrateFromVersion3ToVersion4];
    [migration testMigrateFromVersion4ToVersion4];
}
