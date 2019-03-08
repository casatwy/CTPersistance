//
//  Target_EncryptPlaintextTestDataBase.m
//  CTPersistanceTests
//
//  Created by 周中广 on 2019/3/8.
//  Copyright © 2019 casa. All rights reserved.
//

#import "Target_EncryptPlaintextTestDataBase.h"

extern NSString * const kCTPersistanceEncryptKey;

@implementation Target_EncryptPlaintextTestDataBase

/**
 secret key to encrypt the database, return nil means no encryption.
 
 @param params params is a dictionary, with key kCTPersistanceConfigurationParamsKeyDatabaseName to tell you the database name
 @return secret key
 */
- (NSArray *)Action_secretKey:(NSDictionary *)params
{
    BOOL encrypt = [[NSUserDefaults standardUserDefaults] boolForKey:kCTPersistanceEncryptKey];

    if (!encrypt) {// no encryption , will create a plaintext database
        return nil;
    } else {// convert an existing plaintext database to an encrypted database
        return @[@"oneSecretKey"];
    }
}

@end
