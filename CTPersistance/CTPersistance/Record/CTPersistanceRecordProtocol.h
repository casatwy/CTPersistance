//
//  CTPersistanceRecordProtocol.h
//  CTPersistance
//
//  Created by casa on 15/10/6.
//  Copyright © 2015年 casa. All rights reserved.
//

#ifndef CTPersistanceRecordProtocol_h
#define CTPersistanceRecordProtocol_h

#import <Foundation/Foundation.h>

@protocol CTPersistanceRecordProtocol <NSObject>

@required
- (NSDictionary *)dictionaryRepresentation;
- (void)objectRepresentationWithDictionary:(NSDictionary *)dictionary;
- (void)setPersistanceValue:(id)value forKey:(NSString *)key;

@end

#endif /* CTPersistanceRecordProtocol_h */
