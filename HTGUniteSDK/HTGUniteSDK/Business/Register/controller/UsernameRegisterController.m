//
//  UsernameRegisterController.m
//  HTGUniteSDK
//
//  Created by zfj2602 on 2018/4/12.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "UsernameRegisterController.h"
#import "PhoneRegisterController.h"
#import "RealnameManager.h"
#import "LoginWebBaseController.h"
#import "LoginViewController.h"
#import "NSString+StringHT.h"

@interface UsernameRegisterController () <UITextFieldDelegate>

@property (nonatomic, strong) InputTextView *userTextField;                //!< 用户名输入框

@property (nonatomic, strong) InputTextView *pswField;                     //!< 密码输入框

@property (nonatomic, strong) UIButton    *agreeButton;                  //!< 协议按钮

@property (nonatomic, strong) UIButton     *agreeLb;                        //!< 协议文字

@property (nonatomic, strong) UIButton    *enterButton;                  //!< 进入SDK 按钮视图

@property (nonatomic, strong) UIButton    *messageRegisterButton;        //!< 短信验证码注册按钮视图



@end

@implementation UsernameRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"用户名注册";
    
    //显示返回按钮
    [self showBackButton];
    
}

- (void)initSubviews
{
    [super initSubviews];
    
    [self.view addSubview:self.userTextField];
    
    [self.view addSubview:self.pswField];
    
    [self.view addSubview:self.agreeButton];
    
    [self.view addSubview:self.agreeLb];
    
    [self.view addSubview:self.enterButton];
    
    [self.view addSubview:self.messageRegisterButton];
    
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
    
    [self.agreeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pswField);
        make.top.equalTo(self.pswField.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.agreeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.agreeButton).offset(15);
        make.centerY.equalTo(self.agreeButton);
        make.size.mas_equalTo(CGSizeMake(200, 14));
    }];
    
    [self.enterButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.pswField);
        make.top.equalTo(self.agreeLb.mas_bottom).offset(15);
        make.height.mas_equalTo(40);
    }];
    
    [self.messageRegisterButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pswField).offset(0);
        make.top.equalTo(self.enterButton.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(150, 12));
    }];

}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self customNavigationControllerWithWidth:NAVIGATIONCONTROLLERHWIDTH height:300 isCenterInParent:YES originY:0];
    
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)back
{
    CATransition* transition = [CATransition animation];
    transition.duration =0.3f;
    transition.type =kCATransitionReveal;
    transition.subtype =kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    LoginViewController *loginController = [LoginViewController new];
    [self.navigationController pushViewController:loginController animated:NO];
    
}

#pragma mark - 懒加载

- (InputTextView *)userTextField
{
    if (!_userTextField) {
        _userTextField = [InputTextView new];
        
        _userTextField.textField.delegate = self;
        
        _userTextField.textField.placeholder = @"请输入用户名";
        
        _userTextField.leftLabel.text = @"\U0000e62e";
        
        _userTextField.textField.text = [NSString return16LetterAndNumber];
        
    }
    return _userTextField;
}

- (InputTextView *)pswField
{
    if (!_pswField) {
        _pswField = [InputTextView new];
        
        _pswField.textField.delegate = self;
        
        _pswField.textField.placeholder = @"请输入密码";
                
        _pswField.leftLabel.text = @"\U0000e652";
        
    }
    return _pswField;
}

- (UIButton *)agreeButton
{
    if (!_agreeButton) {
        _agreeButton = [UIButton new];
        
        _agreeButton.backgroundColor = [UIColor clearColor];
        
        [_agreeButton setTitle:@"\U0000e684" forState:UIControlStateNormal];
        
        [_agreeButton setTitleColor:[UIColor colorWithHex:@"#ADADAC"] forState:UIControlStateNormal];
        
        [_agreeButton setTitleColor:[UIColor colorWithHex:@"#30B960"] forState:UIControlStateSelected];
        
        _agreeButton.titleLabel.font = KICON_FONT_(20);
        
        [_agreeButton setSelected:YES];
        
        [_agreeButton addTarget:self action:@selector(actionAgree:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeButton;
}


- (UIButton *)agreeLb
{
    if (!_agreeLb) {
        _agreeLb = [UIButton new];
        
        _agreeLb.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [_agreeLb setTitleColor:[UIColor colorWithHex:@"#00BD54"] forState:UIControlStateNormal];
        
        _agreeLb.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [_agreeLb setTitle:kAgreeText forState:UIControlStateNormal];
        
        [_agreeLb addTarget:self action:@selector(actionGotoContact:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _agreeLb;
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

        [_enterButton addTarget:self action:@selector(actionRegister:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}

- (UIButton *)messageRegisterButton
{
    if (!_messageRegisterButton) {
        
        _messageRegisterButton = [UIButton new];
        
        _messageRegisterButton.backgroundColor = [UIColor clearColor];
        
        NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:kTextPhoneRegister]];
        
        [aString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#B1AFAE"] range:NSMakeRange(0,6)];
        
        [aString addAttribute:NSForegroundColorAttributeName value:kQuickLoginNormalTextColor range:NSMakeRange(6,5)];

        [_messageRegisterButton setAttributedTitle:aString forState:UIControlStateNormal];

        _messageRegisterButton.titleLabel.font = KSYSTEM_FONT_(12);
        
        _messageRegisterButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                
        [_messageRegisterButton addTarget:self action:@selector(actionPhoneRegister:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageRegisterButton;
}

#pragma mark - 私有函数


- (void)actionRegister:(id)sender
{
    WEAK_SELF(weakSelf);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    __block NSString *username = self.userTextField.textField.text;
    __block NSString *password = self.pswField.textField.text;
    if (!IS_EXIST_STR(username) || !IS_EXIST_STR(password)) {
        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE] title:kToastTips message:@"用户名和密码不能为空!"];
        return;
    }
    if (!self.agreeButton.isSelected) {
        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE]
                                         title:kToastTips
                                       message:@"请先选择同意协议"];
        return;
    }
    [param addObjectIfNotBlank:username forKey:HTSDKUSERNAME];
    [param addObjectIfNotBlank:password forKey:HTSDKPASSWORD];
    
    __block BOOL isToutiaoSDK = [RequestManager sharedManager].isToutiaoSDK;
    
    [[RequestManager sharedManager] ht_getUserNameRegisterWithParam:param
                                                            success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                                KLLog(@"+++++++++++用户名注册成功++++++++++++");
                                                                
                                                                if (isToutiaoSDK) {
                                                                    [TTTracker registerEventByMethod:@"usernameRegister" isSuccess:YES];
                                                                }

                                                                [weakSelf loginWithName:username password:password];
                                                            } failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                                
                                                                if (isToutiaoSDK) {
                                                                    [TTTracker registerEventByMethod:@"usernameRegister" isSuccess:NO];
                                                                }

                                                                
                                                            }];
}

- (void)actionPhoneRegister:(id)sender
{
    [self pushViewController:[PhoneRegisterController new]];
}

- (void)actionAgree:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.isSelected;
}

- (void)actionGotoContact:(id)sender
{
    LoginWebBaseController *controller = [LoginWebBaseController new];
    controller.requestUrlString = H5_CONTACT;
    controller.titleText = @"用户协议";
    controller.isShowBackButton = YES;
    [self pushViewController:controller];
}

- (void)loginWithName:(NSString *)username password:(NSString *)password
{
    WEAK_SELF(weakSelf);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param addObjectIfNotBlank:username forKey:HTSDKUSERNAME];
    [param addObjectIfNotBlank:password forKey:HTSDKPASSWORD];

    [[RequestManager sharedManager] ht_getUserNameLoginWithParam:param
                                                         success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                             KLLog(@"++++++++用户名密码注册之后、登录成功+++++++++++++++");
                                                             
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 [HTUtil makeScreenShotCompletion:^(UIImage *image) {
                                                                     
                                                                 }];
                                                             });
                                                             
                                                             //保存用户名密码进数据库
                                                             UserInfo *insertUser = [UserInfo new];
                                                             insertUser.username = username;
                                                             insertUser.password = password;
                                                             insertUser.dateline = [HTUtil getNowDate];
                                                             if(![[DBManager sharedDBManager] insertDataWithUserInfo:insertUser])
                                                             {//插入数据失败、更新原有用户时间戳
                                                                 [[DBManager sharedDBManager] updateDatelineWithUserInfo:insertUser];
                                                             }
                                                             //实名认证检验
                                                             [RealnameManager isGotoRealnamePageWithVc:weakSelf];
                                                         } failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                             
                                                         }];
}


@end
