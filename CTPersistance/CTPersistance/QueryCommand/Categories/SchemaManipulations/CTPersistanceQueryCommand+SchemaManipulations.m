//
//  CTPersistanceQueryCommand+SchemaManipulations.m
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceQueryCommand+SchemaManipulations.h"

#import "CTPersistanceMarcos.h"

#import "NSMutableArray+CTPersistanceBindValue.h"
#import "NSString+Where.h"

@implementation CTPersistanceQueryCommand (SchemaManipulations)

- (CTPersistanceSqlStatement *)createTable:(NSString *)tableName columnInfo:(NSDictionary *)columnInfo error:(NSError *__autoreleasing *)error
{
    if (CTPersistance_isEmptyString(tableName)) {
        return nil;
    }
    
    NSMutableArray *columnList = [[NSMutableArray alloc] init];
    
    [columnInfo enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull columnName, NSString * _Nonnull columnDescription, BOOL * _Nonnull stop) {
        if (CTPersistance_isEmptyString(columnDescription)) {
            [columnList addObject:[NSString stringWithFormat:@"`%@`", columnName]];
        } else {
            [columnList addObject:[NSString stringWithFormat:@"`%@` %@", columnName, columnDescription]];
        }
    }];

    NSString *columns = [columnList componentsJoinedByString:@","];

    NSString *sqlString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS `%@` (%@);", tableName, columns];

    return [self compileSqlString:sqlString bindValueList:nil error:error];
}

/**
 *  create table with column information and defaultVaule
 *
 *  @param tableName  name of table
 *  @param columnInfo colomn information of table
 *  @param defaultSetting colomn default value information of table

 *  @return return CTPersistanceQueryCommand
 */
- (CTPersistanceSqlStatement *)createTable:(NSString *)tableName columnInfo:(NSDictionary *)columnInfo columnDefaultValue:(NSDictionary *)defaultSetting error:(NSError *__autoreleasing *)error
{
    if (CTPersistance_isEmptyString(tableName)) {
        return nil;
    }

    NSMutableArray *columnList = [[NSMutableArray alloc] init];

    [columnInfo enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull columnName, NSString * _Nonnull columnDescription, BOOL * _Nonnull stop) {
        id defaultValue = [defaultSetting valueForKey:columnName];

        if ([defaultValue isKindOfClass:[NSString class]]) {
            defaultValue = [NSString stringWithFormat:@"'%@'",defaultValue];
        }
        
        NSString *defaultSetting = @"";
        if(defaultValue) {
            defaultSetting = [NSString stringWithFormat:@"DEFAULT %@",defaultValue];
        }

        if (CTPersistance_isEmptyString(columnDescription)) {
            [columnList addObject:[NSString stringWithFormat:@"`%@` %@", columnName, defaultSetting]];
        } else {
            [columnList addObject:[NSString stringWithFormat:@"`%@` %@ %@", columnName, columnDescription, defaultSetting]];
        }
    }];

    NSString *columns = [columnList componentsJoinedByString:@","];

    NSString *sqlString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS `%@` (%@);", tableName, columns];

    return [self compileSqlString:sqlString bindValueList:nil error:error];
}


- (CTPersistanceSqlStatement *)dropTable:(NSString *)tableName error:(NSError *__autoreleasing *)error
{
    if (CTPersistance_isEmptyString(tableName)) {
        return nil;
    }
    NSString *sqlString = [NSString stringWithFormat:@"DROP TABLE IF EXISTS `%@`;", tableName];

    return [self compileSqlString:sqlString bindValueList:nil error:error];
}

- (CTPersistanceSqlStatement *)createIndex:(NSString *)indexName
                                 tableName:(NSString *)tableName
                         indexedColumnList:(NSArray *)indexedColumnList
                                  isUnique:(BOOL)isUnique
                                     error:(NSError *__autoreleasing *)error
{
    if (CTPersistance_isEmptyString(tableName) || CTPersistance_isEmptyString(indexName) || indexedColumnList == nil) {
        return nil;
    }
    
    NSMutableString *sqlString = nil;
    if (isUnique) {
        sqlString = [NSMutableString stringWithFormat:@"CREATE UNIQUE INDEX IF NOT EXISTS "];
    } else {
        sqlString = [NSMutableString stringWithFormat:@"CREATE INDEX IF NOT EXISTS "];
    }

    NSString *indexedColumnListString = [indexedColumnList componentsJoinedByString:@","];
    [sqlString appendFormat:@"`%@` ON `%@` (%@) ", indexName, tableName, indexedColumnListString];

    return [self compileSqlString:sqlString bindValueList:nil error:error];
}

- (CTPersistanceSqlStatement *)dropIndex:(NSString *)indexName error:(NSError *__autoreleasing *)error
{
    NSString *sqlString = [NSString stringWithFormat:@"DROP INDEX IF EXISTS `%@`;", indexName];

    return [self compileSqlString:sqlString bindValueList:nil error:error];
}

- (CTPersistanceSqlStatement *)addColumn:(NSString *)columnName columnInfo:(NSString *)columnInfo tableName:(NSString *)tableName error:(NSError *__autoreleasing *)error
{
    if (CTPersistance_isEmptyString(tableName) || CTPersistance_isEmptyString(columnInfo) || CTPersistance_isEmptyString(columnName)) {
        return nil;
    }
    
    NSString *sqlString = [NSString stringWithFormat:@"ALTER TABLE `%@` ADD COLUMN `%@` %@;", tableName, columnName, columnInfo];

    return [self compileSqlString:sqlString bindValueList:nil error:error];
}

- (CTPersistanceSqlStatement *)columnInfoWithTableName:(NSString *)tableName error:(NSError *__autoreleasing *)error
{
    NSString *sqlString = [NSString stringWithFormat:@"PRAGMA table_info(`%@`);", tableName];
    return [self compileSqlString:sqlString bindValueList:nil error:error];
}

- (CTPersistanceSqlStatement *)showTablesWithError:(NSError *__autoreleasing *)error
{
    NSString *sqlString = @"SELECT name FROM sqlite_master WHERE type='table';";
    return [self compileSqlString:sqlString bindValueList:nil error:error];
}

@end
