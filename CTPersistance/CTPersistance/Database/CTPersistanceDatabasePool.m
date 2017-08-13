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

@property (nonatomic, strong) NSMutableDictionary *databaseList;

@end

@implementation CTPersistanceDatabasePool

#pragma mark - life cycle
- (void)dealloc
{
    [self closeAllDatabase];
}

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

- (CTPersistanceDataBase *)databaseWithName:(NSString *)databaseName
{
    if (databaseName == nil) {
        return nil;
    }

    NSString *key = [NSString stringWithFormat:@"%@ - %@", [NSThread currentThread], databaseName];
    if (self.databaseList[key] == nil) {
        NSError *error = nil;
        CTPersistanceDataBase *databaseInstance = [[CTPersistanceDataBase alloc] initWithDatabaseName:databaseName error:&error];
        if (error) {
            NSLog(@"Error at %s:[%d]:%@", __FILE__, __LINE__, error);
        } else {
            self.databaseList[key] = databaseInstance;
        }
    }
    
    return self.databaseList[key];
}

- (void)closeAllDatabase
{
    [self.databaseList enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull databaseName, CTPersistanceDataBase * _Nonnull database, BOOL * _Nonnull stop) {
        if ([database isKindOfClass:[CTPersistanceDataBase class]]) {
            [database closeDatabase];
        }
    }];
    [self.databaseList removeAllObjects];
}

- (void)closeDatabaseWithName:(NSString *)databaseName
{
    CTPersistanceDataBase *database = self.databaseList[databaseName];
    [database closeDatabase];
    [self.databaseList removeObjectForKey:databaseName];
}

#pragma mark - getters and setters
- (NSMutableDictionary *)databaseList
{
    if (_databaseList == nil) {
        _databaseList = [[NSMutableDictionary alloc] init];
    }
    return _databaseList;
}

@end
