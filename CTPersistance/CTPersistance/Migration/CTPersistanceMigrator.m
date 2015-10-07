//
//  CTPersistanceMigrator.m
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceMigrator.h"

#import "CTPersistanceQueryCommand.h"

#import "CTPersistanceTable+Insert.h"
#import "CTPersistanceTable+Find.h"
#import "CTPersistanceTable+Update.h"

#import "CTPersistanceVersionRecord.h"
#import "CTPersistanceVersionTable.h"
#import "CTPersistanceConfiguration.h"

@interface CTPersistanceMigrator ()

@property (nonatomic, weak) id<CTPersistanceMigratorProtocol> child;
@property (nonatomic, strong) CTPersistanceVersionTable *versionTable;
@property (nonatomic, weak) CTPersistanceDataBase *database;

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
    CTPersistanceVersionRecord *record = [[CTPersistanceVersionRecord alloc] init];
    record.databaseVersion = [[self.child migrationVersionList] lastObject];
    [self.versionTable insertRecord:record error:NULL];
}

- (BOOL)databaseShouldMigrate:(CTPersistanceDataBase *)database
{
    self.database = database;
    CTPersistanceVersionRecord *latestRecord = (CTPersistanceVersionRecord *)[self.versionTable findLatestRecordWithError:NULL];
    NSString *currentVersion = latestRecord.databaseVersion;
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
    CTPersistanceVersionRecord *latestRecord = (CTPersistanceVersionRecord *)[self.versionTable findLatestRecordWithError:&error];
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
            [step goUpWithQueryCommand:self.versionTable.queryCommand error:&error];
            if (error) {
                error = nil;
                [step goDownWithQueryCommand:self.versionTable.queryCommand error:&error];
                break;
            } else {
                latestRecord.databaseVersion = version;
                error = nil;
                [self.versionTable updateRecord:latestRecord error:&error];
            }
        }
        
        if ([version isEqualToString:latestRecord.databaseVersion]) {
            shouldPerformMigration = YES;
        }
    }
}

#pragma mark - getters and setters
- (CTPersistanceVersionTable *)versionTable
{
    if (_versionTable == nil) {
        _versionTable = [[CTPersistanceVersionTable alloc] initWithDatabase:self.database];
    }
    return _versionTable;
}

@end
