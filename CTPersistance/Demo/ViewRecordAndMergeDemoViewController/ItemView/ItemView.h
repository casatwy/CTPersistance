//
//  ItemView.h
//  CTPersistance
//
//  Created by casa on 2017/11/17.
//  Copyright © 2017年 casa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemView : UIView 

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *detail;

@property (nonatomic, strong) NSString *thisPropertyWillNotBeSaved;

@end
