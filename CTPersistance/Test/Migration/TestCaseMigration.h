//
//  TestMigration.h
//  CTPersistance
//
//  Created by casa on 2016/12/5.
//  Copyright © 2016年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestCaseMigration : NSObject

@property (nonatomic, assign) NSInteger migrateTargetVersion;

+ (instancetype)sharedInstance;

- (void)testMigrateFromNoneDataBase;
- (void)testMigrateFromVersion1ToVersion2;
- (void)testMigrateFromVersion1ToVersion3;
- (void)testMigrateFromVersion1ToVersion4;
- (void)testMigrateFromVersion2ToVersion3;
- (void)testMigrateFromVersion2ToVersion4;
- (void)testMigrateFromVersion3ToVersion4;
- (void)testMigrateFromVersion4ToVersion4;

@end
