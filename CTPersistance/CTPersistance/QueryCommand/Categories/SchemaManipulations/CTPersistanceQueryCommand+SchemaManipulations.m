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

@implementation CTPersistanceQueryCommand (SchemaManipulations)

- (CTPersistanceQueryCommand *)createTable:(NSString *)tableName columnInfo:(NSDictionary *)columnInfo
{
    if (CTPersistance_isEmptyString(tableName)) {
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
    [self.sqlString appendFormat:@"CREATE TABLE IF NOT EXISTS `%@` (%@);", tableName, columns];

    sqlite3_stmt *statement = nil;
    int result = sqlite3_prepare_v2(self.database.database, [self.sqlString UTF8String], (int)self.sqlString.length, &statement, NULL);
    if (result != SQLITE_OK) {
#warning todo
        NSString *errorMessage = [NSString stringWithUTF8String:sqlite3_errmsg(self.database.database)];
        NSLog(@"error is %@", errorMessage);
        sqlite3_finalize(statement);
        return self;
    }
    
    self.statement = statement;
    
    return self;
}

- (CTPersistanceQueryCommand *)dropTable:(NSString *)tableName
{
    if (CTPersistance_isEmptyString(tableName)) {
        return self;
    }
    [self.sqlString appendFormat:@"DROP TABLE IF EXISTS `%@`;", tableName];
    return self;
}

- (CTPersistanceQueryCommand *)createIndex:(NSString *)indexName tableName:(NSString *)tableName indexedColumnList:(NSArray *)indexedColumnList condition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams isUnique:(BOOL)isUnique
{
#warning todo
    if (CTPersistance_isEmptyString(tableName) || CTPersistance_isEmptyString(indexName) || indexedColumnList == nil) {
        return self;
    }
    
    NSString *indexedColumnListString = [indexedColumnList componentsJoinedByString:@","];
    
    if (isUnique) {
        [self.sqlString appendFormat:@"CREATE UNIQUE INDEX IF NOT EXISTS "];
    } else {
        [self.sqlString appendFormat:@"CREATE INDEX IF NOT EXISTS "];
    }
    
    [self.sqlString appendFormat:@"`%@` ON `%@` (%@) ", indexName, tableName, indexedColumnListString];

    return nil;

//    return [self where:condition params:conditionParams];
}

- (CTPersistanceQueryCommand *)dropIndex:(NSString *)indexName
{
    [self.sqlString appendFormat:@"DROP INDEX IF EXISTS `%@`;", indexName];
    return self;
}

- (CTPersistanceQueryCommand *)addColumn:(NSString *)columnName columnInfo:(NSString *)columnInfo tableName:(NSString *)tableName
{
    if (CTPersistance_isEmptyString(tableName) || CTPersistance_isEmptyString(columnInfo) || CTPersistance_isEmptyString(columnName)) {
        return self;
    }
    
    [self.sqlString appendFormat:@"ALTER TABLE `%@` ADD COLUMN `%@` %@;", tableName, columnName, columnInfo];
    
    return self;
}

@end
