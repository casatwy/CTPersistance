//
//  CTPersistanceTable+Upsert.m
//  CTPersistance
//
//  Created by casa on 2018/5/17.
//  Copyright © 2018年 casa. All rights reserved.
//

#import "CTPersistanceTable+Upsert.h"
#import "CTPersistanceTable+Update.h"
#import "CTPersistanceTable+Insert.h"
#import "CTPersistanceQueryCommand+Status.h"
#import "CTPersistanceTransaction.h"
#import "CTPersistanceConfiguration.h"

@implementation CTPersistanceTable (Upsert)

- (void)upsertRecord:(NSObject<CTPersistanceRecordProtocol> *)record uniqKeyName:(NSString *)uniqKeyName error:(NSError *__autoreleasing *)error
{
    if (record == nil) {
        NSError *generatedError = [NSError errorWithDomain:kCTPersistanceErrorDomain
                                                      code:CTPersistanceErrorCodeQueryStringError
                                                  userInfo:@{
                                                             NSLocalizedDescriptionKey:@"calling [- (void)upsertRecord:uniqKeyName:error:]:\nthe record is nil"
                                                             }];
        *error = generatedError;
        return;
    }
    
    if (uniqKeyName == nil) {
        NSError *generatedError = [NSError errorWithDomain:kCTPersistanceErrorDomain
                                                      code:CTPersistanceErrorCodeQueryStringError
                                                  userInfo:@{
                                                             NSLocalizedDescriptionKey:@"calling [- (void)upsertRecord:uniqKeyName:error:]:\nthe uniqKeyName is nil"
                                                             }];
        *error = generatedError;
        return;
    }
    
    if ([record valueForKey:uniqKeyName] == nil) {
        NSError *generatedError = [NSError errorWithDomain:kCTPersistanceErrorDomain
                                                      code:CTPersistanceErrorCodeQueryStringError
                                                  userInfo:@{
                                                             NSLocalizedDescriptionKey:[NSString stringWithFormat:@"calling [- (void)upsertRecord:uniqKeyName:error:]:\nthe [%@] of record is nil; the record is:\n%@", uniqKeyName, [record dictionaryRepresentationWithTable:self.child]]
                                                             }];
        *error = generatedError;
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [CTPersistanceTransaction performTranscationWithBlock:^(BOOL *shouldRollback) {
        NSString *whereCondition = [NSString stringWithFormat:@"%@ = :%@", uniqKeyName, uniqKeyName];
        
        NSString *key = [NSString stringWithFormat:@":%@", uniqKeyName];
        NSMutableDictionary *conditionParams = [[NSMutableDictionary alloc] init];
        conditionParams[key] = [record valueForKey:uniqKeyName];
        
        [weakSelf updateKeyValueList:[record dictionaryRepresentationWithTable:weakSelf.child]
                      whereCondition:whereCondition
                whereConditionParams:conditionParams
                               error:error];
        
        if (weakSelf.queryCommand.rowsChanged.integerValue == 0) {
            if ([record valueForKey:weakSelf.child.primaryKeyName] == nil) {
                [weakSelf insertRecord:record error:error];
            } else {
                [weakSelf updateKeyValueList:[record dictionaryRepresentationWithTable:weakSelf.child]
                             primaryKeyValue:[record valueForKey:weakSelf.child.primaryKeyName]
                                       error:error];
            }
        }
        
        *shouldRollback = NO;
    } queryCommand:self.queryCommand lockType:CTPersistanceTransactionLockTypeDefault];
}

@end
