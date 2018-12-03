//
//  PhonemessageController.m
//  HTGUniteSDK
//
//  Created by zfj2602 on 2018/4/13.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "PhonemessageController.h"
#import "UsernameRegisterController.h"
#import "RealnameManager.h"
#import "LoginViewController.h"

@interface PhonemessageController () <UITextFieldDelegate>

@property (nonatomic, strong) InputTextView *userInput;

@property (nonatomic, strong) InputTextView *pswField;

@property (nonatomic, strong) UILabel     *agreeLb;

@property (nonatomic, strong) UIButton    *enterButton;

@property (nonatomic, strong) UIButton    *userNameRegisterButton;


@end

@implementation PhonemessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"短信验证登录";
    
    //显示返回按钮
    [self showBackButton];
    
}

- (void)initSubviews
{
    [super initSubviews];
    
    [self.view addSubview:self.userInput];
    
    [self.view addSubview:self.pswField];
    
    [self.view addSubview:self.enterButton];
    
    [self.view addSubview:self.userNameRegisterButton];
    
}

- (void)back
{

    //键盘打开的场景点击返回按钮crash  fix  by  zfj 5.11
    [self touchWindow];

    CATransition* transition = [CATransition animation];
    transition.duration =0.3f;
    transition.type =kCATransitionReveal;
    transition.subtype =kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];

    LoginViewController *loginController = [LoginViewController new];
    [self.navigationController pushViewController:loginController animated:NO];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.userInput mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(60);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo((@40));
    }];

    
    [self.pswField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userInput.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo((@40));
    }];
    
    [self.enterButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.pswField);
        make.top.equalTo(self.pswField.mas_bottom).offset(15);
        make.height.mas_equalTo(40);
    }];
    
    [self.userNameRegisterButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pswField).offset(15);
        make.top.equalTo(self.enterButton.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(150, 12));
    }];
    
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self customNavigationControllerWithWidth:NAVIGATIONCONTROLLERHWIDTH height:250 isCenterInParent:YES originY:0];
    
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

#pragma mark - 懒加载

- (InputTextView *)userInput
{
    if (!_userInput) {
        _userInput = [InputTextView new];
        
        _userInput.textField.placeholder = kTextInputUsername;
        
        _userInput.textField.delegate = self;
        
        [_userInput.leftLabel setText:@"\U0000e693"];
        
        [_userInput.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        _userInput.textField.tag = 10004;

    }
    return _userInput;
}

- (InputTextView *)pswField
{
    if (!_pswField) {
        _pswField = [InputTextView new];
        
        _pswField.textField.placeholder = kTextInputPhoneMessage;
                
        [_pswField.leftLabel setText:@"\U0000e60d"];
        
        _pswField.textField.delegate = self;
        
        _pswField.countDownButton.hidden = NO;
        
        [_pswField.countDownButton addTarget:self action:@selector(actionGetMessageCode:) forControlEvents:UIControlEventTouchUpInside];
        
        _pswField.rightButton.hidden = YES;
        
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
        
        [_userNameRegisterButton setTitleColor:kQuickLoginNormalTextColor forState:UIControlStateNormal];
        
        [_userNameRegisterButton addTarget:self action:@selector(actionPhoneRegister:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userNameRegisterButton;
}

#pragma mark - 私有函数

- (void)actionPhoneRegister:(id)sender
{
    [self pushViewController:[UsernameRegisterController new]];
}

//进入游戏
- (void)actionEnterGame:(id)sender
{
    WEAK_SELF(weakSelf);
    __block NSString *phone = self.userInput.textField.text;//手机号
    NSString *code = self.pswField.textField.text;//验证码
    if (![HTUtil isValidMobile:phone]) {
        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE]
                                         title:kToastTips
                                       message:@"请输入正确的手机号!"
         ];

        return;
    }
    if (!IS_EXIST_STR(code)) {
        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE]
                                         title:kToastTips
                                       message:@"验证码不能为空!"
         ];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param addObjectIfNotBlank:phone forKey:HTSDKPHONE];
    [param addObjectIfNotBlank:code forKey:HTSDKPHONECODE];//验证码
    [[RequestManager sharedManager] ht_getPhoneLoginWithParam:param
                                                      success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                          KLLog(@"++++++++短信验证登录成功+++++++++++");
                                                          
                                                          UserInfo *user = [UserInfo new];
                                                          user.username = phone;
                                                          user.isCodeLogin = @"1";//标识是短信验证登录的历史账号
                                                          user.dateline = [HTUtil getNowDate];
                                                          if(![[DBManager sharedDBManager] insertDataWithUserInfo:user])
                                                          {//插入数据失败、更新原有用户时间戳
                                                              [[DBManager sharedDBManager] updateDatelineWithUserInfo:user];
                                                          }
                                                          
                                                          //实名认证检验
                                                          [RealnameManager isGotoRealnamePageWithVc:weakSelf];
                                                      } failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                          
                                                      }];
}


- (void)actionGetMessageCode:(id)sender
{
    WEAK_SELF(weakSelf);
    NSString *phone = self.userInput.textField.text;//手机号
    if (![HTUtil isValidMobile:phone]) {
        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE]
                                         title:kToastTips
                                       message:@"请输入正确的手机号"
         ];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param addObjectIfNotBlank:phone forKey:HTSDKPHONE];
    [param addObjectIfNotBlank:@"6" forKey:HTSDKTYPE];//固定值6  type

    [[RequestManager sharedManager] ht_getCheckCodeWithParam:param
                                                     success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                         KLLog(@"++++++++短信验证登录获取验证码成功+++++++++++");
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             [weakSelf.pswField actionStartCountDown];
                                                         });
                                                     } failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                         
                                                     }];
}

#pragma mark - 输入框代理

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.tag == 10005) {//验证码
        
    }else if (textField.tag == 10004){//手机号输入框
        CGFloat maxLength = 11;
        NSString *toBeString = textField.text;
        
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position || !selectedRange)
        {
            if (toBeString.length > maxLength)
            {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
                if (rangeIndex.length == 1)
                {
                    textField.text = [toBeString substringToIndex:maxLength];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    }
}

- (void)touchWindow
{
    if ([LoginWindow sharedInstance].windowButton.isEnabled) {
        [self customNavigationControllerWithWidth:NAVIGATIONCONTROLLERHWIDTH
                                           height:250
                                 isCenterInParent:YES
                                          originY:0];
        
        [LoginWindow sharedInstance].windowButton.enabled = NO;
        
    }
}
@end

