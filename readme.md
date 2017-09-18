pod "CTPersistence"

CTPersistance is a sqlite wrapper which help you to handle with database.

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

Record
======

CTPersistance's record does not have to be a specific object. Any object who conforms to `CTPersistanceRecordProtocol` can be handled by CTPersistance.

That means you can handle any object like `UIView`、`UIViewController` with CTPersistance as long as they conforms to `CTPersistanceRecordProtocol`. For example you can insert a `UIView`, and the fetch the same data as a dictionary or even `UIViewController`.

Though CTPersistance does not require your object to inherit from a specific model, CTPersistance provide you `CTPersistanceRecord` if you still want to inherit some model.

Insert
======

all insert method are declared in `CTPersistanceTable+Insert.h`, here is some example to insert data:

- insert a record

```
UIView<CTPersistanceRecordProtocol> *record = [[TestView alloc] init];
record.nameLabel.text = @"casa";

NSError *error = nil;
[self.testTable insertRecord:record error:&error];
```

- insert some value to testTable

```
NSNumber *primaryKey = [self.testTable insertValue:@"casa" forKey:@"name" error:&error];
```

- insert a list of record

```
NSInteger recordCount = 10;
NSMutableArray <TestRecord *> *recordList = [[NSMutableArray alloc] init];
while (recordCount --> 0) {
    TestRecord *record = [[TestRecord alloc] init];
    record.age = @(recordCount);
    [recordList addObject:record];
}
    
NSError *error = nil;
[self.testTable insertRecordList:recordList error:&error];
```

`CTPersistanceTestInsert.m` shows more detail in insert action.

Update
======

