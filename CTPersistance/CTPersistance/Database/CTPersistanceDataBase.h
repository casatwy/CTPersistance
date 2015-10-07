//
//  CTPersistanceDataBase.h
//  CTPersistance
//
//  Created by casa on 15/10/4.
//  Copyright © 2015年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface CTPersistanceDataBase : NSObject

@property (nonatomic, assign, readonly) sqlite3 *database;
@property (nonatomic, copy, readonly) NSString *databaseName;
@property (nonatomic, copy, readonly) NSString *databaseFilePath;

- (instancetype)initWithDatabaseName:(NSString *)databaseName error:(NSError **)error;
- (void)closeDatabase;

@end
