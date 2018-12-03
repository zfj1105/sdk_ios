//
//  HTPanGestureButton.h
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/27.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTPanGestureButton;

@protocol HTPanGestureButtonDelegate <NSObject>
- (void)htPanGestureButtonClick:(HTPanGestureButton *)panButton;
@end


@interface HTPanGestureButton : UIButton


@property (nonatomic, weak) id<HTPanGestureButtonDelegate> delegate;

@property (nonatomic, assign) BOOL isPanGestureButtonLeft;//标记按钮处于屏幕的左边还是右边

@property (nonatomic, strong) UIView *superAddedView;//加载按钮的父控件


- (instancetype)initWithFrame:(CGRect)frame Delegate:(id<HTPanGestureButtonDelegate>)delegate;


- (void)showHTPanGestureButtonInView:(UIView *)aView;


- (void)hiddenHTPanBugtton;

@end
