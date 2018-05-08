//
//  Target_TestDatabase.h
//  CTPersistanceTests
//
//  Created by 吴明亮 on 2018/5/8.
//  Copyright © 2018 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTPersistance.h"

@interface Target_TestDatabase : NSObject<CTPersistanceConfigurationTarget>

- (NSString *)Action_secretKey:(NSDictionary *)params;

- (NSString *)Action_secretRekey:(NSDictionary *)params;

@end
