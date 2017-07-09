//
//  CTPersistanceColumn.m
//  CTPersistance
//
//  Created by casa on 2017/7/10.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "CTPersistanceColumn.h"

NSString * const CTPersistanceColumnTypeInteger = @"INTEGER";
NSString * const CTPersistanceColumnTypeReal = @"REAL";
NSString * const CTPersistanceColumnTypeText = @"TEXT";
NSString * const CTPersistanceColumnTypeBlob = @"BLOB";

NSString * CTPersistanceColumnInfo(Class<CTPersistanceColumnDescription>columnClass)
{
    NSMutableString *columnInfo = [[NSMutableString alloc] initWithString:[columnClass columnType]];
    if ([columnClass isPrimaryKey]) {
    }
    return columnInfo;
}
