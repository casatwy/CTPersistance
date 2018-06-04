//
//  Target_MigrationTestDatabaseNewCreate.h
//  CTPersistanceTests
//
//  Created by 吴明亮 on 2018/6/4.
//  Copyright © 2018 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTPersistance.h"

@interface Target_MigrationTestDatabaseNewCreate : NSObject <CTPersistanceConfigurationTarget>

- (CTPersistanceMigrator *)Action_fetchMigrator:(NSDictionary *)params;

@end
