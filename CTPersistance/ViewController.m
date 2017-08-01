//
//  ViewController.m
//  CTPersistance
//
//  Created by casa on 2017/7/29.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "ViewController.h"

#import <sqlite3.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"database.sqlite"];
//    sqlite3 *database = nil;
//    int result = sqlite3_open_v2([filepath UTF8String],
//                                 &database,
//                                 SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE | SQLITE_OPEN_SHAREDCACHE | SQLITE_OPEN_NOMUTEX
//                                 , NULL);
//    if (result == SQLITE_OK) {
//        NSLog(@"success open");
//    }
//
////    sqlite3_stmt *statement = nil;
////    result = sqlite3_prepare_v2(database, [@"create table `test` (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name text, age integer);" UTF8String], -1, &statement, NULL);
////    if (result == SQLITE_OK) {
////        result = sqlite3_step(statement);
////    }
//
//    sqlite3_stmt *statement = nil;
//    NSString *sqlString =@"insert into `test` values (NULL, @name, @age);";
//    result = sqlite3_prepare_v2(database, [sqlString UTF8String], (int)sqlString.length, &statement, NULL);
//
//    if (result == SQLITE_OK) {
//        sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, "@age"), 10);
//        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, "@name"), "c'sa", 4, SQLITE_TRANSIENT);
//        result = sqlite3_step(statement);
//    }
//
//    if (result == SQLITE_DONE) {
//        sqlite3_finalize(statement);
//    }
//
//    sqlite3_close(database);

//    NSMutableSet *set = [[NSMutableSet alloc] init];
//
//    [set addObject:[NSString stringWithFormat:@"c%@sa", @"a"]];
//    [set addObject:[NSString stringWithFormat:@"%@asa", @"c"]];
//    [set addObject:@"cary"];
//
//    NSLog(@"%@", set);
}


@end
