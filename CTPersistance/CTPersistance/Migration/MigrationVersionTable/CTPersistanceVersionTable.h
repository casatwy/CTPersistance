//
//  CTPersistanceTableVersion.h
//  CTPersistance
//
//  Created by casa on 15/10/7.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceTable.h"
#import "CTPersistanceDataBase.h"

/**
 *  the version table used for migration. you should never use or create or extend this class.
 */
@interface CTPersistanceVersionTable : CTPersistanceTable <CTPersistanceTableProtocol>

/**
 *  the version table for Migration, you should never use or create this table.
 *
 *  @param database CTPersistanceDataBase instance
 *
 *  @return return CTPersistanceVersionTable
 *
 *  @warning You should never use or create this table.
 *
 */
- (instancetype)initWithDatabase:(CTPersistanceDataBase *)database;

+ (NSString *)tableName;
+ (NSDictionary *)columnInfo;
+ (NSString *)primaryKeyName;
+ (Class)recordClass;

@end
