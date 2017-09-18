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
#import "CTPersistanceQueryCommand+DataManipulations.h"
#import "CTPersistanceQueryCommand+Status.h"

#import "objc/runtime.h"
#import <sqlite3.h>

static NSString * const kCTPersistanceErrorUserinfoKeyErrorRecord = @"kCTPersistanceErrorUserinfoKeyErrorRecord";

@implementation CTPersistanceTable (Insert)

- (BOOL)insertRecordList:(NSArray<NSObject <CTPersistanceRecordProtocol> *> *)recordList error:(NSError *__autoreleasing *)error
{
    __block BOOL result = YES;
    [recordList enumerateObjectsUsingBlock:^(NSObject<CTPersistanceRecordProtocol> * _Nonnull record, NSUInteger idx, BOOL * _Nonnull stop) {
        result = [self insertRecord:record error:error];
        if (result == NO) {
            *stop = YES;
        }
    }];
    return result;
}

- (BOOL)insertRecord:(NSObject <CTPersistanceRecordProtocol> *)record error:(NSError *__autoreleasing *)error
{
    BOOL isSuccessed = YES;
    
    if (record) {
        if ([self.child isCorrectToInsertRecord:record]) {
            if ([[self.queryCommand insertTable:self.child.tableName columnInfo:self.child.columnInfo dataList:@[[record dictionaryRepresentationWithTable:self.child]] error:error] executeWithError:error]) {
                if ([[self.queryCommand rowsChanged] integerValue] > 0) {
                    [record setValue:[self.queryCommand lastInsertRowId] forKey:[self.child primaryKeyName]];
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

- (NSNumber *)insertValue:(id)value forKey:(NSString *)key error:(NSError *__autoreleasing *)error
{
    if (value == nil) {
        value = [NSNull null];
    }

    if (key == nil) {
        return nil;
    }
    
    BOOL result = [[self.queryCommand insertTable:self.child.tableName columnInfo:self.child.columnInfo dataList:@[@{key:value}] error:error] executeWithError:error];
    if (result) {
        return [self.queryCommand lastInsertRowId];
    } else {
        return nil;
    }
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
