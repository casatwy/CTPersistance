//
//  CTPersistanceTable+Insert.m
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceTable+Insert.h"
#import "CTPersistanceQueryCommand.h"
#import "CTPersistanceQueryCommand+SchemaManipulations.h"
#import "CTPersistanceQueryCommand+ReadMethods.h"
#import "CTPersistanceQueryCommand+DataManipulations.h"
#import "CTPersistanceDatabasePool.h"
#import "objc/runtime.h"
#import <sqlite3.h>

@implementation CTPersistanceTable (Insert)

- (NSNumber *)insertRecordList:(NSArray<NSObject <CTPersistanceRecordProtocol> *> *)recordList error:(NSError *__autoreleasing *)error
{
    if (recordList == nil) {
        return @(0);
    }
    NSMutableArray *insertList = [[NSMutableArray alloc] init];
    [recordList enumerateObjectsUsingBlock:^(NSObject <CTPersistanceRecordProtocol> * _Nonnull record, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.child isCorrectToInsertRecord:record]) {
            [insertList addObject:[record dictionaryRepresentationWithColumnInfo:[self.child columnInfo] tableName:[self.child tableName]]];
        }
    }];
    
    return [[self.queryCommand insertTable:[self.child tableName] withDataList:insertList] executeWithError:error];
}

- (NSObject<CTPersistanceRecordProtocol> *)insertRecord:(NSObject <CTPersistanceRecordProtocol> *)record error:(NSError *__autoreleasing *)error
{
    if (record && [self.child isCorrectToInsertRecord:record]) {
        NSNumber *rowId = [[self.queryCommand insertTable:[self.child tableName] withDataList:@[[record dictionaryRepresentationWithColumnInfo:[self.child columnInfo] tableName:[self.child tableName]]]] executeWithError:error];
        [record setPersistanceValue:rowId forKey:[self.child primaryKeyName]];
    }
    return record;
}

@end
