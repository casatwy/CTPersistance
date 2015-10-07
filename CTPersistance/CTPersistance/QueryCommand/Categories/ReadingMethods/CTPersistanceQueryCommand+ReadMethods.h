//
//  CTPersistanceQueryCommand+ReadMethods.h
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceQueryCommand.h"

@interface CTPersistanceQueryCommand (ReadMethods)

- (CTPersistanceQueryCommand *)select:(NSString *)columList isDistinct:(BOOL)isDistinct;
- (CTPersistanceQueryCommand *)from:(NSString *)fromList;
- (CTPersistanceQueryCommand *)where:(NSString *)condition params:(NSDictionary *)params;
- (CTPersistanceQueryCommand *)orderBy:(NSString *)orderBy isDESC:(BOOL)isDESC;
- (CTPersistanceQueryCommand *)limit:(NSInteger)limit;
- (CTPersistanceQueryCommand *)offset:(NSInteger)offset;
- (CTPersistanceQueryCommand *)limit:(NSInteger)limit offset:(NSInteger)offset;

@end
