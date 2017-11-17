//
//  ItemDataCenter.h
//  CTPersistance
//
//  Created by casa on 2017/11/17.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "CTPersistance.h"
#import "ItemView.h"

@interface ItemDataCenter : NSObject

- (ItemView *)createNewItem;

- (void)insert:(ItemView *)itemView;

- (void)updateItemFromDataCenter:(ItemView *)itemView;
- (void)updateItemToDataCenter:(ItemView *)itemView;

- (void)deleteItem:(ItemView *)itemView;

@end
