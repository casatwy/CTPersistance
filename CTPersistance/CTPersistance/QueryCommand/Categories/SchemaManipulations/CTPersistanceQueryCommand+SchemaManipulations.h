//
//  CTPersistanceQueryCommand+SchemaManipulations.h
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceQueryCommand.h"

@interface CTPersistanceQueryCommand (SchemaManipulations)

/**
 *  create table with column information
 *
 *  @param tableName  name of table
 *  @param columnInfo colomn information of table
 *
 *  @return return CTPersistanceQueryCommand
 */
- (CTPersistanceSqlStatement *)createTable:(NSString *)tableName columnInfo:(NSDictionary *)columnInfo;

/**
 *  drop table with table name
 *
 *  @param tableName name of table
 *
 *  @return return CTPersistanceQueryCommnad
 */
- (CTPersistanceSqlStatement *)dropTable:(NSString *)tableName;

/**
 *  add column with column name and column infomation and name of table
 *
 *  @param columnName column name
 *  @param columnInfo column infomation
 *  @param tableName  name of table
 *
 *  @return return CTPersistanceQueryCommnad
 */
- (CTPersistanceSqlStatement *)addColumn:(NSString *)columnName columnInfo:(NSString *)columnInfo tableName:(NSString *)tableName;

/**
 *  create Index for table with indexed column list and condition with condition params.
 *
 *  @param indexName         index name
 *  @param tableName         table name
 *  @param indexedColumnList indexed column list
 *  @param condition         condition
 *  @param conditionParams   params for condition
 *  @param isUnique          if YES, create UNIQUE index
 *
 *  @return return CTPerisistanceQueryCommand
 */
- (CTPersistanceSqlStatement *)createIndex:(NSString *)indexName tableName:(NSString *)tableName indexedColumnList:(NSArray *)indexedColumnList condition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams isUnique:(BOOL)isUnique;

/**
 *  drop index with index name
 *
 *  @param indexName index name
 *
 *  @return return CTPersisitanceQueryCommand
 */
- (CTPersistanceSqlStatement *)dropIndex:(NSString *)indexName;

/**
 *  show the structure of a table
 *
 *  @param tableName tableName name
 *
 *  @return return CTPersisitanceQueryCommand
 */
- (CTPersistanceSqlStatement *)columnInfoWithTableName:(NSString *)tableName;

@end
