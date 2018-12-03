//
//  PhoneRegisterController.m
//  HTGUniteSDK
//
//  Created by zfj2602 on 2018/4/12.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "PhoneRegisterController.h"
#import "UsernameRegisterController.h"
#import "RealnameManager.h"
#import "LoginWebBaseController.h"
#import "LoginViewController.h"

@interface PhoneRegisterController () <UITextFieldDelegate>

@property (nonatomic, strong) InputTextView *userTextField;

@property (nonatomic, strong) InputTextView *pswField;

@property (nonatomic, strong) UIButton     *agreeLb;

@property (nonatomic, strong) UIButton    *agreeButton;                  //!< 协议按钮

@property (nonatomic, strong) UIButton    *enterButton;

@property (nonatomic, strong) UIButton    *userNameRegisterButton;

@end

@implementation PhoneRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"手机号注册";
    
    //显示返回按钮
    [self showBackButton];

}

- (void)initSubviews
{
    [super initSubviews];
    
    [self.view addSubview:self.userTextField];
    
    self.userTextField.textField.delegate = self;
    
    [self.view addSubview:self.pswField];
    
    [self.view addSubview:self.agreeButton];
    
    [self.view addSubview:self.agreeLb];
    
    [self.view addSubview:self.enterButton];
    
    [self.view addSubview:self.userNameRegisterButton];
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
    
    [self.userNameRegisterButton mas_remakeConstraints:^(MASConstraintMaker *make) {
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
        
        _userTextField.backgroundColor = [UIColor whiteColor];
        
        _userTextField.textField.delegate = self;
        
        _userTextField.textField.placeholder = @"请输入手机号";
        
        _userTextField.leftLabel.text = @"\U0000e693";
        
    }
    return _userTextField;
}

- (InputTextView *)pswField
{
    if (!_pswField) {
        _pswField = [InputTextView new];
        
        _pswField.backgroundColor = [UIColor whiteColor];
        
        _pswField.textField.delegate = self;
        
        _pswField.textField.placeholder = @"请输入验证码";
        
        _pswField.leftLabel.text = @"\U0000e60d";
        
        _pswField.rightButton.hidden = YES;
        
        _pswField.countDownButton.hidden = NO;
        
        [_pswField.countDownButton addTarget:self
                                  action:@selector(actionGetphonemessage:)
                        forControlEvents:UIControlEventTouchUpInside];
        
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

- (UIButton *)userNameRegisterButton
{
    if (!_userNameRegisterButton) {
        
        _userNameRegisterButton = [UIButton new];
        
        _userNameRegisterButton.backgroundColor = [UIColor clearColor];
        
        NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:kTextUsernameRegister]];
        
        [aString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#B1AFAE"] range:NSMakeRange(0,6)];
        
        [aString addAttribute:NSForegroundColorAttributeName value:kQuickLoginNormalTextColor range:NSMakeRange(6,5)];
        
        [_userNameRegisterButton setAttributedTitle:aString forState:UIControlStateNormal];
        
        _userNameRegisterButton.titleLabel.font = KSYSTEM_FONT_(12);
        
        _userNameRegisterButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [_userNameRegisterButton addTarget:self action:@selector(actionPhoneRegister:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userNameRegisterButton;
}

#pragma mark - 私有函数

- (void)actionPhoneRegister:(id)sender
{
    [self pushViewController:[UsernameRegisterController new]];
}

- (void)actionAgree:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.isSelected;
}

- (void)actionGetphonemessage:(id)sender
{
    WEAK_SELF(weakSelf);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    __block NSString *phone = self.userTextField.textField.text;
    if (!IS_EXIST_STR(phone)) {
        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE]
                                         title:kToastTips
                                       message:@"手机号不能为空!"
         ];

        return;
    }
//    if (![HTUtil isValidMobile:phone]) {
//        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE]
//                                         title:kToastTips
//                                       message:@"请输入合法的手机号码!"
//         ];
//        return;
//    }
    [param addObjectIfNotBlank:phone forKey:HTSDKPHONE];
    [param addObjectIfNotBlank:@"3" forKey:HTSDKTYPE];//'3'固定值  

    [[RequestManager sharedManager] ht_getCheckCodeWithParam:param
                                                     success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                         KLLog(@"+++++++++++++手机号注册获取验证码成功+++++++++++++");
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             [weakSelf.pswField actionStartCountDown];
                                                         });
                                                     } failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                         
                                                     }];
}

- (void)actionRegister:(id)sender
{
    WEAK_SELF(weakSelf);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    __block NSString *phone = self.userTextField.textField.text;
    __block NSString *code = self.pswField.textField.text;
    if (!IS_EXIST_STR(phone) || !IS_EXIST_STR(code)) {
        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE]
                                         title:kToastTips
                                       message:@"手机号和验证码不能为空!"
         ];

        return;
    }
    if (!self.agreeButton.isSelected) {
        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE]
                                         title:kToastTips
                                       message:@"请先选择同意协议"
         ];
        return;
    }
    [param addObjectIfNotBlank:phone forKey:HTSDKPHONE];
    [param addObjectIfNotBlank:code forKey:HTSDKPHONECODE];
    
    __block BOOL isToutiaoSDK = [RequestManager sharedManager].isToutiaoSDK;

    [[RequestManager sharedManager] ht_getPhoneRegisterWithParam:param
                                                         success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                             KLLog(@"+++++++++++手机号注册成功++++++++++++");
                                                             
                                                             if (isToutiaoSDK) {
                                                                 [TTTracker registerEventByMethod:@"phoneRegister" isSuccess:YES];
                                                             }

                                                             [weakSelf autoLogin];
                                                         } failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                             
                                                             if (isToutiaoSDK) {
                                                                 [TTTracker registerEventByMethod:@"phoneRegister" isSuccess:NO];
                                                             }

                                                         }];
}

- (void)autoLogin
{
    WEAK_SELF(weakSelf);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    ModelLogin *loginModel = [RequestManager sharedManager].loginModel;
    __block NSString *username = loginModel.username;
    __block NSString *password = loginModel.password;
    [param addObjectIfNotBlank:username forKey:HTSDKUSERNAME];
    [param addObjectIfNotBlank:password forKey:HTSDKPASSWORD];
    
    [[RequestManager sharedManager] ht_getUserNameLoginWithParam:param
                                                         success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                             KLLog(@"++++++++手机号注册之后、登录成功+++++++++++++++");
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

- (void)actionGotoContact:(id)sender
{
    LoginWebBaseController *controller = [LoginWebBaseController new];
    controller.requestUrlString = H5_CONTACT;
    controller.titleText = @"用户协议";
    controller.isShowBackButton = YES;
    [self pushViewController:controller];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    int pMaxLength = 11;
    NSInteger strLength = textField.text.length - range.length + string.length;
    //输入内容的长度 - textfield区域字符长度（一般=输入字符长度）+替换的字符长度（一般为0）
    return (strLength <= pMaxLength);
}

@end
