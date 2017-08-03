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

static NSString * const kCTPersistanceErrorDomain = @"kCTPersistanceErrorDomain";

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
     *  record is not available to INSERT
     */
    CTPersistanceErrorCodeRecordNotAvailableToInsert,
    /**
     *  record is not available to UPDATE
     */
    CTPersistanceErrorCodeRecordNotAvailableToUpdate,
    /**
     *  failed to set key for value in record
     */
    CTPersistanceErrorCodeFailedToSetKeyForValue,
};

static NSString * const kCTPersistanceErrorUserinfoKeyErrorRecord = @"kCTPersistanceErrorUserinfoKeyErrorRecord";

static NSString * const kCTPersistanceVersionTableName = @"kCTPersistanceVersionTableName";


static NSInteger const CTPersistanceNoLimit = -1;
static NSInteger const CTPersistanceNoOffset = -1;

static NSString * const kCTPersisatanceConfigurationFileName = @"CTPersistanceConfiguration";

#endif /* CTPersistanceConfiguration_h */
