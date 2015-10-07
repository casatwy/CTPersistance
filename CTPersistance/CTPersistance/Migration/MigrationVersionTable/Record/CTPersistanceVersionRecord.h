//
//  CTPersistanceVersionRecord.h
//  CTPersistance
//
//  Created by casa on 15/10/7.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceRecord.h"

@interface CTPersistanceVersionRecord : CTPersistanceRecord

@property (nonatomic, copy) NSNumber *identifier;
@property (nonatomic, copy) NSString *databaseVersion;

@end
