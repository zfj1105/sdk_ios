//
//  UserCenterBaseController.h
//  HTGUniteSDK
//
//  Created by zfj2602 on 2018/4/16.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXScrollLabelView.h"
#import "HTBaseController.h"

@interface UserCenterBaseController : HTBaseController <UITextFieldDelegate, TXScrollLabelViewDelegate>

@property (readwrite, nonatomic, strong) UIButton    *backButton;                        //!< 返回按钮

@property (readwrite, nonatomic, strong) UIButton    *closeButton;                       //!< 关闭按钮

@property (readwrite, nonatomic, strong) UIView      *navigationView;                    //!< 自定义导航栏

@property (readwrite, nonatomic, strong) UILabel     *titleLabel;                        //!< 导航控制器主题视图

@property (nonatomic, strong) TXScrollLabelView      *scrollLabelView;                   //!< 跑马灯效果文字

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
 重置导航控制器画布frame
 
 @param aWidth   当前导航控制视图的宽
 @param aHeight  当前导航控制视图的高
 @param isCenter 在父视图中是否居中显示
 @param originY  距离父视图顶部的间距
 
 */
- (void)customNavigationControllerWithWidth:(float)aWidth
                                     height:(float)aHeight
                           isCenterInParent:(BOOL)isCenter
                                    originY:(float)originY;

/**
 返回上一个视图控制器
 */
- (void)back;

/**
 关闭当前视图控制器
 */
- (void)close:(id)sender;

/**
 推出下一个视图
 
 @param viewController   需要推出的视图对象
 */
- (void)pushViewController:(UIViewController *)viewController;

/**
 修改返回按钮的背景
 
 @param backTitle   显示的返回图片
 */
- (void)editBackImg:(NSString *)backTitle;

@end
