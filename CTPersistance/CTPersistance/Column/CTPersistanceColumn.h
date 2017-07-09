//
//  CTPersistanceColumn.h
//  CTPersistance
//
//  Created by casa on 2017/7/10.
//  Copyright © 2017年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const CTPersistanceColumnTypeInteger;
extern NSString * const CTPersistanceColumnTypeReal;
extern NSString * const CTPersistanceColumnTypeText;
extern NSString * const CTPersistanceColumnTypeBlob;

@protocol CTPersistanceColumnDescription <NSObject>

+ (NSString *)columnName;
+ (NSString *)columnType;
+ (BOOL)isPrimaryKey;
+ (BOOL)isAutoIncrement;
+ (BOOL)isNOTNULL;

@end

extern NSString * CTPersistanceColumnInfo(Class<CTPersistanceColumnDescription>columnClass);
