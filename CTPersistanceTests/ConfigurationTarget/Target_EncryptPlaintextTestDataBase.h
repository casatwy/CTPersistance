//
//  Target_EncryptPlaintextTestDataBase.h
//  CTPersistanceTests
//
//  Created by 周中广 on 2019/3/8.
//  Copyright © 2019 casa. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CTPersistance.h"

NS_ASSUME_NONNULL_BEGIN

@interface Target_EncryptPlaintextTestDataBase : NSObject <CTPersistanceConfigurationTarget>

/**
 secret key to encrypt the database, return nil means no encryption.
 
 @param params params is a dictionary, with key kCTPersistanceConfigurationParamsKeyDatabaseName to tell you the database name
 @return secret key
 */
- (NSArray *)Action_secretKey:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
