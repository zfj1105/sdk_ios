//
//  InputTextView.m
//  HTGUniteSDK
//
//  Created by zhangfujun on 2018/4/12.
//  Copyright © 2018年 haitui. All rights reserved.
//

#import "InputTextView.h"

@implementation InputTextView

- (instancetype)init
{
    if (self = [super init]) {
        [self initSubviews];
        
        [self layoutSubviews];
    }
    return self;
}

- (void)initSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.layer.cornerRadius = 4;
    
    self.layer.masksToBounds = YES;

    [self addSubview:self.leftLabel];
    
    [self addSubview:self.textField];
    
    [self addSubview:self.rightButton];
    
    [self addSubview:self.hiddenPswButton];
    
    [self addSubview:self.countDownButton];
    
    [self addSubview:self.arrowXButton];
    
    
}

- (void)layoutSubviews
{
    [self.leftLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.left.equalTo(self).offset(5);
    }];
    
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.leftLabel.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(250, 40));
    }];
    
    [self.rightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 25));
        make.right.equalTo(self).offset(-5);
    }];
    
    [self.hiddenPswButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.right.equalTo(self.rightButton.mas_left).offset(0);
    }];
    
    [self.countDownButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(70, 25));
        make.right.equalTo(self).offset(-5);
    }];
    
    [self.arrowXButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(13, 13));
        make.right.equalTo(self).offset(-10);
    }];
}
#pragma mark - 懒加载

- (UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        
        _leftLabel.textColor = [UIColor colorWithHex:@"#bebebe"];
        
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        
        _leftLabel.font = KICON_FONT_(14);
        
    }
    return _leftLabel;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [UITextField new];
        
        _textField.backgroundColor = [UIColor clearColor];
                
        _textField.font = [UIFont systemFontOfSize:13];
        
        _textField.clearButtonMode=UITextFieldViewModeWhileEditing;
        
    }
    return _textField;
}

- (UIButton *)hiddenPswButton
{
    if (!_hiddenPswButton) {
        _hiddenPswButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _hiddenPswButton.backgroundColor = [UIColor clearColor];
        
        [_hiddenPswButton setTitle:@"\U0000e6b1" forState:UIControlStateNormal];
        
        [_hiddenPswButton setTitle:@"\U0000e60e" forState:UIControlStateSelected];
        
        [_hiddenPswButton setTitleColor:[UIColor colorWithHex:@"#B7B7B7"] forState:UIControlStateNormal];
        
        [_hiddenPswButton setTitleColor:[UIColor colorWithHex:@"#78D8AF"] forState:UIControlStateSelected];
        
        _hiddenPswButton.hidden = YES;
        
        _hiddenPswButton.titleLabel.font = KICON_FONT_(20);
        
    }
    return _hiddenPswButton;
}


- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _rightButton.backgroundColor = [UIColor clearColor];
        
        [_rightButton setTitle:kTextGetPhoneMessage forState:UIControlStateNormal];
        
        [_rightButton setTitleColor:[UIColor colorWithHex:@"#78D8AF"] forState:UIControlStateNormal];
        
        _rightButton.layer.cornerRadius = 4;
        
        _rightButton.layer.borderWidth = 1;
        
        _rightButton.hidden = YES;
        
        _rightButton.layer.borderColor = [UIColor colorWithHex:@"#78D8AF"].CGColor;
        
        _rightButton.layer.masksToBounds = YES;
        
        _rightButton.titleLabel.font = KSYSTEM_FONT_(12);
        
    }
    return _rightButton;
}

- (JKCountDownButton *)countDownButton
{
    if (!_countDownButton) {
        _countDownButton = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
        
        _countDownButton.backgroundColor = [UIColor clearColor];
        
        [_countDownButton setTitle:kTextGetPhoneMessage forState:UIControlStateNormal];
        
        [_countDownButton setTitleColor:[UIColor colorWithHex:@"#78D8AF"] forState:UIControlStateNormal];
        
        _countDownButton.layer.cornerRadius = 4;
        
        _countDownButton.layer.borderWidth = 1;
        
        _countDownButton.hidden = YES;
        
        _countDownButton.layer.borderColor = [UIColor colorWithHex:@"#78D8AF"].CGColor;
        
        _countDownButton.layer.masksToBounds = YES;
        
        _countDownButton.titleLabel.font = KSYSTEM_FONT_(12);
        
        [_countDownButton countDownButtonHandler:^(JKCountDownButton *countDownButton, NSInteger tag) {
            
        }];
        
        
    }
    return _countDownButton;
}

- (UIButton *)arrowXButton
{
    if (!_arrowXButton) {
        _arrowXButton = [UIButton new];
        
        _arrowXButton.backgroundColor = [UIColor clearColor];
        
        _arrowXButton.hidden = YES;
        
        _arrowXButton.titleLabel.font = KICON_FONT_(13);
        
        [_arrowXButton setTitle:@"\U0000e615" forState:UIControlStateNormal];
        
        [_arrowXButton setTitleColor:[UIColor colorWithHex:@"#C2C2C2"] forState:UIControlStateNormal];
        
        [_arrowXButton addTarget:self action:@selector(actionX:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _arrowXButton;
}

- (void)actionX:(id)sender
{
    
}

- (void)actionStartCountDown
{
    _countDownButton.enabled = NO;
    
    [_countDownButton startCountDownWithSecond:kCountDewnButtonNumber];
    
    [_countDownButton countDownChanging:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
        NSString *title = [NSString stringWithFormat:@"剩余%lu秒",(unsigned long)second];
        return title;
    }];
    [_countDownButton countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
        countDownButton.enabled = YES;
        return kTextGetPhoneMessage;
        
    }];
    
}



@end
