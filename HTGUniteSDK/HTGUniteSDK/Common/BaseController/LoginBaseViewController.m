//
//  LoginBaseViewController.m
//  HTGUniteSDK
//
//  Created by zhangfujun on 2018/4/5.
//  Copyright © 2018年 htdata. All rights reserved.
//

#import "LoginBaseViewController.h"
#import "UIImage+findBundleImageHT.h"

@interface LoginBaseViewController ()<UITextFieldDelegate, LoginWindowDelegate>

@end

@implementation LoginBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
    
    [self customNavigationBar];
    [self customNavigationControllerWithWidth:NAVIGATIONCONTROLLERHWIDTH height:200 isCenterInParent:YES originY:0];
    [self addNotifications];
    
    //remakeConstraints
    [self layoutSubviews];
    
    [LoginWindow sharedInstance].delegate = self;

}

- (void)initSubviews
{
    [self.view addSubview:self.backButton];
    
    [self.view addSubview:self.navigationView];
    
    [self.navigationView addSubview:self.titleImageView];
    
    [self.navigationView addSubview:self.separateView];
    
    [self.navigationView addSubview:self.titleLabel];

}

- (void)layoutSubviews
{
    
    [self.backButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 40));
        make.left.top.equalTo(self.view).offset(10);
    }];
    
    [self.navigationView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@(60));
        make.width.equalTo(@(220));
    }];
    
    [self.titleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navigationView);
        make.size.mas_equalTo(CGSizeMake(110, 50));
        make.left.equalTo(self.navigationView).offset(-10);
    }];
    
    [self.separateView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleImageView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(1, 15));
        make.top.equalTo(self.navigationView).offset((60-15)/2);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.separateView.mas_right).offset(10);
        make.top.equalTo(self.navigationView).offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 60));
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [self customNavigationControllerWithWidth:NAVIGATIONCONTROLLERHWIDTH
                                       height:300
                             isCenterInParent:YES
                                      originY:10];
}

- (void) dismissMainLoginWindow
{
    [[LoginWindow sharedInstance] dismiss];
}

- (void)addNotifications
{
    
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

#pragma mark - 懒加载

- (UIButton *)backButton
{
    if (!_backButton) {
        
        _backButton = [[UIButton alloc] initWithFrame:CGRectZero];
        
        _backButton.titleLabel.font = KICON_FONT_(18);
        
        [_backButton setTitleColor:[UIColor colorWithHex:@"#101010"] forState:UIControlStateNormal];
        
        [_backButton setTitle:@"\U0000e63b" forState:UIControlStateNormal];
        
        //默认隐藏返回按钮
        _backButton.hidden = YES;
        
        [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        [_backButton setEnlargeEdgeWithTop:8 right:8 bottom:8 left:8];
        
    }
    return _backButton;
}

- (UIImageView *)titleImageView
{
    if (!_titleImageView) {
        _titleImageView = [UIImageView new];
        
        [_titleImageView setImage:[UIImage imagesNamedFromCustomBundle:@"4398logo"]];
        
        _titleImageView.contentMode = UIViewContentModeScaleAspectFill;

    }
    return _titleImageView;
}

- (UIView *)separateView
{
    if (!_separateView) {
        _separateView = [UIView new];
        
        _separateView.backgroundColor = [UIColor colorWithHex:@"#808080"];
    }
    return _separateView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        
        _titleLabel.font = KSYSTEM_FONT_BOLD_(18);
        
        _titleLabel.textColor = KCUSTOMERTYPE_COLOR_TITLEVIEWLABEL;
        
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

- (UIView *)navigationView
{
    if (!_navigationView) {
        _navigationView = [UIView new];
    }
    
    return _navigationView;
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


//重置画布frame
- (void)customViewControllerWithWidth:(float)aWidth
                               height:(float)aHeight
{
    self.view.frame = self.navigationController.view.bounds;
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
