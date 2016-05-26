//
//  CTPersistanceQueryCommand+DataManipulations.m
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceQueryCommand+DataManipulations.h"

#import "CTPersistanceMarcos.h"
#import "NSString+SQL.h"
#import "CTPersistanceQueryCommand+ReadMethods.h"

@implementation CTPersistanceQueryCommand (DataManipulations)

- (CTPersistanceQueryCommand *)insertTable:(NSString *)tableName withDataList:(NSArray *)dataList
{
    [self resetQueryCommand];
    
    NSString *safeTableName = [tableName safeSQLMetaString];
    if (CTPersistance_isEmptyString(safeTableName) || dataList == nil) {
        return self;
    }
    
    NSMutableArray *valueItemList = [[NSMutableArray alloc] init];
    __block NSString *columString = nil;
    [dataList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull description, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *columList = [[NSMutableArray alloc] init];
        NSMutableArray *valueList = [[NSMutableArray alloc] init];
        
        [description enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull colum, NSString * _Nonnull value, BOOL * _Nonnull stop) {
            [columList addObject:[NSString stringWithFormat:@"`%@`", [colum safeSQLMetaString]]];
            if ([value isKindOfClass:[NSString class]]) {
                [valueList addObject:[NSString stringWithFormat:@"'%@'", [value safeSQLEncode]]];
            } else if ([value isKindOfClass:[NSNull class]]) {
                [valueList addObject:@"NULL"];
            } else {
                [valueList addObject:[NSString stringWithFormat:@"'%@'", value]];
            }
        }];
        
        if (columString == nil) {
            columString = [columList componentsJoinedByString:@","];
        }
        NSString *valueString = [valueList componentsJoinedByString:@","];
        
        [valueItemList addObject:[NSString stringWithFormat:@"(%@)", valueString]];
    }];
    
    [self.sqlString appendFormat:@"INSERT INTO `%@` (%@) VALUES %@;", safeTableName, columString, [valueItemList componentsJoinedByString:@","]];
    
    return self;
}

- (CTPersistanceQueryCommand *)updateTable:(NSString *)tableName withData:(NSDictionary *)data condition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams
{
    [self resetQueryCommand];
    
    NSString *safeTableName = [tableName safeSQLMetaString];
    if (CTPersistance_isEmptyString(safeTableName) || data == nil){
        return self;
    }

    NSMutableArray *valueList = [[NSMutableArray alloc] init];

    [data enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull colum, NSString * _Nonnull value, BOOL * _Nonnull stop) {
        if ([value isKindOfClass:[NSString class]]) {
            [valueList addObject:[NSString stringWithFormat:@"`%@`='%@'", [colum safeSQLMetaString], [value safeSQLEncode]]];
        } else if ([value isKindOfClass:[NSNull class]]) {
            [valueList addObject:[NSString stringWithFormat:@"`%@`=NULL", [colum safeSQLMetaString]]];
        } else {
            [valueList addObject:[NSString stringWithFormat:@"`%@`=%@", [colum safeSQLMetaString], value]];
        }
    }];

    NSString *valueString = [valueList componentsJoinedByString:@","];

    [self.sqlString appendFormat:@"UPDATE `%@` SET %@ ", safeTableName, valueString];

    NSString *trimmedCondition = [condition safeSQLMetaString];
    return [self where:trimmedCondition params:conditionParams];
}

- (CTPersistanceQueryCommand *)deleteTable:(NSString *)tableName withCondition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams
{
    [self resetQueryCommand];
    
    NSString *safeTableName = [tableName safeSQLMetaString];

    if (CTPersistance_isEmptyString(safeTableName)) {
        return self;
    }
    
    [self.sqlString appendFormat:@"DELETE FROM `%@` ", safeTableName];

    NSString *trimmedCondition = [condition safeSQLMetaString];
    return [self where:trimmedCondition params:conditionParams];
}

@end
