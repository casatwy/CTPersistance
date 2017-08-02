//
//  CTPersistanceQueryCommand+ReadMethods.m
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceQueryCommand+ReadMethods.h"
#import "CTPersistanceConfiguration.h"
#import <sqlite3.h>

@implementation CTPersistanceQueryCommand (ReadMethods)

- (CTPersistanceQueryCommand *)readWithSQL:(NSString *)sqlString bindValueList:(NSArray *)bindValueList error:(NSError *__autoreleasing *)error
{
    sqlite3_stmt *statement = nil;
    int returnCode = sqlite3_prepare_v2(self.database.database, [sqlString UTF8String], (int)sqlString.length, &statement, NULL);

    if (returnCode != SQLITE_OK && error) {
        const char *errorMsg = sqlite3_errmsg(self.database.database);
        *error = [NSError errorWithDomain:kCTPersistanceErrorDomain code:CTPersistanceErrorCodeQueryStringError userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"\n\n\n======================\nQuery Error: \n Origin Query is : %@\n Error Message is: %@\n======================\n\n\n", sqlString, [NSString stringWithCString:errorMsg encoding:NSUTF8StringEncoding]]}];
        sqlite3_finalize(statement);
        return self;
    }

    self.statement = statement;

    [bindValueList enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull bindInvocation, NSUInteger idx, BOOL * _Nonnull stop) {
        [bindInvocation setArgument:(void *)&statement atIndex:2];
        [bindInvocation invoke];
    }];
    
    return self;
}

@end
