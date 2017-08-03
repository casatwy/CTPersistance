//
//  MigrationStep_2.m
//  CTPersistance
//
//  Created by casa on 2017/8/3.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "MigrationStep_2.h"

@implementation MigrationStep_2

- (void)goUpWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand error:(NSError *__autoreleasing *)error
{
    [[queryCommand addColumn:@"version2" columnInfo:@"TEXT" tableName:@"migration"] executeWithError:error];
}

- (void)goDownWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand error:(NSError *__autoreleasing *)error
{
    
}

@end
