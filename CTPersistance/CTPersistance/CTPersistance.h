//
//  CTPersistance.h
//  CTPersistance
//
//  Created by casa on 15/10/3.
//  Copyright © 2015年 casa. All rights reserved.
//

#ifndef CTPersistance_h
#define CTPersistance_h

#import "CTPersistanceConfiguration.h"
#import "CTPersistanceMarcos.h"

#import "CTPersistanceDatabasePool.h"
#import "CTPersistanceMigrator.h"
#import "CTPersistanceCriteria.h"

#import "CTPersistanceDataBase.h"

#import "CTPersistanceRecordProtocol.h"
#import "CTPersistanceRecord.h"

#import "CTPersistanceTable.h"
#import "CTPersistanceTable+Find.h"
#import "CTPersistanceTable+Delete.h"
#import "CTPersistanceTable+Insert.h"
#import "CTPersistanceTable+Update.h"
#import "CTPersistanceTable+Transaction.h"

#import "CTPersistanceQueryCommand.h"
#import "CTPersistanceQueryCommand+ReadMethods.h"
#import "CTPersistanceQueryCommand+DataManipulations.h"
#import "CTPersistanceQueryCommand+SchemaManipulations.h"

extern NSString * const kCTPersistanceDataBaseCheckMigrationNotification;

#endif /* CTPersistance_h */
