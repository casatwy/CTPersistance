//
//  CTPersistanceMigrator.h
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTPersistanceDataBase.h"
#import "CTPersistanceQueryCommand.h"
#import "CTPersistanceQueryCommand+DataManipulations.h"
#import "CTPersistanceQueryCommand+ReadMethods.h"
#import "CTPersistanceQueryCommand+SchemaManipulations.h"

@protocol CTPersistanceMigrationStep <NSObject>

- (void)goUpWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand error:(NSError **)error;
- (void)goDownWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand error:(NSError **)error;

@end

@protocol CTPersistanceMigratorProtocol <NSObject>

- (NSArray *)migrationVersionList;
- (NSDictionary *)migrationStepDictionary;

@end

@interface CTPersistanceMigrator : NSObject

- (BOOL)databaseShouldMigrate:(CTPersistanceDataBase *)database;
- (void)databasePerformMigrate:(CTPersistanceDataBase *)database;
- (void)createVersionTableWithDatabase:(CTPersistanceDataBase *)database;

@end
