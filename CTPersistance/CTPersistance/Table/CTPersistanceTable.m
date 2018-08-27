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

NSString * const kCTPersistanceTableIndexName = @"kCTPersistanceTableIndexName";
NSString * const kCTPersistanceTableIndexedColumnList = @"kCTPersistanceTableIndexedColumnList";
NSString * const kCTPersistanceTableIndexIsUniq = @"kCTPersistanceTableIndexIsUniq";

@interface CTPersistanceTable ()

@property (nonatomic, assign, readwrite) BOOL isSwift;
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
        
        _isFromMigration = NO;
        self.child = (CTPersistanceTable <CTPersistanceTableProtocol> *)self;
        if ([self.child respondsToSelector:@selector(swiftModuleName)]) {
            NSString *swiftModuleName = [self.child swiftModuleName];
            if (swiftModuleName.length > 0) {
                _isSwift = YES;
            } else {
                _isSwift = NO;
            }
        }
        [self configTable:self.queryCommand];
        
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
        
        _isFromMigration = YES;
        
        self.child = (CTPersistanceTable <CTPersistanceTableProtocol> *)self;
        self.queryCommand = queryCommand;

        [self configTable:queryCommand];
        
    } else {
        NSException *exception = [NSException exceptionWithName:@"CTPersistanceTable init error" reason:@"the child class must conforms to protocol: <CTPersistanceTableProtocol>" userInfo:nil];
        @throw exception;
    }

    return self;
}

- (void)configTable:(CTPersistanceQueryCommand *)queryCommand
{
    __block NSError *error = nil;

    // create table if not exists
    if(self.child.columnDetaultValue) {
        [[queryCommand createTable:self.child.tableName columnInfo:self.child.columnInfo columnDefaultValue:self.child.columnDetaultValue error:&error] executeWithError:&error];
    } else {
        [[queryCommand createTable:self.child.tableName columnInfo:self.child.columnInfo error:&error] executeWithError:&error];
    }
    
    // create index if not exists
    if (error == nil) {
        [self.child.indexList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[queryCommand createIndex:obj[kCTPersistanceTableIndexName]
                             tableName:self.child.tableName
                     indexedColumnList:obj[kCTPersistanceTableIndexedColumnList]
                              isUnique:[obj[kCTPersistanceTableIndexIsUniq] boolValue]
                                 error:&error
              ] executeWithError:&error];
            if (error) {
                *stop = YES;
            }
        }];
    }
    
    if (error) {
        NSLog(@"Error at [%s]:[%d]:%@", __FILE__, __LINE__, error);
    }
}

#pragma mark - public methods
- (BOOL)executeSQL:(NSString *)sqlString error:(NSError *__autoreleasing *)error
{
    return [[self.queryCommand compileSqlString:sqlString bindValueList:nil error:error] executeWithError:error];
}

- (NSArray <NSDictionary *> *)fetchWithSQL:(NSString *)sqlString error:(NSError *__autoreleasing *)error
{
    return [[self.queryCommand compileSqlString:sqlString bindValueList:nil error:error] fetchWithError:error];
}

#pragma mark - method to override
-(NSDictionary *)columnDetaultValue {
    return nil;
}

- (NSArray <NSDictionary *> *)indexList
{
    return nil;
}

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
    if (_queryCommand == nil && self.isFromMigration == NO) {
        NSString *swiftModuleName = nil;
        if ([self.child respondsToSelector:@selector(swiftModuleName)]) {
            swiftModuleName = [self.child swiftModuleName];
        }
        _queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:[self.child databaseName] swiftModuleName:swiftModuleName];
    }
    return _queryCommand;
}


@end
