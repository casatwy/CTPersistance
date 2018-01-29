//
//  NSDictionary+KeyValueBind.h
//  CTPersistance
//
//  Created by casa on 2017/8/4.
//  Copyright © 2017年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (KeyValueBind)

- (NSString *)bindToValueList:(NSMutableArray <NSInvocation *> *)bindValueList;
- (NSString *)bindToUpdateValueList:(NSMutableArray <NSInvocation *> *)bindUpdateValueList;

@end
