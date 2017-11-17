//
//  ItemView.m
//  CTPersistance
//
//  Created by casa on 2017/11/17.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "ItemView.h"
#import <HandyFrame/UIView+LayoutMethods.h>

@interface ItemView ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation ItemView

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.thisPropertyWillNotBeSaved = @"this property will not be saved if you send this view to data center for inserting";
        
        [self addSubview:self.nameLabel];
        [self addSubview:self.detailLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.nameLabel sizeToFit];
    [self.nameLabel centerEqualToView:self];
    
    [self.detailLabel sizeToFit];
    [self.detailLabel top:5 FromView:self.nameLabel];
    [self.detailLabel centerXEqualToView:self];
}

#pragma mark - getters and setters
- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:20];
        _nameLabel.textColor = [UIColor redColor];
    }
    return _nameLabel;
}

- (UILabel *)detailLabel
{
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:15];
        _detailLabel.textColor = [UIColor blackColor];
    }
    return _detailLabel;
}

- (void)setName:(NSString *)name
{
    _name = name;
    self.nameLabel.text = name;
}

- (void)setDetail:(NSString *)detail
{
    _detail = detail;
    self.detailLabel.text = detail;
}

@end
