//
//  CTPersistanceTable+Find.h
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceTable.h"
#import "CTPersistanceRecord.h"
#import "CTPersistanceCriteria.h"

@interface CTPersistanceTable (Find)

- (NSObject <CTPersistanceRecordProtocol> *)findLatestRecordWithError:(NSError **)error;

- (NSArray <NSObject <CTPersistanceRecordProtocol> *> *)findAllWithWhereCondition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams isDistinct:(BOOL)isDistinct error:(NSError **)error;
- (NSArray <NSObject <CTPersistanceRecordProtocol> *> *)findAllWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error;
- (NSArray <NSObject <CTPersistanceRecordProtocol> *> *)findAllWithCriteria:(CTPersistanceCriteria *)criteria error:(NSError **)error;

- (NSObject <CTPersistanceRecordProtocol> *)findFirstRowWithWhereCondition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams isDistinct:(BOOL)isDistinct error:(NSError **)error;
- (NSObject <CTPersistanceRecordProtocol> *)findFirstRowWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error;
- (NSObject <CTPersistanceRecordProtocol> *)findFirstRowWithCriteria:(CTPersistanceCriteria *)criteria error:(NSError **)error;

- (NSNumber *)countWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams isDistinct:(BOOL)isDistinct error:(NSError **)error;
- (NSNumber *)countWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error;
- (NSNumber *)countWithCriteria:(CTPersistanceCriteria *)criteria error:(NSError **)error;

- (NSObject <CTPersistanceRecordProtocol> *)findWithPrimaryKey:(NSNumber *)primaryKeyValue error:(NSError **)error;
- (NSArray <NSObject <CTPersistanceRecordProtocol> *> *)findAllWithPrimaryKey:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error;


@end