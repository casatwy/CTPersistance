//
//  CTPersistanceContext.m
//  CTPersistance
//
//  Created by casa on 15/10/3.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceDatabasePool.h"
#import "CTPersistanceDataBase.h"
#import <CTMediator/CTMediator.h>

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

- (CTPersistanceDataBase *)databaseWithName:(NSString *)databaseName swiftModuleName:(NSString *)swiftModuleName
{
    if (databaseName == nil) {
        return nil;
    }

    @synchronized (self) {
        NSString *key = [NSString stringWithFormat:@"%@ - %@", [NSThread currentThread], [self filePathWithDatabaseName:databaseName swiftModuleName:swiftModuleName]];
        CTPersistanceDataBase *databaseInstance = self.databaseList[key];
        if (databaseInstance == nil) {
            NSError *error = nil;
            databaseInstance = [[CTPersistanceDataBase alloc] initWithDatabaseName:databaseName swiftModuleName:swiftModuleName error:&error];
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
        [self.databaseList enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, CTPersistanceDataBase * _Nonnull database, BOOL * _Nonnull stop) {
            if ([database isKindOfClass:[CTPersistanceDataBase class]]) {
                [database closeDatabase];
            }
        }];
        [self.databaseList removeAllObjects];
    }
}

- (void)closeDatabaseWithName:(NSString *)databaseName swiftModuleName:(NSString *)swiftModuleName
{
    @synchronized (self) {
        NSArray <NSString *> *allKeys = [self.databaseList.allKeys copy];
        [allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([key containsString:[NSString stringWithFormat:@" - %@", [self filePathWithDatabaseName:databaseName swiftModuleName:swiftModuleName]]]) {
                CTPersistanceDataBase *database = self.databaseList[key];
                [database closeDatabase];
                [self.databaseList removeObjectForKey:databaseName];
            }
        }];
    }
}

#pragma mark - event response
- (void)didReceiveNSThreadWillExitNotification:(NSNotification *)notification
{
    @synchronized (self) {
        // 检查ownership计数
        NSMutableDictionary <NSString *, NSNumber *> *ownershipCount = [[NSMutableDictionary alloc] init];
        [self.databaseList enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, CTPersistanceDataBase * _Nonnull database, BOOL * _Nonnull stop) {
            NSNumber *count = ownershipCount[database.databaseName];
            if (count == nil) {
                count = @(1);
            } else {
                NSInteger intCount = count.integerValue + 1;
                count = @(intCount);
            }
            ownershipCount[database.databaseName] = count;
        }];
        
        // 准备关闭ownershipCount为1且当前操作线程已经退出的数据库
        NSMutableArray <CTPersistanceDataBase *> *databaseToClose = [[NSMutableArray alloc] init];
        NSMutableArray <NSString *> *keyToDelete = [[NSMutableArray alloc] init];
        [self.databaseList enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, CTPersistanceDataBase * _Nonnull database, BOOL * _Nonnull stop) {
            NSNumber *count = ownershipCount[database.databaseName];
            if (count.integerValue == 1 && [key containsString:[NSString stringWithFormat:@"%@", [NSThread currentThread]]]) {
                [databaseToClose addObject:database];
                [keyToDelete addObject:key];
            }
        }];
    
        // 关闭数据库
        [databaseToClose makeObjectsPerformSelector:@selector(closeDatabase)];
        [keyToDelete enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.databaseList removeObjectForKey:key];
        }];
    }
}

#pragma mark - private methods
- (NSString *)filePathWithDatabaseName:(NSString *)databaseName swiftModuleName:(NSString *)swiftModuleName
{
    NSString *target = [[[[databaseName componentsSeparatedByString:@"_"] firstObject] componentsSeparatedByString:@"."] firstObject];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[kCTPersistanceConfigurationParamsKeyDatabaseName] = databaseName;
    params[kCTMediatorParamsKeySwiftTargetModuleName] = swiftModuleName;
    NSString *databaseFilePath = [[CTMediator sharedInstance] performTarget:target
                                                                     action:@"filePath"
                                                                     params:@{kCTPersistanceConfigurationParamsKeyDatabaseName:databaseName}
                                                          shouldCacheTarget:NO];
    if (databaseFilePath == nil) {
        databaseFilePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:databaseName];
    }
    
    return databaseFilePath;
}

@end
