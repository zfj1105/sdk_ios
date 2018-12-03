//
//  InputTextView.h
//  HTGUniteSDK
//
//  Created by zhangfujun on 2018/4/12.
//  Copyright © 2018年 haitui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKCountDownButton.h"

@interface InputTextView : UIView

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) JKCountDownButton *countDownButton;

@property (nonatomic, strong) UIButton *hiddenPswButton;
@property (nonatomic, strong) UIButton *rightButton;


@property (nonatomic, strong) UIButton *arrowXButton;//!< 快速登录界面下拉历史用户按钮

- (void)actionStartCountDown;
@end
