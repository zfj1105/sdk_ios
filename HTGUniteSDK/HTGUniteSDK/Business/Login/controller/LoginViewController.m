//
//  LoginViewController.m
//  HTGUniteSDK
//
//  Created by haitui on 2018/4/8.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "LoginViewController.h"
#import "UsernameRegisterController.h"
#import "RealnameController.h"
#import "PhonemessageController.h"
#import "RealnameManager.h"
#import "ForgetPswViewController.h"
#import "QuickLoginViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) InputTextView *userTextField;

@property (nonatomic, strong) InputTextView *pswField;

@property (nonatomic, strong) UIButton    *enterButton;

@property (nonatomic, strong) UIButton    *messageLoginButton;

@property (nonatomic, strong) UIButton    *registerButton;

@property (nonatomic, strong) UIImageView *bottomLine;

@property (nonatomic, strong) UIImageView *bottomLineRight;

@property (nonatomic, strong) UILabel     *bottomText;

@property (nonatomic, strong) UIButton    *passagerButton;

@property (nonatomic, strong) __block UserInfo    *gettedTouristUserinfo;//!<  游客模式登录 分配成功的账号密码缓存




@end

@implementation LoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"用户登录";
    
    //显示返回按钮
    [self showBackButton];
 
}

- (void)initSubviews
{
    [super initSubviews];
    
    [self.view addSubview:self.userTextField];
    
    [self.view addSubview:self.pswField];
    
    [self.view addSubview:self.enterButton];
    
    [self.view addSubview:self.messageLoginButton];
    
    [self.view addSubview:self.registerButton];
    
    [self.view addSubview:self.bottomLine];
    
    [self.view addSubview:self.bottomLineRight];
    
    [self.view addSubview:self.bottomText];
    
    [self.view addSubview:self.passagerButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.userTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(60);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo((@40));
    }];
    
    [self.pswField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userTextField.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo((@40));
    }];

    
    [self.enterButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.pswField);
        make.top.equalTo(self.pswField.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    [self.messageLoginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userTextField);
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.top.equalTo(self.enterButton.mas_bottom).offset(10);
    }];
    
    [self.registerButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.right.equalTo(self.enterButton).offset(0);
        make.bottom.equalTo(self.messageLoginButton);
    }];
    
    [self.bottomText mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.messageLoginButton.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(50, 11));
    }];

    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.enterButton);
        make.right.equalTo(self.bottomText.mas_left).offset(-5);
        make.top.equalTo(self.messageLoginButton.mas_bottom).offset(5);
        make.height.equalTo(@(1));
    }];
    
    [self.bottomLineRight mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomText.mas_right).offset(5);
        make.right.equalTo(self.registerButton).offset(0);
        make.top.equalTo(self.bottomLine).offset(0);
        make.height.equalTo(@(1));
    }];

    [self.passagerButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomLineRight);
        make.top.equalTo(self.bottomLine.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(80, 12));
    }];

}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSArray *namesArray = [[DBManager sharedDBManager] queryDataUserNames];
    
    if (IS_ARRAY_CLASS(namesArray)) {
        self.backButton.hidden = NO;
    }else{
        self.backButton.hidden = YES;
    }
    
    [self customNavigationControllerWithWidth:NAVIGATIONCONTROLLERHWIDTH height:300 isCenterInParent:YES originY:0];
    
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)back
{
    
    [self touchWindow];
    
    CATransition* transition = [CATransition animation];
    transition.duration =0.3f;
    transition.type =kCATransitionReveal;
    transition.subtype =kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    QuickLoginViewController *controller = [QuickLoginViewController new];
    [self.navigationController pushViewController:controller animated:NO];
}

#pragma mark - 懒加载

- (InputTextView *)userTextField
{
    if (!_userTextField) {
        _userTextField = [InputTextView new];
                
        _userTextField.textField.delegate = self;
        
        _userTextField.textField.placeholder = kTextInputUsername;
        
        _userTextField.leftLabel.text = @"\U0000e62e";
    }
    return _userTextField;
}

- (InputTextView *)pswField
{
    if (!_pswField) {
        _pswField = [InputTextView new];
        
        _pswField.textField.delegate = self;
        
        _pswField.textField.placeholder = kTextInputPsw;
        
        _pswField.textField.secureTextEntry = YES;
        
        _pswField.leftLabel.text = @"\U0000e652";
        
        _pswField.rightButton.hidden = NO;
        
        [_pswField.rightButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        
        _pswField.rightButton.titleLabel.font = KICON_FONT_(12);
        
        _pswField.rightButton.layer.borderWidth = 0;
        
        [_pswField.rightButton setTitleColor:[UIColor colorWithHex:@"#B7B7B7"] forState:UIControlStateNormal];
        
        [_pswField.rightButton addTarget:self action:@selector(acitonForgetPsw:) forControlEvents:UIControlEventTouchUpInside];
        
        _pswField.hiddenPswButton.hidden = NO;
        
        [_pswField.hiddenPswButton addTarget:self action:@selector(actionHiddenPSW:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pswField;
}

- (UIButton *)enterButton
{
    if (!_enterButton) {
        _enterButton = [UIButton new];
        
        _enterButton.backgroundColor = kQuickLoginNormalTextColor;
        
        [_enterButton setTitle:kTextEnterGanme forState:UIControlStateNormal];
        
        [_enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _enterButton.layer.cornerRadius = 4;
        
        _enterButton.titleLabel.font = KSYSTEM_FONT_(14);
        
        [_enterButton addTarget:self action:@selector(actionEnterGame:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}

- (UIButton *)messageLoginButton
{
    if (!_messageLoginButton) {
        
        _messageLoginButton = [UIButton new];
        
        _messageLoginButton.backgroundColor = [UIColor clearColor];
        
        [_messageLoginButton setTitle:kTextMseeageLogin forState:UIControlStateNormal];
        
        _messageLoginButton.titleLabel.font = KSYSTEM_FONT_(13);
        
        _messageLoginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [_messageLoginButton setTitleColor:kQuickLoginNormalTextColor forState:UIControlStateNormal];
        
        [_messageLoginButton setEnlargeEdgeWithTop:8 right:5 bottom:8 left:5];

        [_messageLoginButton addTarget:self action:@selector(actionMessageLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageLoginButton;
}

- (UIButton *)registerButton
{
    if (!_registerButton) {
        _registerButton = [UIButton new];
        
        _registerButton.backgroundColor = [UIColor clearColor];
        
        [_registerButton setTitle:kTextRegister forState:UIControlStateNormal];
        
        _registerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [_registerButton setTitleColor:kQuickLoginNormalTextColor forState:UIControlStateNormal];
        
        _registerButton.titleLabel.font = KICON_FONT_(13);
        
        [_registerButton setEnlargeEdgeWithTop:8 right:5 bottom:8 left:5];
        
        [_registerButton addTarget:self action:@selector(actionRegister:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

- (UIImageView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [UIImageView new];
        
        _bottomLine.backgroundColor = [UIColor colorWithHex:@"#AAAAAA"];
    }
    return _bottomLine;
}

- (UIImageView *)bottomLineRight
{
    if (!_bottomLineRight) {
        _bottomLineRight = [UIImageView new];
        
        _bottomLineRight.backgroundColor = [UIColor colorWithHex:@"#AAAAAA"];
    }
    return _bottomLineRight;
}



- (UILabel *)bottomText
{
    if (!_bottomText) {
        _bottomText = [UILabel new];
        
        _bottomText.font = [UIFont systemFontOfSize:11];
        
        _bottomText.textColor = [UIColor colorWithHex:@"#AAAAAA"];
        
        _bottomText.textAlignment = NSTextAlignmentCenter;
        
        _bottomText.text = kOtherLogin;
    }
    return _bottomText;
}

- (UIButton *)passagerButton
{
    if (!_passagerButton) {
        _passagerButton = [UIButton new];
        
        _passagerButton.backgroundColor = [UIColor clearColor];
        
        [_passagerButton setTitle:kPassagerLogin forState:UIControlStateNormal];
        
        _passagerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [_passagerButton setTitleColor:kQuickLoginNormalTextColor forState:UIControlStateNormal];
        
        _passagerButton.titleLabel.font = KICON_FONT_(13);
        
        [_passagerButton setEnlargeEdgeWithTop:8 right:5 bottom:8 left:5];
        
        [_passagerButton addTarget:self action:@selector(actionPassagerLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passagerButton;
}


#pragma mark - 私有动作

//登录进入游戏
- (void)actionEnterGame:(id)sender
{
    WEAK_SELF(weakSelf);
    __block NSString *username = self.userTextField.textField.text;
    __block NSString *psw = self.pswField.textField.text;
    if (!IS_EXIST_STR(username) || !IS_EXIST_STR(psw)) {
        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE]
                                         title:kToastTips
                                       message:@"用户名或密码为空!"
         ];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param addObjectIfNotBlank:username forKey:HTSDKUSERNAME];
    [param addObjectIfNotBlank:psw forKey:HTSDKPASSWORD];

    [[RequestManager sharedManager] ht_getUserNameLoginWithParam:param
                                                         success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                             KLLog(@"++++++++用户名密码登录成功+++++++++++++++");
                                                             //保存用户名密码进数据库
                                                             UserInfo *insertUser = [UserInfo new];
                                                             insertUser.username = username;
                                                             insertUser.password = psw;
                                                             insertUser.dateline = [HTUtil getNowDate];
                                                             if(![[DBManager sharedDBManager] insertDataWithUserInfo:insertUser])
                                                             {//插入数据失败、更新原有用户时间戳
                                                                 [[DBManager sharedDBManager] updateDatelineWithUserInfo:insertUser];
                                                                 [[DBManager sharedDBManager] updateDataWithUserInfo:insertUser];
                                                             }
                                                             //实名认证检验
                                                             [RealnameManager isGotoRealnamePageWithVc:weakSelf];
                                                         } failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                             KLLog(@"++++++++用户名密码登录失败+++++++++++++++");
                                                         }];
}

//短信验证码登录
- (void)actionMessageLogin:(id)sender
{
    [self pushViewController:[PhonemessageController new]];
}

//注册
- (void)actionRegister:(id)sender
{
    [self pushViewController:[UsernameRegisterController new]];

}

//游客登录
- (void)actionPassagerLogin:(id)sender
{
    
    WEAK_SELF(weakSelf);
    [[RequestManager sharedManager] ht_getTouristLoginWithParam:nil
                                                        success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                            KLLog(@"+++++++游客登录分配账号成功++++++");
                                                            //进行登录操作
                                                            __block ModelLogin *modelLogin = [RequestManager sharedManager].loginModel;
                                                            NSMutableDictionary *param = [NSMutableDictionary dictionary];
                                                            [param addObjectIfNotBlank:modelLogin.username forKey:HTSDKUSERNAME];
                                                            [param addObjectIfNotBlank:modelLogin.password forKey:HTSDKPASSWORD];
                                                            //缓存分配的用户信息
                                                            self.gettedTouristUserinfo = [UserInfo new];
                                                            self.gettedTouristUserinfo.username = modelLogin.username;
                                                            self.gettedTouristUserinfo.password = modelLogin.password;

                                                            [[RequestManager sharedManager] ht_getUserNameLoginWithParam:param
                                                                                                                 success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                                                                                     KLLog(@"+++++++游客登录成功++++++");
                                                                                                                     //保存用户名密码进数据库
                                                                                                                     UserInfo *user = [UserInfo new];
                                                                                                                     user.username =self.gettedTouristUserinfo.username;
                                                                                                                     user.password = self.gettedTouristUserinfo.password;
                                                                                                                     user.dateline = [HTUtil getNowDate];
                                                                                                                     if(![[DBManager sharedDBManager] insertDataWithUserInfo:user])
                                                                                                                     {//插入数据失败、更新原有用户时间戳
                                                                                                                         [[DBManager sharedDBManager] updateDatelineWithUserInfo:user];
                                                                                                                     }
                                                                                                                     //实名认证检验
                                                                                                                     [RealnameManager isGotoRealnamePageWithVc:weakSelf];
                                                                                                                 } failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                                                                                     
                                                                                                                 }];
                                                        } failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                            
                                                        }];
}

//忘记密码？
- (void)acitonForgetPsw:(id)sender
{
    [self pushViewController:[ForgetPswViewController new]];
}

//隐藏密码
- (void)actionHiddenPSW:(id)sender
{
    UIButton *button = ((UIButton *)sender);
    if (!button.isSelected) {
        self.pswField.textField.secureTextEntry = NO;
        button.selected = YES;
    }else{
        self.pswField.textField.secureTextEntry = YES;
        button.selected = NO;
    }
}

@end
