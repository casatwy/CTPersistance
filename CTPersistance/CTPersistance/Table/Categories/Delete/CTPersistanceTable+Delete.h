//
//  CTPersistanceTable+Delete.h
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceTable.h"
#import "CTPersistanceRecord.h"
#import "CTPersistanceCriteria.h"

@interface CTPersistanceTable (Delete)

- (void)deleteRecord:(NSObject <CTPersistanceRecordProtocol> *)record error:(NSError **)error;
- (void)deleteRecordList:(NSArray <NSObject<CTPersistanceRecordProtocol> *> *)recordList error:(NSError **)error;
- (void)deleteWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams error:(NSError **)error;
- (void)deleteWithCriteria:(CTPersistanceCriteria *)criteria error:(NSError **)error;
- (void)deleteWithSql:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error;
- (void)deleteWithPrimaryKey:(NSNumber *)primaryKeyValue error:(NSError **)error;
- (void)deleteWithPrimaryKeyList:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error;

@end
