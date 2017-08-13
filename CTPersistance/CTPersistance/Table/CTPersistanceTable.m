//
//  CTPersistanceModel.m
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceTable.h"
#import "objc/runtime.h"
#import "CTPersistanceQueryCommand.h"
#import "CTPersistanceQueryCommand+SchemaManipulations.h"
#import "CTPersistanceConfiguration.h"

@interface CTPersistanceTable ()

@property (nonatomic, weak) id<CTPersistanceTableProtocol> child;

@property (nonatomic, strong, readwrite) CTPersistanceQueryCommand *queryCommand;
@property (nonatomic, assign, readwrite) BOOL isFromMigration;

@end

@implementation CTPersistanceTable

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self && [self conformsToProtocol:@protocol(CTPersistanceTableProtocol)]) {
        self.child = (CTPersistanceTable <CTPersistanceTableProtocol> *)self;

        _isFromMigration = NO;
        NSError *error = nil;
        [[self.queryCommand createTable:self.child.tableName columnInfo:self.child.columnInfo] executeWithError:&error];
        if (error) {
            NSLog(@"Error at [%s]:[%d]:%@", __FILE__, __LINE__, error);
        }
    } else {
        NSException *exception = [NSException exceptionWithName:@"CTPersistanceTable init error" reason:@"the child class must conforms to protocol: <CTPersistanceTableProtocol>" userInfo:nil];
        @throw exception;
    }
    
    return self;
}

- (instancetype)initWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand
{
    self = [super init];
    if (self && [self conformsToProtocol:@protocol(CTPersistanceTableProtocol) ]) {
        self.child = (CTPersistanceTable <CTPersistanceTableProtocol> *)self;

        _isFromMigration = YES;
        self.queryCommand = queryCommand;
        NSError *error = nil;
        [[queryCommand createTable:self.child.tableName columnInfo:self.child.columnInfo] executeWithError:&error];
        if (error) {
            NSLog(@"Error at [%s]:[%d]:%@", __FILE__, __LINE__, error);
        }
    } else {
        NSException *exception = [NSException exceptionWithName:@"CTPersistanceTable init error" reason:@"the child class must conforms to protocol: <CTPersistanceTableProtocol>" userInfo:nil];
        @throw exception;
    }

    return self;
}

#pragma mark - public methods
- (BOOL)executeSQL:(NSString *)sqlString error:(NSError *__autoreleasing *)error
{
#warning todo need test
    return [[self.queryCommand compileSqlString:sqlString bindValueList:nil error:error] executeWithError:error];
}

- (NSArray <NSDictionary *> *)fetchWithSQL:(NSString *)sqlString error:(NSError *__autoreleasing *)error
{
#warning todo need test
    return [[self.queryCommand compileSqlString:sqlString bindValueList:nil error:error] fetchWithError:error];
}

#pragma mark - method to override
- (BOOL)isCorrectToInsertRecord:(NSObject <CTPersistanceRecordProtocol> *)record;
{
    return YES;
}

- (BOOL)isCorrectToUpdateRecord:(NSObject <CTPersistanceRecordProtocol> *)record;
{
    return YES;
}

#pragma mark - getters and setters
- (CTPersistanceQueryCommand *)queryCommand
{
    if (_queryCommand == nil) {
        if (self.isFromMigration == NO) {
            _queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:[self.child databaseName]];
        }
    }
    return _queryCommand;
}

@end
