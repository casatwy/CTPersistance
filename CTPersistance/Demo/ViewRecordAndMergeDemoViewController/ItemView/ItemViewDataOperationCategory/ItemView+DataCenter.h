//
//  ItemView+DataCenter.h
//  CTPersistance
//
//  Created by casa on 2017/11/17.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "ItemView.h"
#import "CTPersistance.h"

@interface ItemView (DataCenter) <CTPersistanceRecordProtocol>

@property (nonatomic, strong) NSNumber *itemRecordPrimaryKey;
@property (nonatomic, strong) NSNumber *itemDetailRecordPrimaryKey;

@property (nonatomic, strong) NSNumber *primaryKey;

@end
