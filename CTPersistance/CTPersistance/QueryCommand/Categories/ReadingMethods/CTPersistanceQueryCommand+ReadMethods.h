//
//  CTPersistanceQueryCommand+ReadMethods.h
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceQueryCommand.h"

@interface CTPersistanceQueryCommand (ReadMethods)

- (CTPersistanceQueryCommand *)readWithSQL:(NSString *)sqlString bindValueList:(NSArray *)bindValueList error:(NSError **)error;

@end
