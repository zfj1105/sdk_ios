//
//  UserCenterBaseController.m
//  HTGUniteSDK
//
//  Created by zfj2602 on 2018/4/16.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "UserCenterBaseController.h"
#import "TXScrollLabelView.h"
#import "HTPangestureButtonManager.h"

@interface UserCenterBaseController ()<LoginWindowDelegate>


@end

@implementation UserCenterBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
    
    [self customNavigationBar];
    [self customNavigationControllerWithWidth:NAVIGATIONCONTROLLERHWIDTH height:300 isCenterInParent:YES originY:0];
    [self addNotifications];
    
    //remakeConstraints
    [self layoutSubviews];
    
    self.view.userInteractionEnabled = YES;
    self.view.multipleTouchEnabled = YES;
    
    //跑马灯广告开始滚动
    [self.scrollLabelView beginScrolling];
    
    [LoginWindow sharedInstance].delegate = self;
}

- (void)initSubviews
{
    
    [self.view addSubview:self.navigationView];
    
    [self.view addSubview:self.scrollLabelView];
    
    [self.navigationView addSubview:self.titleLabel];
    
    [self.navigationView addSubview:self.backButton];
    
    [self.navigationView addSubview:self.closeButton];
    
}

- (void)layoutSubviews
{
    
    [self.navigationView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.view);
        make.height.equalTo(@(44));
    }];
    
    [self.backButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.left.equalTo(self.navigationView).offset(10);
        make.centerY.equalTo(self.navigationView);
    }];
    
    [self.closeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.equalTo(self.navigationView).offset(-10);
        make.centerY.equalTo(self.navigationView);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.navigationView);
        make.top.equalTo(self.navigationView).offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 44));
    }];
    
    [self.scrollLabelView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.right.equalTo(self.navigationView);
        make.height.equalTo(@(15));
    }];
}

- (void)addNotifications
{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.navigationController.view endEditing:YES];
    [self customNavigationControllerWithWidth:NAVIGATIONCONTROLLERHWIDTH
                                       height:300
                             isCenterInParent:YES
                                      originY:10];
}

#pragma mark - 导航栏控制事件

- (void)back
{
    
    //键盘打开的场景点击返回按钮crash  fix  by  zfj 5.11
    [self touchWindow];

    CATransition* transition = [CATransition animation];
    transition.duration =0.3f;
    transition.type =kCATransitionReveal;
    transition.subtype =kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
    

}

- (void)pushViewController:(UIViewController *)viewController
{
    CATransition* transition = [CATransition animation];
    transition.duration =0.3f;
    transition.type =kCATransitionMoveIn;
    transition.subtype =kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:viewController animated:NO];
}

- (void)close:(id)sender
{
    [[HTPangestureButtonManager sharedManager] showHTPanGestureButtonInKeyWindow];

    [[LoginWindow sharedInstance] dismiss];
}


#pragma mark - 懒加载

- (UIButton *)backButton
{
    if (!_backButton) {
        
        _backButton = [[UIButton alloc] initWithFrame:CGRectZero];
        
        _backButton.titleLabel.font = KICON_FONT_(18);
        
        [_backButton setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateNormal];
        
        [_backButton setTitle:@"\U0000e62e" forState:UIControlStateNormal];
        
        //默认隐藏返回按钮
        _backButton.hidden = NO;
        
        [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        [_backButton setEnlargeEdgeWithTop:8 right:8 bottom:8 left:8];
        
    }
    return _backButton;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        
        _closeButton = [[UIButton alloc] initWithFrame:CGRectZero];
        
        _closeButton.titleLabel.font = KICON_FONT_(18);
        
        [_closeButton setTitleColor:[UIColor colorWithHex:@"#FFFFFF"] forState:UIControlStateNormal];
        
        [_closeButton setTitle:@"\U0000e61a" forState:UIControlStateNormal];
        
        //默认隐藏关闭按钮
        _closeButton.hidden = NO;
        
        [_closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        
        [_closeButton setEnlargeEdgeWithTop:8 right:8 bottom:8 left:8];
        
    }
    return _closeButton;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        
        _titleLabel.font = KSYSTEM_FONT_BOLD_(18);
        
        _titleLabel.textColor = [UIColor whiteColor];
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.text = kTextUsercenter;
        
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

- (UIView *)navigationView
{
    if (!_navigationView) {
        _navigationView = [UIView new];
        
        _navigationView.backgroundColor = [UIColor colorWithHex:@"#302E30"];
    }
    
    return _navigationView;
}

- (TXScrollLabelView *)scrollLabelView
{
    if (!_scrollLabelView) {
        _scrollLabelView = [TXScrollLabelView scrollWithTextArray:[NSArray arrayWithObjects:kTXScrollLabelViewText, nil]
                                                             type:TXScrollLabelViewTypeLeftRight
                                                         velocity:1
                                                          options:UIViewAnimationOptionCurveEaseInOut
                                                            inset:UIEdgeInsetsMake(0, 5, 0, 5)];
 
        _scrollLabelView.scrollLabelViewDelegate = self;
        
        _scrollLabelView.hidden = YES;//默认隐藏
        
        _scrollLabelView.backgroundColor = [UIColor clearColor];
        
        _scrollLabelView.scrollTitleColor = [UIColor colorWithHex:@"#FF575A"];
        
    }
    return _scrollLabelView;
}

- (void)showBackButton
{
    self.backButton.hidden = NO;
}

- (void)customNavigationBar
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    self.navigationController.navigationBar.hidden = YES;
}

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
                                    originY:(float)originY
{
    
    self.navigationController.view.backgroundColor = [UIColor colorWithHex:@"#F5F4F9"];
    
    if (isCenter) {
        [self.navigationController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo([LoginWindow sharedInstance].mainWindow);
            make.size.mas_equalTo(CGSizeMake(aWidth, aHeight));
        }];
    }else{
        [self.navigationController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo([LoginWindow sharedInstance].mainWindow);
            make.top.equalTo([LoginWindow sharedInstance].mainWindow).offset(originY);
            make.size.mas_equalTo(CGSizeMake(aWidth, aHeight));
        }];
    }
    
    self.navigationController.view.layer.cornerRadius = 8;
    
    self.navigationController.view.layer.masksToBounds = YES;
}

/**
 修改返回按钮的背景
 
 @param backTitle   显示的返回图片
 */
- (void)editBackImg:(NSString *)backTitle
{
    [self.backButton setTitle:backTitle forState:UIControlStateNormal];
}

#pragma mark - 编辑框输入代理模式

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [LoginWindow sharedInstance].windowButton.enabled = YES;

    [self customNavigationControllerWithWidth:NAVIGATIONCONTROLLERHWIDTH
                                       height:300
                             isCenterInParent:NO
                                      originY:10];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (void)touchWindow
{
    
    if ([LoginWindow sharedInstance].windowButton.isEnabled) {
        [self customNavigationControllerWithWidth:NAVIGATIONCONTROLLERHWIDTH
                                           height:300
                                 isCenterInParent:YES
                                          originY:10];
        
        [LoginWindow sharedInstance].windowButton.enabled = NO;

    }

}
@end
