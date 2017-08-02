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
#import "NSMutableArray+CTPersistanceBindValue.h"

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

    NSString *sqlString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS `%@` (%@);", tableName, columns];

    sqlite3_stmt *statement = nil;
    int result = sqlite3_prepare_v2(self.database.database, [sqlString UTF8String], (int)sqlString.length, &statement, NULL);
    if (result != SQLITE_OK) {
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
    NSString *sqlString = [NSString stringWithFormat:@"DROP TABLE IF EXISTS `%@`;", tableName];

    sqlite3_stmt *statement = nil;
    int result = sqlite3_prepare_v2(self.database.database, [sqlString UTF8String], (int)sqlString.length, &statement, NULL);
    if (result != SQLITE_OK) {
        NSString *errorMessage = [NSString stringWithUTF8String:sqlite3_errmsg(self.database.database)];
        NSLog(@"error is %@", errorMessage);
        sqlite3_finalize(statement);
        return self;
    }
    self.statement = statement;

    return self;
}

- (CTPersistanceQueryCommand *)createIndex:(NSString *)indexName
                                 tableName:(NSString *)tableName
                         indexedColumnList:(NSArray *)indexedColumnList
                                 condition:(NSString *)condition
                           conditionParams:(NSDictionary *)conditionParams
                                  isUnique:(BOOL)isUnique
{
#warning todo need test
    if (CTPersistance_isEmptyString(tableName) || CTPersistance_isEmptyString(indexName) || indexedColumnList == nil) {
        return self;
    }
    
    NSMutableArray <NSInvocation *> *bindValueList = [[NSMutableArray alloc] init];

    NSMutableString *whereString = [condition mutableCopy];
    [conditionParams enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        NSMutableString *valueKey = [key mutableCopy];
        [valueKey deleteCharactersInRange:NSMakeRange(0, 1)];
        [valueKey insertString:@":CTPersistanceWhere" atIndex:0];
        [whereString replaceOccurrencesOfString:key withString:valueKey options:0 range:NSMakeRange(0, whereString.length)];
        [bindValueList addBindKey:valueKey bindValue:value columnDescription:nil];
    }];

    NSMutableString *sqlString = nil;
    if (isUnique) {
        sqlString = [NSMutableString stringWithFormat:@"CREATE UNIQUE INDEX IF NOT EXISTS "];
    } else {
        sqlString = [NSMutableString stringWithFormat:@"CREATE INDEX IF NOT EXISTS "];
    }

    NSString *indexedColumnListString = [indexedColumnList componentsJoinedByString:@","];
    [sqlString appendFormat:@"`%@` ON `%@` (%@) ", indexName, tableName, indexedColumnListString];

    if (whereString.length > 0) {
        [sqlString appendFormat:@"WHERE %@;", whereString];
    }

    sqlite3_stmt *statement = nil;
    int result = sqlite3_prepare_v2(self.database.database, [sqlString UTF8String], (int)sqlString.length, &statement, NULL);
    if (result != SQLITE_OK) {
        NSString *errorMessage = [NSString stringWithUTF8String:sqlite3_errmsg(self.database.database)];
        NSLog(@"error is %@", errorMessage);
        sqlite3_finalize(statement);
        return self;
    }
    self.statement = statement;

    [bindValueList enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull invocation, NSUInteger idx, BOOL * _Nonnull stop) {
        [invocation setArgument:statement atIndex:2];
        [invocation invoke];
    }];

    return self;
}

- (CTPersistanceQueryCommand *)dropIndex:(NSString *)indexName
{
#warning todo need test
    NSString *sqlString = [NSString stringWithFormat:@"DROP INDEX IF EXISTS `%@`;", indexName];

    sqlite3_stmt *statement = nil;
    int result = sqlite3_prepare_v2(self.database.database, [sqlString UTF8String], (int)sqlString.length, &statement, NULL);
    if (result != SQLITE_OK) {
        NSString *errorMessage = [NSString stringWithUTF8String:sqlite3_errmsg(self.database.database)];
        NSLog(@"error is %@", errorMessage);
        sqlite3_finalize(statement);
        return self;
    }
    self.statement = statement;
    
    return self;
}

- (CTPersistanceQueryCommand *)addColumn:(NSString *)columnName columnInfo:(NSString *)columnInfo tableName:(NSString *)tableName
{
#warning todo need test
    if (CTPersistance_isEmptyString(tableName) || CTPersistance_isEmptyString(columnInfo) || CTPersistance_isEmptyString(columnName)) {
        return self;
    }
    
    NSString *sqlString = [NSString stringWithFormat:@"ALTER TABLE `%@` ADD COLUMN `%@` %@;", tableName, columnName, columnInfo];

    sqlite3_stmt *statement = nil;
    int result = sqlite3_prepare_v2(self.database.database, [sqlString UTF8String], (int)sqlString.length, &statement, NULL);
    if (result != SQLITE_OK) {
        NSString *errorMessage = [NSString stringWithUTF8String:sqlite3_errmsg(self.database.database)];
        NSLog(@"error is %@", errorMessage);
        sqlite3_finalize(statement);
        return self;
    }
    self.statement = statement;
    
    return self;
}

@end
