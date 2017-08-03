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
        CTPersistanceQueryCommand *queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:self.child.databaseName];
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
    if (self.isFromMigration == NO) {
        self.queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:[self.child databaseName]];
    }
    
    sqlite3_stmt *statement = nil;
    int result = sqlite3_prepare_v2(self.queryCommand.database.database, [sqlString UTF8String], (int)sqlString.length, &statement, NULL);
    if (result != SQLITE_OK) {
        NSString *errorMessage = [NSString stringWithUTF8String:sqlite3_errmsg(self.queryCommand.database.database)];
        NSError *generatedError = [NSError errorWithDomain:kCTPersistanceErrorDomain code:CTPersistanceErrorCodeQueryStringError userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"\n======================\nQuery Error: \n Origin Query is : %@\n Error Message is: %@\n======================\n", [NSString stringWithUTF8String:sqlite3_sql(statement)], errorMessage]}];
        *error = generatedError;
        NSLog(@"error is %@", errorMessage);
        sqlite3_finalize(statement);
        return NO;
    }
    self.queryCommand.statement = statement;
    
    return [self.queryCommand executeWithError:error];
}

- (NSArray <NSDictionary *> *)fetchWithSQL:(NSString *)sqlString error:(NSError *__autoreleasing *)error
{
#warning todo need test
    if (self.isFromMigration == NO) {
        self.queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:[self.child databaseName]];
    }

    sqlite3_stmt *statement = nil;
    int result = sqlite3_prepare_v2(self.queryCommand.database.database, [sqlString UTF8String], (int)sqlString.length, &statement, NULL);
    if (result != SQLITE_OK) {
        NSString *errorMessage = [NSString stringWithUTF8String:sqlite3_errmsg(self.queryCommand.database.database)];
        NSError *generatedError = [NSError errorWithDomain:kCTPersistanceErrorDomain code:CTPersistanceErrorCodeQueryStringError userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"\n======================\nQuery Error: \n Origin Query is : %@\n Error Message is: %@\n======================\n", [NSString stringWithUTF8String:sqlite3_sql(statement)], errorMessage]}];
        *error = generatedError;
        NSLog(@"error is %@", errorMessage);
        sqlite3_finalize(statement);
        return nil;
    }
    self.queryCommand.statement = statement;
    
    return [self.queryCommand fetchWithError:error];
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

@end
