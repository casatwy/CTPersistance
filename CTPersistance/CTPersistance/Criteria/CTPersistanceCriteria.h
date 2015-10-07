//
//  CTPersistanceCriteria.h
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTPersistanceQueryCommand.h"

@interface CTPersistanceCriteria : NSObject

@property (nonatomic, copy) NSString *select;
@property (nonatomic, copy) NSString *whereCondition;
@property (nonatomic, copy) NSDictionary *whereConditionParams;
@property (nonatomic, copy) NSString *orderBy;
@property (nonatomic, assign) BOOL isDESC;
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) BOOL isDistinct;

- (CTPersistanceQueryCommand *)applyToSelectQueryCommand:(CTPersistanceQueryCommand *)queryCommand tableName:(NSString *)tableName;
- (CTPersistanceQueryCommand *)applyToDeleteQueryCommand:(CTPersistanceQueryCommand *)queryCommand tableName:(NSString *)tableName;

@end
