//
//  TestRecord.h
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistance.h"

@interface TestRecord : CTPersistanceRecord

@property (nonatomic, strong) NSNumber *primaryKey;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSData *avatar;
@property (nonatomic, strong) NSNumber *progress;
@property (nonatomic, strong) NSNumber *isCelebrity;
@property (nonatomic, assign) long long timeStamp;
@property (nonatomic, assign) NSInteger defaultInt;
@property (nonatomic, strong) NSString  *defaultStr;
@property (nonatomic, assign) BOOL      defaultBool;
@property (nonatomic, assign) double    defaultDouble;
@end
