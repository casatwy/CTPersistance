//
//  CTPersistanceQueryCommand+DataManipulations.h
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceQueryCommand.h"

@interface CTPersistanceQueryCommand (DataManipulations)

/**
 *  insert table with table name and data list
 *
 *  You should never use this method directly, use insert methods in CTPersistanceTable instead
 *
 *  @param tableName table name
 *  @param dataList  data list to insert
 *
 *  @return return CTPersistanceQueryCommand
 *
 *  @warning You should never use this method directly, use insert methods in CTPersistanceTable instead
 *
 */
- (CTPersistanceQueryCommand *)insertTable:(NSString *)tableName withDataList:(NSArray *)dataList;

/**
 *  update table with data and condition with condition params.
 *
 *  You should never use this method directly, use update methods in CTPersistanceTable instead
 *
 *  @param tableName       table name
 *  @param data            data list to update
 *  @param condition       conditon
 *  @param conditionParams params for condition
 *
 *  @return return CTPersistanceQueryCommand
 *
 *  @warning You should never use this method directly, use insert methods in CTPersistanceTable instead
 *
 */
- (CTPersistanceQueryCommand *)updateTable:(NSString *)tableName withData:(NSDictionary *)data condition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams;

/**
 *  delete table with table name and condition with conditition params
 *
 *  You should never use this method directly, use update methods in CTPersistanceTable instead
 *
 *  @param tableName       table name
 *  @param condition       conditon
 *  @param conditionParams params for condition
 *
 *  @return return CTPersistanceQueryCommand
 *
 *  @warning You should never use this method directly, use insert methods in CTPersistanceTable instead
 *
 */
- (CTPersistanceQueryCommand *)deleteTable:(NSString *)tableName withCondition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams;

@end
