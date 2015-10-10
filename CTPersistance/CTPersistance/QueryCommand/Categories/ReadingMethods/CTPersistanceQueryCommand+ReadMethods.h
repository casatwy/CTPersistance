//
//  CTPersistanceQueryCommand+ReadMethods.h
//  CTPersistance
//
//  Created by casa on 15/10/5.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTPersistanceQueryCommand.h"

@interface CTPersistanceQueryCommand (ReadMethods)

/**
 *  create SELECT part of SQL.
 *
 *  You should never use this method directly, use Find methods in CTPersistanceTable instead.
 *
 *  @param columList  SELECT column list
 *  @param isDistinct if YES, will use SELECT DISTINCT when generating SQL
 *
 *  @return return CTPersistanceQueryCommand
 */
- (CTPersistanceQueryCommand *)select:(NSString *)columList isDistinct:(BOOL)isDistinct;

/**
 *  create FROM part of SQL.
 *
 *  You should never use this method directly, use Find methods in CTPersistanceTable instead.
 *
 *  @param fromList FROM part in SQL
 *
 *  @return return CTPersistanceQueryCommand
 */
- (CTPersistanceQueryCommand *)from:(NSString *)fromList;

/**
 *  create WHERE part of SQL.
 *
 *  You should never use this method directly, use Find methods in CTPersistanceTable instead.
 *
 *  @param condition where condition
 *  @param params    params for where condition
 *
 *  @return return CTPersistanceQueryCommand
 *
 *  @warning You should never use this method directly, use insert methods in CTPersistanceTable instead
 *
 */
- (CTPersistanceQueryCommand *)where:(NSString *)condition params:(NSDictionary *)params;

/**
 *  create ORDER BY part of SQL
 *
 *  You should never use this method directly, use Find methods in CTPersistanceTable instead.
 *
 *  @param orderBy ORDER BY part of SQL
 *  @param isDESC  if YES, use DESC, if NO, use ASC
 *
 *  @return return CTPersistanceQueryCommand
 *
 *  @warning You should never use this method directly, use insert methods in CTPersistanceTable instead
 *
 */
- (CTPersistanceQueryCommand *)orderBy:(NSString *)orderBy isDESC:(BOOL)isDESC;

/**
 *  create LIMIT part of SQL
 *
 *  You should never use this method directly, use Find methods in CTPersistanceTable instead.
 *
 *  @param limit limit count
 *
 *  @return return CTPersistanceQueryCommand
 *
 *  @warning You should never use this method directly, use insert methods in CTPersistanceTable instead
 *
 */
- (CTPersistanceQueryCommand *)limit:(NSInteger)limit;

/**
 *  create OFFSET part of SQL
 *
 *  You should never use this method directly, use Find methods in CTPersistanceTable instead.
 *
 *  @param offset offset
 *
 *  @return return CTPersistanceQueryCommand
 *
 *  @warning You should never use this method directly, use insert methods in CTPersistanceTable instead
 *
 */
- (CTPersistanceQueryCommand *)offset:(NSInteger)offset;

/**
 *  Handy method to create LIMIT and OFFSET part of SQL
 *
 *  You should never use this method directly, use Find methods in CTPersistanceTable instead.
 *
 *  @param limit  limit count
 *  @param offset offset
 *
 *  @return return CTPersistanceQueryCommand
 *
 *  @warning You should never use this method directly, use insert methods in CTPersistanceTable instead
 *
 */
- (CTPersistanceQueryCommand *)limit:(NSInteger)limit offset:(NSInteger)offset;

@end
