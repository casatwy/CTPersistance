//
//  CTPersistanceMigrator.m
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceMigrator.h"

#import "CTPersistanceQueryCommand.h"
#import "CTPersistanceQueryCommand+ReadMethods.h"

#import "CTPersistanceVersionRecord.h"
#import "CTPersistanceVersionTable.h"
#import "CTPersistanceConfiguration.h"

#import "NSArray+CTPersistanceRecordTransform.h"
#import <UIKit/UIKit.h>

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
- (void)createVersionTableWithDatabase:(CTPersistanceDataBase *)database
{
    self.database = database;
    
    CTPersistanceQueryCommand *queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabase:database];
    [[queryCommand createTable:[CTPersistanceVersionTable tableName] columnInfo:[CTPersistanceVersionTable columnInfo]] executeWithError:NULL];
    [queryCommand resetQueryCommand];
    NSArray *result = [[[queryCommand countAll] from:[CTPersistanceVersionTable tableName]] fetchWithError:NULL];
    if ([[result firstObject][@"COUNT(*)"] integerValue] == 0) {
        [queryCommand resetQueryCommand];
        [[queryCommand insertTable:[CTPersistanceVersionTable tableName] withDataList:@[@{@"databaseVersion":[[self.child migrationVersionList] firstObject]}]] executeWithError:NULL];
    }
}

- (BOOL)databaseShouldMigrate:(CTPersistanceDataBase *)database
{
    self.database = database;
    CTPersistanceQueryCommand *queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabase:database];
    NSDictionary *latestRecord = [[[[[[queryCommand select:nil isDistinct:NO] from:[CTPersistanceVersionTable tableName]] orderBy:[CTPersistanceVersionTable primaryKeyName] isDESC:YES] limit:1] fetchWithError:NULL] firstObject];
    
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
    NSMutableDictionary *latestRecord = [[[[[[[queryCommand select:nil isDistinct:NO] from:[CTPersistanceVersionTable tableName]] orderBy:[CTPersistanceVersionTable primaryKeyName] isDESC:YES] limit:1] fetchWithError:NULL] firstObject] mutableCopy];
    if (error) {
        return;
    }
    
    BOOL shouldPerformMigration = NO;
    NSArray *versionList = [self.child migrationVersionList];
    NSDictionary *migrationObjectContainer = [self.child migrationStepDictionary];
    for (NSString *version in versionList) {
        if (shouldPerformMigration) {
            id<CTPersistanceMigrationStep> step = [[migrationObjectContainer[version] alloc] init];
            error = nil;
            [queryCommand resetQueryCommand];
            [step goUpWithQueryCommand:queryCommand error:&error];
            if (error) {
                error = nil;
                [queryCommand resetQueryCommand];
                [step goDownWithQueryCommand:queryCommand error:&error];
                break;
            } else {
                latestRecord[@"databaseVersion"] = version;
                error = nil;
                [queryCommand resetQueryCommand];
                NSNumber *primaryKeyValue = latestRecord[@"identifier"];
                 NSDictionary *whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyValue);
                [[queryCommand updateTable:[CTPersistanceVersionTable tableName] withData:latestRecord condition:[NSString stringWithFormat:@"%@ = :primaryKeyValue", [CTPersistanceVersionTable primaryKeyName]] conditionParams:whereConditionParams] executeWithError:&error];
                
                NSLog(@"error at CTPersistanceMigrator:%d:%@", __LINE__, error);
                
                if (error) {
                    NSLog(@"error at CTPersistanceMigrator:%d:%@", __LINE__, error);
                }
                
            }
        }
        
        if ([version isEqualToString:latestRecord[@"databaseVersion"]]) {
            shouldPerformMigration = YES;
        }
    }
}

@end
