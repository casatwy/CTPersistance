//
//  CTPersistanceMigrator.m
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceMigrator.h"

#import "CTPersistanceQueryCommand.h"

#import "CTPersistanceVersionRecord.h"
#import "CTPersistanceVersionTable.h"
#import "CTPersistanceConfiguration.h"

#import "NSArray+CTPersistanceRecordTransform.h"
#import "NSMutableArray+CTPersistanceBindValue.h"
#import "NSDictionary+KeyValueBind.h"
#import <UIKit/UIKit.h>

NSString * const kCTPersistanceInitVersion = @"kCTPersistanceInitVersion";

@interface CTPersistanceMigrator ()

@property (nonatomic, weak) id<CTPersistanceMigratorProtocol> child;
@property (nonatomic, weak) CTPersistanceDataBase *database;
@property (nonatomic, assign, readwrite) BOOL isMigrating;

@end

@implementation CTPersistanceMigrator

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self && [self conformsToProtocol:@protocol(CTPersistanceMigratorProtocol)]) {
        self.child = (id<CTPersistanceMigratorProtocol>)self;
    } else {
        NSException *exception = [NSException exceptionWithName:@"CTPersistanceMigrator init error" reason:@"the child class must conforms to protocol: <CTPersistanceMigratorProtocol>" userInfo:nil];
        @throw exception;
    }
    return self;
}

#pragma mark - public methods
- (BOOL)databaseShouldMigrate:(CTPersistanceDataBase *)database
{
    self.database = database;
    CTPersistanceQueryCommand *queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabase:database];
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ DESC LIMIT 1;", [CTPersistanceVersionTable tableName], [CTPersistanceVersionTable primaryKeyName]];
    NSDictionary *latestRecord = [[[queryCommand compileSqlString:sqlString bindValueList:nil error:NULL] fetchWithError:NULL] firstObject];
    NSString *currentVersion = latestRecord[@"databaseVersion"];
    NSUInteger index = [[self.child migrationVersionList] indexOfObject:currentVersion];
    if (index == [[self.child migrationVersionList] count] - 1) {
        return NO;
    }
    return YES;
}

- (void)databasePerformMigrate:(CTPersistanceDataBase *)database
{
    self.database = database;
    NSError *error = nil;
    
    CTPersistanceQueryCommand *queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabase:database];
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ DESC LIMIT 1;", [CTPersistanceVersionTable tableName], [CTPersistanceVersionTable primaryKeyName]];
    NSMutableDictionary *latestRecord = [[[[queryCommand compileSqlString:sqlString bindValueList:nil error:NULL] fetchWithError:NULL] firstObject] mutableCopy];
    if (error) {
        NSLog(@"[%s:%s(%d)]:\n\terror is %@", __FILE__, __FUNCTION__, __LINE__, error);
        return;
    }

    BOOL shouldPerformMigration = NO;
    NSArray *versionList = [self.child migrationVersionList];
    NSDictionary *migrationObjectContainer = [self.child migrationStepDictionary];
    for (NSString *version in versionList) {
        if (shouldPerformMigration) {
            id<CTPersistanceMigrationStep> step = [[migrationObjectContainer[version] alloc] init];
            error = nil;
            [step goUpWithQueryCommand:queryCommand error:&error];
            if (error) {
                error = nil;
                [step goDownWithQueryCommand:queryCommand error:&error];
                break;
            } else {
                latestRecord[@"databaseVersion"] = version;
                error = nil;

                NSMutableArray *bindValueList = [[NSMutableArray alloc] init];
                NSString *valueString = [latestRecord bindToValueList:bindValueList];

                NSNumber *primaryKeyValue = latestRecord[@"identifier"];
                NSString *valueKey = [NSString stringWithFormat:@":CTPersistanceWhere_%@", [CTPersistanceVersionTable primaryKeyName]];
                NSString *whereString = [NSString stringWithFormat:@"%@ = %@", [CTPersistanceVersionTable primaryKeyName], valueKey];
                [bindValueList addBindKey:valueKey bindValue:primaryKeyValue columnDescription:nil];

                [[queryCommand updateTable:[CTPersistanceVersionTable tableName] valueString:valueString whereString:whereString bindValueList:bindValueList error:&error] executeWithError:&error];

                if (error) {
                    NSLog(@"[%s:%s(%d)]:\n\terror is %@", __FILE__, __FUNCTION__, __LINE__, error);
                }
            }
        }
        
        if ([version isEqualToString:latestRecord[@"databaseVersion"]]) {
            shouldPerformMigration = YES;
        }
    }
}

@end
