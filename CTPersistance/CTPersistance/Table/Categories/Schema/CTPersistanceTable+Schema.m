//
//  CTPersistanceTable+Schema.m
//  CTPersistance
//
//  Created by casa on 2017/8/3.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "CTPersistanceTable+Schema.h"
#import "CTPersistanceQueryCommand+SchemaManipulations.h"

@implementation CTPersistanceTable (Schema)

- (NSArray <NSDictionary *> *)columnInfoList
{
    NSArray *columnInfoList = [[self.queryCommand columnInfoWithTableName:self.child.tableName error:NULL] fetchWithError:NULL];
    return columnInfoList;
}

@end
