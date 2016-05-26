//
//  CTPersistanceQueryCommand+ReadMethods.m
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceQueryCommand+ReadMethods.h"
#import "NSString+SQL.h"
#import "CTPersistanceConfiguration.h"

@implementation CTPersistanceQueryCommand (ReadMethods)

- (CTPersistanceQueryCommand *)select:(NSString *)columList isDistinct:(BOOL)isDistinct
{
    [self resetQueryCommand];
    
    if (columList == nil) {
        if (isDistinct) {
            [self.sqlString appendString:@"SELECT DISTINCT * "];
        } else {
            [self.sqlString appendString:@"SELECT * "];
        }
    } else {
        if (isDistinct) {
            [self.sqlString appendFormat:@"SELECT DISTINCT '%@' ", [columList safeSQLEncode]];
        } else {
            [self.sqlString appendFormat:@"SELECT '%@' ", [columList safeSQLEncode]];
        }
    }
    
    return self;
}

- (CTPersistanceQueryCommand *)from:(NSString *)fromList
{
    if (fromList == nil) {
        return self;
    }
    [self.sqlString appendFormat:@"FROM '%@' ", [fromList safeSQLEncode]];
    return self;
}

- (CTPersistanceQueryCommand *)where:(NSString *)condition params:(NSDictionary *)params
{
    if (condition == nil) {
        return self;
    }

    NSString *whereString = [condition stringWithSQLParams:params];
    [self.sqlString appendFormat:@"WHERE %@ ", whereString];
    
    return self;
}

- (CTPersistanceQueryCommand *)orderBy:(NSString *)orderBy isDESC:(BOOL)isDESC
{
    if (orderBy == nil) {
        return self;
    }
    [self.sqlString appendFormat:@"ORDER BY %@ ", [orderBy safeSQLMetaString]];
    if (isDESC) {
        [self.sqlString appendString:@"DESC "];
    } else {
        [self.sqlString appendString:@"ASC "];
    }
    return self;
}

- (CTPersistanceQueryCommand *)limit:(NSInteger)limit
{
    if (limit == CTPersistanceNoLimit) {
        return self;
    }
    [self.sqlString appendFormat:@"LIMIT %lu ", (unsigned long)limit];
    return self;
}

- (CTPersistanceQueryCommand *)offset:(NSInteger)offset
{
    if (offset == CTPersistanceNoOffset) {
        return self;
    }
    [self.sqlString appendFormat:@"OFFSET %lu ", (unsigned long)offset];
    return self;
}

- (CTPersistanceQueryCommand *)limit:(NSInteger)limit offset:(NSInteger)offset
{
    return [[self limit:limit] offset:offset];
}

@end
