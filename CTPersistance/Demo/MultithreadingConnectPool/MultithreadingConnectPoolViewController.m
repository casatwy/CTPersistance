//
//  MultithreadingConnectPoolViewController.m
//  CTPersistance
//
//  Created by 吴明亮 on 2018/5/8.
//  Copyright © 2018 casa. All rights reserved.
//

#import "MultithreadingConnectPoolViewController.h"
#import "TestTable.h"
#import "TestRecord.h"

@interface MultithreadingConnectPoolViewController ()

@property (nonatomic, strong) TestTable *testTable;

@end

@implementation MultithreadingConnectPoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];


    [self.testTable truncate];

    // Main Thread
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error = nil;

        TestRecord *record = [[TestRecord alloc] init];
        record.name = @"casa";
        [self.testTable insertRecord:record error:&error];

        NSLog(@"主线程队列");
        if (error) {
            NSLog(@"链接池错误");
        }
    });

    // 任务队列的创建
    dispatch_queue_t mySerialDispatchQueue = dispatch_queue_create("com.ct.serial",NULL);
    dispatch_async(mySerialDispatchQueue, ^{
        NSError *error = nil;
        TestRecord *record = [[TestRecord alloc] init];
        record.name = @"casa1";
        [self.testTable insertRecord:record error:&error];

        NSLog(@"串性队列");
        if (error) {
            NSLog(@"链接池错误");
        }
    });

    dispatch_queue_t myConcurrentDispatchQueue = dispatch_queue_create("com.ct.con",DISPATCH_QUEUE_CONCURRENT);

    dispatch_async(myConcurrentDispatchQueue, ^{
        NSError *error = nil;
        TestRecord *record = [[TestRecord alloc] init];
        record.name = @"casa2";
        [self.testTable insertRecord:record error:&error];

        NSLog(@"并发队列");
        if (error) {
            NSLog(@"链接池错误");
        }
    });

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
