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

/**
 *  this protocol is used for Migration
 */
@protocol CTPersistanceMigrationStep <NSObject>

/**
 *  go upper version
 *
 *  You implement this method to make migration forward, if you set error is not nil, CTPersistanceMigrator will call goDownWithQueryCommand:
 *
 *  @param queryCommand CTPersistanceQueryCommand instance
 *  @param error        error if fails
 */
- (void)goUpWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand error:(NSError **)error;

/**
 *  go lower version
 *
 *  CTPersistanceMigrator will call this method when goUpWithQueryCommand: fails
 *
 *  @param queryCommand CTPersistanceQueryCommand instance
 *  @param error        error if fails
 */
- (void)goDownWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand error:(NSError **)error;

@end

/**
 *  Your own Migrator must extend from CTPersistanceMigrator and confirms to this protocol, or migration won't work.
 */
@protocol CTPersistanceMigratorProtocol <NSObject>

@required
/**
 *  the order of migration
 *
 *  @return return the order of migration
 */
- (NSArray *)migrationVersionList;

/**
 *  the dictionary contains step objects which keyed by version string
 *
 *  @return return step dictionary
 */
- (NSDictionary *)migrationStepDictionary;

@end

/**
 *  You should create your own migrator object which must extend from CTPersistanceMigrator and confirms to this <CTPersistanceMigratorProtocol>, or migration won't work.
 */
@interface CTPersistanceMigrator : NSObject

/**
 *  return whether should perform migration.
 *
 *  You should never call this method.
 *
 *  @param database CTPersistanceDataBase instance
 *
 *  @return return YES for 'should perform migration', NO for 'don't perform migration'
 *
 *  @warning you should never call this method
 *
 */
- (BOOL)databaseShouldMigrate:(CTPersistanceDataBase *)database;

/**
 *  perform migration steps
 *
 *  You should never call this method.
 *
 *  @param database CTPersistanceDataBase instance
 *
 *  @warning you should never call this method
 *
 */
- (void)databasePerformMigrate:(CTPersistanceDataBase *)database;

/**
 *  create version table with database if version table not exists
 *
 *  You should never call this method.
 *
 *  @param database CTPersistanceDataBase instance
 *
 *  @warning you should never call this method
 *
 */
- (void)createVersionTableWithDatabase:(CTPersistanceDataBase *)database;

@end
