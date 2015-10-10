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

@interface CTPersistanceTable ()

@property (nonatomic, weak) id<CTPersistanceTableProtocol> child;
@property (nonatomic, strong, readwrite) CTPersistanceQueryCommand *queryCommand;

@end

@implementation CTPersistanceTable

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self && [self conformsToProtocol:@protocol(CTPersistanceTableProtocol)]) {
        self.child = (CTPersistanceTable <CTPersistanceTableProtocol> *)self;
    } else {
        NSException *exception = [NSException exceptionWithName:@"CTPersistanceTable init error" reason:@"the child class must conforms to protocol: <CTPersistanceTableProtocol>" userInfo:nil];
        @throw exception;
    }
    
    return self;
}

- (instancetype)initWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand
{
    self = [self init];
    if (self) {
        self.queryCommand = queryCommand;
        if ([self.child respondsToSelector:@selector(modifyDatabaseName:)]) {
            [self.child modifyDatabaseName:queryCommand.database.databaseName];
        }
    }
    return self;
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
        _queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:[self.child databaseName]];
        [[_queryCommand createTable:[self.child tableName] columnInfo:[self.child columnInfo]] executeWithError:NULL];
    }
    return _queryCommand;
}

@end
