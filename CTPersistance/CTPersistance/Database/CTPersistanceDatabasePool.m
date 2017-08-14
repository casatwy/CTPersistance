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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNSThreadWillExitNotification:) name:NSThreadWillExitNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self closeAllDatabase];
}

- (CTPersistanceDataBase *)databaseWithName:(NSString *)databaseName
{
    if (databaseName == nil) {
        return nil;
    }

    @synchronized (self) {
        NSString *key = [NSString stringWithFormat:@"%@ - %@", [NSThread currentThread], databaseName];
        CTPersistanceDataBase *databaseInstance = self.databaseList[key];
        if (databaseInstance == nil) {
            NSError *error = nil;
            databaseInstance = [[CTPersistanceDataBase alloc] initWithDatabaseName:databaseName error:&error];
            if (error) {
                NSLog(@"Error at %s:[%d]:%@", __FILE__, __LINE__, error);
            } else {
                self.databaseList[key] = databaseInstance;
            }
        }
        
        return databaseInstance;
    }
}

- (void)closeAllDatabase
{
    @synchronized (self) {
        [self.databaseList enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull databaseName, CTPersistanceDataBase * _Nonnull database, BOOL * _Nonnull stop) {
            if ([database isKindOfClass:[CTPersistanceDataBase class]]) {
                [database closeDatabase];
            }
        }];
        [self.databaseList removeAllObjects];
    }
}

- (void)closeDatabaseWithName:(NSString *)databaseName
{
    CTPersistanceDataBase *database = self.databaseList[databaseName];
    [database closeDatabase];
    [self.databaseList removeObjectForKey:databaseName];
}

#pragma mark - event response
- (void)didReceiveNSThreadWillExitNotification:(NSNotification *)notification
{
    [self.databaseList enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, CTPersistanceDataBase * _Nonnull database, BOOL * _Nonnull stop) {
        if ([key containsString:[NSString stringWithFormat:@"%@", [NSThread currentThread]]]) {
            [database closeDatabase];
            *stop = YES;
        }
    }];
}

@end
