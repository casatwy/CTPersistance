//
//  CTPersistanceConfiguration.h
//  CTPersistance
//
//  Created by casa on 15/10/3.
//  Copyright © 2015年 casa. All rights reserved.
//

#ifndef CTPersistanceConfiguration_h
#define CTPersistanceConfiguration_h

#import <Foundation/Foundation.h>

static NSString * kCTPersistanceErrorDomain = @"kCTPersistanceErrorDomain";

typedef NS_ENUM (NSUInteger, CTPersistanceErrorCode) {
    CTPersistanceErrorCodeOpenError,
    CTPersistanceErrorCodeCreateError,
    CTPersistanceErrorCodeQueryStringError,
};

static NSString * kCTPersistanceVersionTableName = @"kCTPersistanceVersionTableName";
static NSString * kCTPersistanceInitVersion = @"kCTPersistanceInitVersion";

static NSInteger CTPersistanceNoLimit = -1;
static NSInteger CTPersistanceNoOffset = -1;

static NSString * kCTPersisatanceConfigurationFileName = @"CTPersistanceConfiguration";

#endif /* CTPersistanceConfiguration_h */
