//
//  VIewRecordAndMergeDemoViewController.m
//  CTPersistance
//
//  Created by casa on 2017/11/17.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "ViewRecordAndMergeDemoViewController.h"
#import "ItemView.h"
#import "ItemDataCenter.h"
#import <HandyFrame/UIView+LayoutMethods.h>

@interface ViewRecordAndMergeDemoViewController ()

@property (nonatomic, strong) ItemView *itemView;
@property (nonatomic, strong) ItemDataCenter *dataCenter;

@property (nonatomic, strong) UIButton *updateDataFromDataCenter;

@end

@implementation ViewRecordAndMergeDemoViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.itemView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.itemView fill];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"update item to data center");
    self.itemView.name = @"car";
    self.itemView.detail = @"this is a vary fast car";
    [self.dataCenter updateItemToDataCenter:self.itemView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"update item from data center");
        [self.dataCenter updateItemFromDataCenter:self.itemView];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"delete item");
        [self.dataCenter deleteItem:self.itemView];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"insert item");
        self.itemView.name = @"hello, world!";
        self.itemView.detail = @"I am a new item now!";
        [self.dataCenter insert:self.itemView];
    });
}

#pragma mark - getters and setters
- (ItemDataCenter *)dataCenter
{
    if (_dataCenter == nil) {
        _dataCenter = [[ItemDataCenter alloc] init];
    }
    return _dataCenter;
}

- (ItemView *)itemView
{
    if (_itemView == nil) {
        _itemView = [self.dataCenter createNewItem];
    }
    return _itemView;
}

@end
