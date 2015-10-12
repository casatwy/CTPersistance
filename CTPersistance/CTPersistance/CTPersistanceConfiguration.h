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

/**
 *  error code in CTPersistance
 */
typedef NS_ENUM(NSUInteger, CTPersistanceErrorCode){
    /**
     *  failed to open database file
     */
    CTPersistanceErrorCodeOpenError,
    /**
     *  failed to create database file
     */
    CTPersistanceErrorCodeCreateError,
    /**
     *  failed to execute SQL
     */
    CTPersistanceErrorCodeQueryStringError,
    /**
     *  there is no change for INSERT or UPDATE
     */
    CTPersistanceErrorCodeQueryStringNoChanges,
};

static NSString * kCTPersistanceErrorUserinfoKeyExecutedSQL = @"Executed SQL: ";
static NSString * kCTPersistanceErrorUserinfoKeyDescription = @"Description: ";

static NSString * kCTPersistanceVersionTableName = @"kCTPersistanceVersionTableName";
static NSString * kCTPersistanceInitVersion = @"kCTPersistanceInitVersion";

static NSInteger CTPersistanceNoLimit = -1;
static NSInteger CTPersistanceNoOffset = -1;

static NSString * kCTPersisatanceConfigurationFileName = @"CTPersistanceConfiguration";

#endif /* CTPersistanceConfiguration_h */
