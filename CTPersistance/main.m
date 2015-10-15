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

int main(int argc, char * argv[]) {
//    TestInsertData *testInsertData = [[TestInsertData alloc] init];
//    [testInsertData test];
//    
//    TestFetchData *testFetchData = [[TestFetchData alloc] init];
//    [testFetchData test];
//    
//    TestUpdateData *testUpldateData = [[TestUpdateData alloc] init];
//    [testUpldateData test];
//    
//    TestDeleteData *testDeleteData = [[TestDeleteData alloc] init];
//    [testDeleteData test];
//    
//    TestCaseRecord *testCaseRecord = [[TestCaseRecord alloc] init];
//    [testCaseRecord test];
//    
//    TestCaseTransaction *transaction = [[TestCaseTransaction alloc] init];
//    [transaction test];
    
    TestCaseWhereCondition *whereCondition = [[TestCaseWhereCondition alloc] init];
    [whereCondition test];
}
