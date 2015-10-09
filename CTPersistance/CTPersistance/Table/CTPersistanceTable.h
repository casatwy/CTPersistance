//
//  CTPersistanceModel.h
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTPersistanceRecord.h"

@class CTPersistanceQueryCommand;

/**
 *  the protocol which every table should confirm.
 */
@protocol CTPersistanceTableProtocol <NSObject>
@required
- (NSString *)databaseName;
- (NSString *)tableName;
- (NSDictionary *)columnInfo;
- (Class)recordClass;
- (NSString *)primaryKeyName;

@optional
- (void)modifyDatabaseName:(NSString *)newDatabaseName;

@optional
- (BOOL)isCorrectToInsertRecord:(NSObject <CTPersistanceRecordProtocol> *)record;
- (BOOL)isCorrectToUpdateRecord:(NSObject <CTPersistanceRecordProtocol> *)record;
@end

@interface CTPersistanceTable : NSObject

- (instancetype)initWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand;

@property (nonatomic, weak, readonly) id<CTPersistanceTableProtocol> child;
@property (nonatomic, strong, readonly) CTPersistanceQueryCommand *queryCommand;

@end
