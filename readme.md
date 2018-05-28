pod "CTPersistance"

`CTPersistance` is a sqlite wrapper which help you to handle with database.

I'm still writing this document, you can check test case for usage.

Async Operation in CTPersistance
================================

`DO NOT USE GCD DIRECTLY`

`DO NOT USE GCD DIRECTLY`

`DO NOT USE GCD DIRECTLY`

CTPersistance provide `CTPersistanceAsyncExecutor` to do the async staff.

read:

```
[[CTPersistanceAsyncExecutor sharedInstance] read:^{
    NSInteger count = COUNT;
    while (count --> 0) {
        TestRecord *record = (TestRecord *)[self.testTable findWithPrimaryKey:@(count) error:NULL];
        NSLog(@"%@", record.primaryKey);
    }
}];
```

write:

```
[[CTPersistanceAsyncExecutor sharedInstance] write:^{
    NSInteger count = COUNT;
    while (count --> 0) {
        NSNumber *primaryKey = [self.testTable insertValue:@"casa" forKey:@"name" error:NULL];
        NSLog(@"%@", primaryKey);
    }
}];
```

see [AsyncTestViewController](https://github.com/casatwy/CTPersistance/blob/master/CTPersistance/Demo/AsyncTestViewController/AsyncTestViewController.m) for demo

run CTPersistance project in Simulator, and `async test` is the live demo for async operation.

Target-Action in CTPersistance
==============================

CTPersistance use [CTMediator](https://github.com/casatwy/CTMediator) to handle how the database migrate, what secret key to encrypt, where to place the database file.

You should create a target, and just put it into your project, no more code and `CTMediator` will call your target.

the different database name should have different target, and the target should conform to protocol `CTPersistanceConfigurationTarget`. 

the name of the target object is based on the name of your database file.for example:

say you have a database file which name is:

```

`aaa.sqlite`, and the target should be `Target_aaa`

`aaa_bbb.sqlite`, and the target should be `Target_aaa`

`aaa_bbb`, and the target should be `Target_aaa`

`aaa.abc.sqlite`, and the target should be `Target_aaa`

`aaa`, and the target should be `Target_aaa`

```

> Available Actions:

- `- (NSString *)Action_filePath:(NSDictionary *)params`

return the absolute file path as you want. The database file name will be send in the params.

If CTPersistance can not call this method, CTPersistance will find database in `[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:databaseName]` folder, if still not found, CTPersistance will create the database file in this path with the database file name.

- `- (CTPersistanceMigrator *)Action_fetchMigrator:(NSDictionary *)params`

return the class name of migrator manager for database migration.

see [Target_MigrationTestDatabase.m:20](https://github.com/casatwy/CTPersistance/blob/master/CTPersistanceTests/ConfigurationTarget/Target_MigrationTestDatabase.m#L20)

- `- (NSArray *)Action_secretKey:(NSDictionary *)params`

return secret key to encrypt the database file.

if you have changed the secret key, keep the old key and append new key in a array and return it.

say you encrypt the database in version 1 (it's the version about your app) by the key `oldkey`, and you changed this key to `newkey` in version 2. Some days later you changed the key to `newkey2` in version3, you should return an array like this:

```
@[
    @"oldkey",
    @"newkey",
    @"newkey2",
]
```

see [Target_TestDatabase.m:13](https://github.com/casatwy/CTPersistance/blob/master/CTPersistanceTests/ConfigurationTarget/Target_TestDatabase.m#L13)

Record
======

CTPersistance's record does not have to be a specific object. Any object who conforms to `CTPersistanceRecordProtocol` can be handled by CTPersistance.

That means you can handle any object like `UIView`、`UIViewController` with CTPersistance as long as they conforms to `CTPersistanceRecordProtocol`. For example you can insert a `UIView`, and fetch the same data as a dictionary or even `UIViewController`.

Though CTPersistance does not require your object to inherit from a specific model, CTPersistance provide you `CTPersistanceRecord` if you do not want to implement the protocol.

CRUD Operations
===============

Create : [see here](https://github.com/casatwy/CTPersistance/blob/master/CTPersistanceTests/CTPersistanceTestInsert.m)

Read : [see here](https://github.com/casatwy/CTPersistance/blob/master/CTPersistanceTests/CTPersistanceTestFind.m)

Update : [see here](https://github.com/casatwy/CTPersistance/blob/master/CTPersistanceTests/CTPersistanceTestUpdate.m)

Delete : [see here](https://github.com/casatwy/CTPersistance/blob/master/CTPersistanceTests/CTPersistanceTestDelete.m)

Upsert : [see here](https://github.com/casatwy/CTPersistance/blob/master/CTPersistanceTests/CTPersistanceTestUpsert.m)

Other Operations
================

Database Migration : [see here](https://github.com/casatwy/CTPersistance/blob/master/CTPersistanceTests/CTPersistanceTestMigration.m)

Index of Columns : [see here](https://github.com/casatwy/CTPersistance/blob/2083a2970c76b5b888b49849eb52cb0183511097/CTPersistanceTests/TestModel/Table/TestTable.m#L67)

Transaction : [see here](https://github.com/casatwy/CTPersistance/blob/master/CTPersistanceTests/CTPersistanceTestTransaction.m)

Change Key of Encryption : [see here](https://github.com/casatwy/CTPersistance/blob/master/CTPersistanceTests/CTPersistanceTestChangeKey.m)
