//
//  CTPersistanceVersionRecord.h
//  CTPersistance
//
//  Created by casa on 15/10/7.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceRecord.h"

/**
 *  this record is used for Migration
 *
 *  You should never use or create this object
 */
@interface CTPersistanceVersionRecord : CTPersistanceRecord

/**
 *  primary key of record in database
 */
@property (nonatomic, copy) NSNumber *identifier;

/**
 *  version key of record in database
 */
@property (nonatomic, copy) NSString *databaseVersion;

@end
