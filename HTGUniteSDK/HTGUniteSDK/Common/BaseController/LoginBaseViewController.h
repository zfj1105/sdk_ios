//
//  LoginBaseViewController.h
//  HTGUniteSDK
//
//  Created by zhangfujun on 2018/4/5.
//  Copyright © 2018年 htdata. All rights reserved.
//

/****************************
 modify by zhangfujun 2018/4/10
 ****************************/

#import <UIKit/UIKit.h>
#import "HTBaseController.h"

@interface LoginBaseViewController : HTBaseController

@property (readwrite, nonatomic, strong) UIButton    *backButton;                        //!< 返回按钮

@property (readwrite, nonatomic, strong) UIView      *navigationView;                    //!< 自定义导航栏

@property (readwrite, nonatomic, strong) UIImageView *titleImageView;                    //!< 主题背景图片视图

@property (readwrite, nonatomic, strong) UIView      *separateView;                      //!< 导航控制器垂直分割线

@property (readwrite, nonatomic, strong) UILabel     *titleLabel;                        //!< 导航控制器主题视图


/**
 初始化子视图
  */
- (void)initSubviews;

/**
 重置当前视图的子视图的相对坐标
 */
- (void)layoutSubviews;

/**
 在当前视图控制器显示返回按钮
 */
- (void)showBackButton;


/**
 返回上一个视图控制器
 */
- (void)back;

/**
 推出下一个视图
 
 @param viewController   需要推出的视图对象
 */
- (void)pushViewController:(UIViewController *)viewController;


- (void)touchWindow;
@end
