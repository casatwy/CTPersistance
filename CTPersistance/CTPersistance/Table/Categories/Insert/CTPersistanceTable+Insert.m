//
//  CTPersistanceTable+Insert.m
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceTable+Insert.h"
#import "CTPersistanceDatabasePool.h"
#import "CTPersistanceConfiguration.h"

#import "CTPersistanceQueryCommand.h"
#import "CTPersistanceQueryCommand+SchemaManipulations.h"
#import "CTPersistanceQueryCommand+ReadMethods.h"
#import "CTPersistanceQueryCommand+DataManipulations.h"
#import "CTPersistanceQueryCommand+Status.h"

#import "objc/runtime.h"
#import <sqlite3.h>
#import <UIKit/UIKit.h>

@implementation CTPersistanceTable (Insert)

- (BOOL)insertRecordList:(NSArray<NSObject <CTPersistanceRecordProtocol> *> *)recordList error:(NSError *__autoreleasing *)error
{
    __block BOOL isSuccess = YES;
    
    if (recordList == nil) {
        return isSuccess;
    }
    
    NSMutableArray *insertList = [[NSMutableArray alloc] init];
    __block NSUInteger errorRecordIndex = 0;
    [recordList enumerateObjectsUsingBlock:^(NSObject <CTPersistanceRecordProtocol> * _Nonnull record, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.child isCorrectToInsertRecord:record]) {
            [insertList addObject:[record dictionaryRepresentationWithTable:self.child]];
        } else {
            isSuccess = NO;
            errorRecordIndex = idx;
            *stop = YES;
        }
    }];
    
    if (isSuccess) {
        CTPersistanceQueryCommand *queryCommand = self.queryCommand;
        if (self.isFromMigration == NO) {
            queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:[self.child databaseName]];
        }
        if ([[queryCommand insertTable:[self.child tableName] withDataList:insertList] executeWithError:error]) {
            NSInteger changedRowsCount = [[queryCommand rowsChanged] integerValue];
            if (changedRowsCount != [insertList count]) {
                isSuccess = NO;
                if (error) {
                    *error = [NSError errorWithDomain:kCTPersistanceErrorDomain
                                                 code:CTPersistanceErrorCodeRecordNotAvailableToInsert
                                             userInfo:@{
                                                        NSLocalizedDescriptionKey:[NSString stringWithFormat:@"there is %lu records to save, but only %ld saved, you should check error", (unsigned long)[insertList count], (long)changedRowsCount],
                                                        kCTPersistanceErrorUserinfoKeyErrorRecord:insertList
                                                        }];
                }
            }
        } else {
            isSuccess = NO;
        }
    } else {
        if (error) {
            *error = [self errorWithRecord:recordList[errorRecordIndex]];
        }
    }
    
    return isSuccess;
}

- (BOOL)insertRecord:(NSObject <CTPersistanceRecordProtocol> *)record error:(NSError *__autoreleasing *)error
{
    BOOL isSuccessed = YES;
    
    if (record) {
        if ([self.child isCorrectToInsertRecord:record]) {
            CTPersistanceQueryCommand *queryCommand = self.queryCommand;
            if (self.isFromMigration == NO) {
                queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:[self.child databaseName]];
            }
            if ([[queryCommand insertTable:[self.child tableName] withDataList:@[[record dictionaryRepresentationWithTable:self.child]]] executeWithError:error]) {
                if ([[queryCommand rowsChanged] integerValue] > 0) {
                    if (![record setPersistanceValue:[queryCommand lastInsertRowId] forKey:[self.child primaryKeyName]]) {
                        isSuccessed = NO;
                        if (error) {
                            *error = [NSError errorWithDomain:kCTPersistanceErrorDomain
                                                         code:CTPersistanceErrorCodeFailedToSetKeyForValue
                                                     userInfo:@{
                                                                NSLocalizedDescriptionKey:[NSString stringWithFormat:@"failed to set value[%@] with key[%@] in record[%@]", [self.child primaryKeyName], [queryCommand lastInsertRowId], record]
                                                                }];
                        }
                    }
                } else {
                    isSuccessed = NO;
                    if (error) {
                        *error = [self errorWithRecord:record];
                    }
                }
            } else {
                isSuccessed = NO;
            }
        } else {
            isSuccessed = NO;
            if (error) {
                *error = [self errorWithRecord:record];
            }
        }
    }
    
    return isSuccessed;
}

- (NSError *)errorWithRecord:(NSObject <CTPersistanceRecordProtocol> *)record
{
    return [NSError errorWithDomain:kCTPersistanceErrorDomain
                               code:CTPersistanceErrorCodeRecordNotAvailableToInsert
                           userInfo:@{
                                      NSLocalizedDescriptionKey:[NSString stringWithFormat:@"\n\n%@\n is failed to pass validation, and can not insert", [record dictionaryRepresentationWithTable:self.child]],
                                      kCTPersistanceErrorUserinfoKeyErrorRecord:record
                                      }];
}

@end
