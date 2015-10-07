//
//  CTPersistanceQueryBuilder.h
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTPersistanceDataBase.h"

@interface CTPersistanceQueryCommand : NSObject

@property (nonatomic, strong, readonly) NSMutableString *sqlString;
@property (nonatomic, weak, readonly) CTPersistanceDataBase *database;

- (instancetype)initWithDatabaseName:(NSString *)databaseName;
- (instancetype)initWithDatabase:(CTPersistanceDataBase *)database;

- (CTPersistanceQueryCommand *)resetQueryCommand;

- (NSNumber *)executeWithError:(NSError **)error;
- (NSArray *)fetchWithError:(NSError **)error;
- (NSNumber *)countWithError:(NSError **)error;

@end
