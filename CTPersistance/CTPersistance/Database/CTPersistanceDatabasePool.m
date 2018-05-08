//
//  CTPersistanceContext.m
//  CTPersistance
//
//  Created by casa on 15/10/3.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceDatabasePool.h"
#import "CTPersistanceDataBase.h"

@interface CTPersistanceDatabasePool ()

@property (nonatomic, strong) NSMutableDictionary <NSString *, CTPersistanceDataBase *> *databaseList;

@end

@implementation CTPersistanceDatabasePool

#pragma mark - public methods
+ (instancetype)sharedInstance
{
    static CTPersistanceDatabasePool *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CTPersistanceDatabasePool alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _databaseList = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [self closeAllDatabase];
}

- (CTPersistanceDataBase *)databaseWithName:(NSString *)databaseName
{
    NSParameterAssert(databaseName);
    
    @synchronized (self) {

        NSError *error = nil;
        CTPersistanceDataBase *databaseInstance = [[CTPersistanceDataBase alloc] initWithDatabaseName:databaseName error:&error];

        if (error) {
            NSLog(@"Error at %s:[%d]:%@", __FILE__, __LINE__, error);
            return nil;
        }

        NSString *key = databaseInstance.databaseFilePath;

        CTPersistanceDataBase *existDBInstance = self.databaseList[key];

        if (existDBInstance) {
            return existDBInstance;
        }

        self.databaseList[key] = databaseInstance;
        
        return databaseInstance;
    }
}

- (void)closeAllDatabase
{
    @synchronized (self) {
        [self.databaseList enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull databaseName, CTPersistanceDataBase * _Nonnull database, BOOL * _Nonnull stop) {
            if (database) {
                [database closeDatabase];
            }
        }];
        [self.databaseList removeAllObjects];
    }
}

- (void)closeDatabaseWithFilePath:(NSString *)databaseFilePath
{
    NSParameterAssert(databaseFilePath);

    @synchronized (self) {
        CTPersistanceDataBase *database = self.databaseList[databaseFilePath];

        if (database) {
            [database closeDatabase];
            [self.databaseList removeObjectForKey:databaseFilePath];
        }
    }
}

@end
