//
//  Target_TestDatabase.m
//  CTPersistanceTests
//
//  Created by 吴明亮 on 2018/5/8.
//  Copyright © 2018 casa. All rights reserved.
//

#import "Target_TestDatabase.h"

@implementation Target_TestDatabase

- (NSString *)Action_secretKey:(NSDictionary *)params
{
    return @"secretKey";
}

- (NSString *)Action_secretRekey:(NSDictionary *)params {
    return @"secretRekey";
}

@end
