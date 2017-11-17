//
//  ItemRecord.h
//  CTPersistance
//
//  Created by casa on 2017/11/17.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "CTPersistanceRecord.h"

@interface ItemRecord : CTPersistanceRecord

@property (nonatomic, strong) NSNumber *primaryKey;
@property (nonatomic, strong) NSString *name;

@end
