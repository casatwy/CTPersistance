//
//  Target_CTPersistanceConfiguration.h
//  CTPersistance
//
//  Created by casa on 2017/8/10.
//  Copyright © 2017年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTPersistance.h"

@interface Target_MigrationTestDatabase : NSObject <CTPersistanceConfigurationTarget>

- (CTPersistanceMigrator *)Action_fetchMigrator:(NSDictionary *)params;
- (NSString *)Action_secretKey:(NSDictionary *)params;

@end
