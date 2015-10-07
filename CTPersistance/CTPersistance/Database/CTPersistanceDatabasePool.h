//
//  CTPersistanceContext.h
//  CTPersistance
//
//  Created by casa on 15/10/3.
//  Copyright © 2015年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTPersistanceDataBase.h"

@interface CTPersistanceDatabasePool : NSObject

+ (instancetype)sharedInstance;

- (CTPersistanceDataBase *)databaseWithName:(NSString *)databaseName;
- (void)closeDatabaseWithName:(NSString *)databaseName;
- (void)closeAllDatabase;

@end
