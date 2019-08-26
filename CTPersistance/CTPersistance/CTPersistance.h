//
//  CTPersistance.h
//  CTPersistance
//
//  Created by casa on 15/10/3.
//  Copyright © 2015年 casa. All rights reserved.
//

#ifndef CTPersistance_h
#define CTPersistance_h

#import "CTPersistanceConfiguration.h"
#import "CTPersistanceMarcos.h"

#import "CTPersistanceMigrator.h"
#import "CTPersistanceTransaction.h"
#import "CTPersistanceAsyncExecutor.h"

#import "CTPersistanceDataBase.h"
#import "CTPersistanceDatabasePool.h"

#import "CTPersistanceRecordProtocol.h"
#import "CTPersistanceRecord.h"

#import "CTPersistanceTable.h"
#import "CTPersistanceTable+Find.h"
#import "CTPersistanceTable+Delete.h"
#import "CTPersistanceTable+Insert.h"
#import "CTPersistanceTable+Update.h"
#import "CTPersistanceTable+Schema.h"
#import "CTPersistanceTable+Upsert.h"

#import "CTPersistanceQueryCommand.h"
#import "CTPersistanceQueryCommand+DataManipulations.h"
#import "CTPersistanceQueryCommand+SchemaManipulations.h"
#import "CTPersistanceQueryCommand+Status.h"

extern NSString * _Nonnull const kCTPersistanceDataBaseCheckMigrationNotification;
extern NSString * _Nonnull const kCTPersistanceInitVersion;

extern NSString * _Nonnull const kCTPersistanceConfigurationParamsKeyDatabaseName;

@protocol CTPersistanceConfigurationTarget <NSObject>

@optional
/**
 return migrator for database migration, return nil means do not check version for migration

 @param params params is a dictionary, with key kCTPersistanceConfigurationParamsKeyDatabaseName to tell you the database name
 @return migrator
 */
- (CTPersistanceMigrator * __nullable)Action_fetchMigrator:(NSDictionary *)params;


/**
 secret key to encrypt the database, return nil means no encryption.

 @param params params is a dictionary, with key kCTPersistanceConfigurationParamsKeyDatabaseName to tell you the database name
 @return secret key
 */
- (NSArray <NSString * > * __nullable)Action_secretKey:(NSDictionary *)params;

/**
 return file path if you want your database file to lcoate at specific path. return nil means use the default file path.
 default path is: [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:databaseName];

 @param params params is a dictionary, with key kCTPersistanceConfigurationParamsKeyDatabaseName to tell you the database name
 @return database file path
 */
- (NSString * __nullable)Action_filePath:(NSDictionary *)params;

@end

#endif /* CTPersistance_h */
