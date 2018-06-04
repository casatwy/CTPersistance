//
//  TestNewRecordVersion.h
//  CTPersistanceTests
//
//  Created by 吴明亮 on 2018/6/4.
//  Copyright © 2018 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTPersistanceRecord.h"

@interface TestNewRecordVersion : CTPersistanceRecord

@property(nonatomic, copy) NSNumber *primaryKey;
@property(nonatomic, copy) NSString *version1;
@property(nonatomic, copy) NSString *version2;

@end
