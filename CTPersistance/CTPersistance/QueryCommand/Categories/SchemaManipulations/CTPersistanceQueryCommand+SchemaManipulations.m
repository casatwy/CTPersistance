//
//  CTPersistanceQueryCommand+SchemaManipulations.m
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceQueryCommand+SchemaManipulations.h"

#import "CTPersistanceMarcos.h"
#import "CTPersistanceQueryCommand+ReadMethods.h"
#import "NSString+SQL.h"

@implementation CTPersistanceQueryCommand (SchemaManipulations)

- (CTPersistanceQueryCommand *)createTable:(NSString *)tableName columnInfo:(NSDictionary *)columnInfo
{
    [self resetQueryCommand];
    NSString *safeTableName = [tableName safeSQLMetaString];
    if (CTPersistance_isEmptyString(safeTableName)) {
        return self;
    }
    
    NSMutableArray *columnList = [[NSMutableArray alloc] init];
    
    [columnInfo enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull columnName, NSString * _Nonnull columnDescription, BOOL * _Nonnull stop) {
        NSString *safeColumnName = columnName;
        NSString *safeDescription = columnDescription;
        
        if (CTPersistance_isEmptyString(safeDescription)) {
            [columnList addObject:[NSString stringWithFormat:@"`%@`", safeColumnName]];
        } else {
            [columnList addObject:[NSString stringWithFormat:@"`%@` %@", safeColumnName, safeDescription]];
        }
    }];
    
    NSString *columns = [columnList componentsJoinedByString:@","];
    [self.sqlString appendFormat:@"CREATE TABLE IF NOT EXISTS `%@` (%@);", safeTableName, columns];
    
    return self;
}

- (CTPersistanceQueryCommand *)dropTable:(NSString *)tableName
{
    [self resetQueryCommand];
    if (CTPersistance_isEmptyString(tableName)) {
        return self;
    }
    NSString *safeTableName = [tableName safeSQLMetaString];
    [self.sqlString appendFormat:@"DROP TABLE IF EXISTS `%@`;", safeTableName];
    return self;
}

- (CTPersistanceQueryCommand *)createIndex:(NSString *)indexName tableName:(NSString *)tableName indexedColumnList:(NSArray *)indexedColumnList condition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams isUnique:(BOOL)isUnique
{
    [self resetQueryCommand];
    
    NSString *safeIndexName = [indexName safeSQLMetaString];
    NSString *safeTableName = [tableName safeSQLMetaString];
    if (CTPersistance_isEmptyString(safeTableName) || CTPersistance_isEmptyString(safeIndexName) || indexedColumnList == nil) {
        return self;
    }
    
    NSString *indexedColumnListString = [indexedColumnList componentsJoinedByString:@","];
    
    if (isUnique) {
        [self.sqlString appendFormat:@"CREATE UNIQUE INDEX IF NOT EXISTS "];
    } else {
        [self.sqlString appendFormat:@"CREATE INDEX IF NOT EXISTS "];
    }
    
    [self.sqlString appendFormat:@"`%@` ON `%@` (%@) ", safeIndexName, safeTableName, indexedColumnListString];
    
    return [self where:condition params:conditionParams];
}

- (CTPersistanceQueryCommand *)dropIndex:(NSString *)indexName
{
    [self resetQueryCommand];
    NSString *safeIndexName = [indexName safeSQLMetaString];
    [self.sqlString appendFormat:@"DROP INDEX IF EXISTS `%@`;", safeIndexName];
    return self;
}

- (CTPersistanceQueryCommand *)addColumn:(NSString *)columnName columnInfo:(NSString *)columnInfo tableName:(NSString *)tableName
{
    [self resetQueryCommand];
    NSString *safeColumnName = [columnName safeSQLMetaString];
    NSString *safeColumnInfo = [columnInfo safeSQLMetaString];
    NSString *safeTableName = [tableName safeSQLMetaString];
    
    if (CTPersistance_isEmptyString(safeTableName) || CTPersistance_isEmptyString(safeColumnInfo) || CTPersistance_isEmptyString(safeColumnName)) {
        return self;
    }
    
    [self.sqlString appendFormat:@"ALTER TABLE `%@` ADD COLUMN `%@` %@;", safeTableName, safeColumnName, safeColumnInfo];
    
    return self;
}

@end
