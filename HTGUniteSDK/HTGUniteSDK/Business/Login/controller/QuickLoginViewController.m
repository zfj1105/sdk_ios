//
//  QuickLoginViewController.m
//  HTGUniteSDK
//
//  Created by zfj2602 on 2018/4/5.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "QuickLoginViewController.h"
#import "LoginViewController.h"
#import "ForgetPswViewController.h"
#import "RealnameManager.h"
#import "UsernamesListView.h"

#import "HTPangestureButtonManager.h"

@interface QuickLoginViewController () <UITextFieldDelegate, UsernameListviewDelegate>

@property (nonatomic, strong) InputTextView *userTextField;

@property (nonatomic, strong) UIButton    *enterButton;

@property (nonatomic, strong) UIButton    *forgetPswButton;

@property (nonatomic, strong) UIButton    *changeLoginButton;

@property (nonatomic, strong) UserInfo    *defaultQuickLoginUser;

@property (nonatomic, strong) NSMutableArray    *usernamesListArray;

@property (nonatomic, strong) UsernamesListView    *userNamesTable;


@end

@implementation QuickLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = kQuickTitle;
    
    [self refreshUserTextFieldData];
    
    //自动登录
    NSNumber *isAutoLogin = [[NSUserDefaults standardUserDefaults] objectForKey:kISAutoLogin];
    if (isAutoLogin.boolValue && [[RequestManager sharedManager].getLoginKeymodel.goToAutoLogin isEqualToString:@"1"]) {
        [self autoLogin];
    }
    
}

- (void)initSubviews
{
    [super initSubviews];
    
    [self.view addSubview:self.userTextField];
    
    [self.view addSubview:self.enterButton];
    
    [self.view addSubview:self.forgetPswButton];
    
    [self.view addSubview:self.changeLoginButton];
    
    [self.view addSubview:self.userNamesTable];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self customNavigationControllerWithWidth:NAVIGATIONCONTROLLERHWIDTH height:200 isCenterInParent:YES originY:0];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController.view endEditing:YES];
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
    
    [self.enterButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.userTextField);
        make.top.equalTo(self.userTextField.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    [self.forgetPswButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userTextField);
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.top.equalTo(self.enterButton.mas_bottom).offset(10);
    }];
    
    [self.changeLoginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.right.equalTo(self.enterButton).offset(0);
        make.bottom.equalTo(self.forgetPswButton);
    }];
    
    [self.userNamesTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userTextField.mas_bottom).offset(2);
        make.left.right.equalTo(self.userTextField);
        make.height.equalTo(@(80));
    }];
}

#pragma mark - 私有方法

- (void) login
{
    
    WEAK_SELF(weakSelf);
    __block NSString *userName = self.userTextField.textField.text;
    __block NSString *password = self.defaultQuickLoginUser.password;

    NSMutableDictionary *param = [NSMutableDictionary dictionary];

    
    if (!IS_EXIST_STR(userName)) {//判空处理
        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE]
                                         title:kToastTips
                                       message:@"账号不能为空!"
         ];
        return;
    }
    if ([HTUtil isValidMobile:userName] && [self.defaultQuickLoginUser.isCodeLogin isEqualToString:@"1"]) {//判断是否是手机号  如果是手机号  在判断是否是短信验证登录的记录历史账号
        [param addObjectIfNotBlank:@"phone" forKey:HTSDKTYPE];//标识参数给server端  是短信验证快速登录
    }
    
    [param addObjectIfNotBlank:userName forKey:HTSDKUSERNAME];
    [param addObjectIfNotBlank:password forKey:HTSDKPASSWORD];

    [[RequestManager sharedManager] ht_getQuickLoginWithParam:param
                                                      success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                          KLLog(@"+++++++++++快速登录成功+++++++++++++");
                                                          //保存用户名密码进数据库
                                                          UserInfo *insertUser = [UserInfo new];
                                                          if ([HTUtil isValidMobile:userName] && [self.defaultQuickLoginUser.isCodeLogin isEqualToString:@"1"]) {//判断是否是手机号  如果是手机号  在判断是否是短信验证登录的记录历史账号
                                                              insertUser.username = userName;
                                                          }else{
                                                              insertUser.username = [RequestManager sharedManager].loginModel.username;
                                                          }
                                                          insertUser.password = password;
                                                          insertUser.dateline = [HTUtil getNowDate];
                                                          if(![[DBManager sharedDBManager] insertDataWithUserInfo:insertUser])
                                                          {//插入数据失败、更新原有用户时间戳
                                                              [[DBManager sharedDBManager] updateDatelineWithUserInfo:insertUser];
                                                          }
                                                          
                                                          //实名认证检验
                                                          [RealnameManager isGotoRealnamePageWithVc:weakSelf];
                                                      }
                                                      failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                          
                                                      }];
    
}

//自动登录
- (void)autoLogin
{
    [self login];
}

- (void) forgetPsw
{
    [self pushViewController:[ForgetPswViewController new]];
}

- (void) changeLogin
{
    [self pushViewController:[LoginViewController new]];
}

- (void)refreshDBUsernames
{
    self.usernamesListArray = (NSMutableArray *)[[DBManager sharedDBManager] queryDataUserNames];
}

- (void)refreshUsernamesTable
{
    [self refreshDBUsernames];
    self.userNamesTable.array = self.usernamesListArray;
    [self.userNamesTable.table reloadData];
}

//展现table、刷新数据
- (void)showUsernamesTable
{
    WEAK_SELF(weakSelf);

    if (self.userNamesTable.isHidden) {
        [UIView animateWithDuration:.2
                         animations:^{
                             CGAffineTransform transform = weakSelf.userTextField.arrowXButton.transform;
                             weakSelf.userTextField.arrowXButton.transform = CGAffineTransformRotate(transform, M_PI);
                         }
                         completion:^(BOOL finished) {
                             [weakSelf refreshDBUsernames];
                             weakSelf.userNamesTable.hidden = NO;
                             [weakSelf refreshUsernamesTable];
                         }];
    }else{
        
        [UIView animateWithDuration:0.2
                         animations:^{
                             CGAffineTransform transform = self.userTextField.arrowXButton.transform;
                             self.userTextField.arrowXButton.transform = CGAffineTransformRotate(transform, -M_PI);
                         }
                         completion:^(BOOL finished) {
                             [self hiddenUsernamesTable];
                         }];
    }
}

//隐藏
- (void)hiddenUsernamesTable
{
    self.userNamesTable.hidden = YES;
}

- (void)refreshUserTextFieldData
{
    //刷新缓存
    [self refreshDBUsernames];
    
    if (IS_ARRAY_CLASS(self.usernamesListArray) && self.usernamesListArray.count>=1) {
        self.defaultQuickLoginUser = self.usernamesListArray[0];
        self.userTextField.textField.text = self.defaultQuickLoginUser.username;
    }
}

#pragma mark - 懒加载

- (InputTextView *)userTextField
{
    if (!_userTextField) {
        _userTextField = [InputTextView new];
        
        [_userTextField.leftLabel setText:@"\U0000e62e"];
        
        _userTextField.textField.placeholder = @"用户名或手机号";
        
        _userTextField.arrowXButton.hidden = NO;
        
        _userTextField.textField.userInteractionEnabled = NO;
        
        [_userTextField.arrowXButton addTarget:self action:@selector(showUsernamesTable) forControlEvents:UIControlEventTouchUpInside];
        
        [_userTextField.arrowXButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    }
    return _userTextField;
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
        
        [_enterButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}

- (UIButton *)forgetPswButton
{
    if (!_forgetPswButton) {
        
        _forgetPswButton = [UIButton new];

        _forgetPswButton.backgroundColor = [UIColor clearColor];
        
        [_forgetPswButton setTitle:kTextForgetPsw forState:UIControlStateNormal];
        
        _forgetPswButton.titleLabel.font = KSYSTEM_FONT_(13);
        
        _forgetPswButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [_forgetPswButton setTitleColor:kQuickLoginNormalTextColor forState:UIControlStateNormal];
        
        [_forgetPswButton setEnlargeEdgeWithTop:8 right:5 bottom:8 left:5];
        
        [_forgetPswButton addTarget:self action:@selector(forgetPsw) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPswButton;
}

- (UIButton *)changeLoginButton
{
    if (!_changeLoginButton) {
        _changeLoginButton = [UIButton new];

        _changeLoginButton.backgroundColor = [UIColor clearColor];
        
        [_changeLoginButton setTitle:kTextChangeLogin forState:UIControlStateNormal];
        
        _changeLoginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [_changeLoginButton setTitleColor:kQuickLoginNormalTextColor forState:UIControlStateNormal];
        
        _changeLoginButton.titleLabel.font = KICON_FONT_(13);
        
        [_changeLoginButton setEnlargeEdgeWithTop:8 right:5 bottom:8 left:5];
        
        [_changeLoginButton addTarget:self action:@selector(changeLogin) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeLoginButton;
}

- (NSMutableArray *)usernamesListArray
{
    if (!_usernamesListArray) {
        _usernamesListArray = [NSMutableArray array];
    }
    return _usernamesListArray;
}

- (UsernamesListView *)userNamesTable
{
    if (!_userNamesTable) {
        _userNamesTable = [UsernamesListView new];
        _userNamesTable.delegate = self;
        _userNamesTable.hidden = YES;
    }
    return _userNamesTable;
}

#pragma mark - 代理

- (void)actionDelete:(NSUInteger)index
{
    WEAK_SELF(weakSelf);
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                   message:@"确定要删除小号?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     //清空用户缓存信息，清除数据库
                                                     UserInfo *user = [UserInfo new];
                                                     user = weakSelf.usernamesListArray[index];
                                                     [[DBManager sharedDBManager] deleteDataWithUserInfo:user];
                                                     [weakSelf refreshUsernamesTable];
                                                     [weakSelf refreshUserTextFieldData];
                                                     
                                                     [weakSelf isSkipToLoginController];
                                                 }];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    
    [alter addAction:sure];
    [alter addAction:cancle];
    
    [self presentViewController:alter animated:YES completion:^{
        
    }];
    
}

- (void)isSkipToLoginController
{
    NSArray *namesArray = [[DBManager sharedDBManager] queryDataUserNames];
    
    if (IS_ARRAY_CLASS(namesArray)) {//有缓存登录用户
        
    }else{
        [[HTGUniteSDK sharedInstance] showLogin];
    }
}

- (void)actionSelected:(NSUInteger)index
{
    self.defaultQuickLoginUser = self.usernamesListArray[index];
    self.userTextField.textField.text = self.defaultQuickLoginUser.username;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         CGAffineTransform transform = self.userTextField.arrowXButton.transform;
                         self.userTextField.arrowXButton.transform = CGAffineTransformRotate(transform, -M_PI);
                     }
                     completion:^(BOOL finished) {
                         [self hiddenUsernamesTable];
                     }];
    
}


@end
