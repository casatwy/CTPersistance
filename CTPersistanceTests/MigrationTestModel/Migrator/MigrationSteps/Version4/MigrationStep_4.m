//
//  MigrationStep_4.m
//  CTPersistance
//
//  Created by casa on 2017/8/3.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "MigrationStep_4.h"

@implementation MigrationStep_4

- (void)goUpWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand error:(NSError *__autoreleasing *)error
{
    [[queryCommand addColumn:@"version4" columnInfo:@"TEXT" tableName:@"migration" error:error] executeWithError:error];
}

- (void)goDownWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand error:(NSError *__autoreleasing *)error
{

}

@end
