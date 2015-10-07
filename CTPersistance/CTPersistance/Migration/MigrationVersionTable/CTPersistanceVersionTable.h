//
//  CTPersistanceTableVersion.h
//  CTPersistance
//
//  Created by casa on 15/10/7.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceTable.h"
#import "CTPersistanceDataBase.h"

@interface CTPersistanceVersionTable : CTPersistanceTable <CTPersistanceTableProtocol>

- (instancetype)initWithDatabase:(CTPersistanceDataBase *)database;

@end
