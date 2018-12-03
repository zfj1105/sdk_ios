//
//  UserhomeController.m
//  HTGUniteSDK
//
//  Created by zfj2602 on 2018/4/16.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "UserhomeController.h"
#import "QuickLoginViewController.h"
#import "BindphoneController.h"
#import "UserRealnamecontroller.h"
#import "ModifyPswController.h"
#import "ReliveBindphoneController.h"
#import "ModifypswNoBindPhoneController.h"

#import "UserWebBaseController.h"
#import "HTPangestureButtonManager.h"

@interface UserhomeController ()

@end

@implementation UserhomeController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.scrollLabelView.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //重置‘修改手机号’按钮的位置
    ModelLogin *quickModel = [RequestManager sharedManager].loginModel;
    WEAK_SELF(weakSelf);
    if ([quickModel.ischeck isEqualToString:@"1"]) {
        [self.editPhoneNumBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.phoneNumLb.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(15, 15));
            make.centerY.equalTo(weakSelf.phoneNumLb);
        }];
    }else{
        [self.editPhoneNumBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.phoneNumLb.mas_right).offset(-25);
            make.size.mas_equalTo(CGSizeMake(15, 15));
            make.centerY.equalTo(weakSelf.phoneNumLb);
        }];
    }
    
    [self loadData];

}

- (void)back{}

- (void)initSubviews
{
    [super initSubviews];
    
    [self.view addSubview:self.iconLb];
    
    [self.iconLb addSubview:self.realnameLb];
    
    [self.view addSubview:self.accountNameLb];
    
    [self.view addSubview:self.UIDLb];
    
    [self.view addSubview:self.phoneNumLb];
    
    [self.view addSubview:self.editPhoneNumBtn];
    
    [self.view addSubview:self.buttonContentView];
    
    [self.buttonContentView addSubview:self.editPswBtn];
    
    [self.buttonContentView addSubview:self.commissionBtn];
    
    [self.buttonContentView addSubview:self.customerBtn];
    
    [self.buttonContentView addSubview:self.editPswLb];
    
    [self.buttonContentView addSubview:self.customerLb];
    
    [self.buttonContentView addSubview:self.commissionLb];
    
    [self.buttonContentView addSubview:self.commissionAmountLb];
    
    [self.view addSubview:self.autoLogin];
    
    [self.view addSubview:self.autoLoginSwitch];
    
    [self.view addSubview:self.backToLoginBtn];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    WEAK_SELF(weakSelf);
    
    [self.iconLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.top.equalTo(weakSelf.navigationView.mas_bottom).offset(20);
    }];
    
    [self.realnameLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.iconLb);
        make.bottom.equalTo(weakSelf.iconLb).offset(5);
        make.size.mas_equalTo(CGSizeMake(50, 13));
    }];
    
    [self.accountNameLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconLb);
        make.left.equalTo(weakSelf.iconLb.mas_right).offset(24);
        make.size.mas_equalTo(CGSizeMake(150, 13));
    }];
    
    [self.UIDLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.accountNameLb);
        make.top.equalTo(weakSelf.accountNameLb.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(104, 13));
    }];
    
    [self.phoneNumLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.UIDLb.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.UIDLb);
        make.size.mas_equalTo(CGSizeMake(135, 13));
    }];
    
    [self.editPhoneNumBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.phoneNumLb.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.equalTo(weakSelf.phoneNumLb);
    }];
    
    [self.buttonContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.editPhoneNumBtn.mas_bottom).offset(20);
        make.height.equalTo(@(90));
        make.left.equalTo(weakSelf.view).offset(20);
        make.width.equalTo(@(261));
    }];
    
    [self.editPswBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(weakSelf.buttonContentView);
        make.width.equalTo(@(87));
    }];
    
    [self.editPswLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.editPswBtn).offset(-15);
        make.size.mas_equalTo(CGSizeMake(30, 14));
        make.centerX.equalTo(weakSelf.editPswBtn);
    }];
    
    [self.customerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf.buttonContentView);
        make.left.equalTo(weakSelf.editPswBtn.mas_right);
        make.width.equalTo(@(87));
    }];
    
    [self.customerLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.customerBtn).offset(-15);
        make.size.mas_equalTo(CGSizeMake(30, 14));
        make.centerX.equalTo(weakSelf.customerBtn);
    }];
    
    [self.commissionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf.buttonContentView);
        make.right.equalTo(weakSelf.buttonContentView);
        make.left.equalTo(weakSelf.customerBtn.mas_right);
    }];
    
    [self.commissionLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.commissionBtn).offset(-15);
        make.size.mas_equalTo(CGSizeMake(30, 14));
        make.centerX.equalTo(weakSelf.commissionBtn);
    }];
    
    [self.commissionAmountLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.commissionBtn);
        make.size.mas_equalTo(CGSizeMake(80, 10));
        make.bottom.equalTo(weakSelf.commissionBtn).offset(-2);
    }];

    [self.autoLogin mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.buttonContentView);
        make.size.mas_equalTo(CGSizeMake(90, 15));
        make.top.equalTo(weakSelf.buttonContentView.mas_bottom).offset(25);
    }];
    
    [self.autoLoginSwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.autoLogin.mas_right).offset(5);
        make.centerY.equalTo(weakSelf.autoLogin);
    }];
    
    [self.backToLoginBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.autoLogin);
        make.width.equalTo(@(80));
        make.right.equalTo(weakSelf.buttonContentView.mas_right);
    }];

}

#pragma mark - 懒加载

- (UILabel *)iconLb
{
    if (!_iconLb) {
        _iconLb = [UILabel new];
        
        _iconLb.font = KICON_FONT_(50);
        
        _iconLb.textAlignment = NSTextAlignmentCenter;
        
        _iconLb.text = @"\U0000e604";
        
        _iconLb.userInteractionEnabled = YES;
        
        _iconLb.multipleTouchEnabled = YES;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(actionTapRealname:)];
        
        [_iconLb addGestureRecognizer:tapGestureRecognizer];

        
    }
    return _iconLb;
}

- (UILabel *)realnameLb
{
    if (!_realnameLb) {
        _realnameLb = [UILabel new];
        
        _realnameLb.font = KSYSTEM_FONT_BOLD_(10);
        
        _realnameLb.text = @"已实名";
        
        _realnameLb.layer.cornerRadius = 2;
        
        _realnameLb.clipsToBounds = YES;
        
        _realnameLb.textAlignment = NSTextAlignmentCenter;
        
        _realnameLb.textColor = [UIColor whiteColor];
        
        _realnameLb.backgroundColor = [UIColor colorWithHex:@"#00E460"];
        
        _realnameLb.userInteractionEnabled = YES;
        
        _realnameLb.multipleTouchEnabled = YES;
    
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(actionTapRealname:)];
        
        [_realnameLb addGestureRecognizer:tapGestureRecognizer];

    }
    return _realnameLb;
}

- (UILabel *)accountNameLb
{
    if (!_accountNameLb) {
        _accountNameLb = [UILabel new];
        
        _accountNameLb.font = KSYSTEM_FONT_(13);
        
        _accountNameLb.text = @"账号：ht10010";
        
        _accountNameLb.textAlignment = NSTextAlignmentLeft;
        
        _accountNameLb.textColor = [UIColor colorWithHex:@"#101010"];
        
        _accountNameLb.adjustsFontSizeToFitWidth = YES;
        
    }
    return _accountNameLb;
}

- (UILabel *)UIDLb
{
    if (!_UIDLb) {
        _UIDLb = [UILabel new];
        
        _UIDLb.font = KSYSTEM_FONT_(13);
        
        _UIDLb.text = @"UID：1001";
        
        _UIDLb.textAlignment = NSTextAlignmentLeft;
        
        _UIDLb.textColor = [UIColor colorWithHex:@"#101010"];
        
    }
    return _UIDLb;
}

- (UILabel *)phoneNumLb
{
    if (!_phoneNumLb) {
        _phoneNumLb = [UILabel new];
        
        _phoneNumLb.font = KSYSTEM_FONT_(13);
        
        _phoneNumLb.text = @"手机号：186***98";
        
        _phoneNumLb.textAlignment = NSTextAlignmentLeft;
        
        _phoneNumLb.textColor = [UIColor colorWithHex:@"#101010"];
        
    }
    return _phoneNumLb;
}

- (UIButton *)editPhoneNumBtn
{
    if (!_editPhoneNumBtn) {
        _editPhoneNumBtn = [UIButton new];
        
        _editPhoneNumBtn.titleLabel.font = KICON_FONT_(15);
        
        [_editPhoneNumBtn setTitle:@"\U0000e678" forState:UIControlStateNormal];
        
        [_editPhoneNumBtn setTitleColor:[UIColor colorWithHex:@"#101010"] forState:UIControlStateNormal];
        
        [_editPhoneNumBtn addTarget:self action:@selector(acitonBindphone:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editPhoneNumBtn;
}

- (UIView *)buttonContentView
{
    if (!_buttonContentView) {
        _buttonContentView = [UIView new];
        
        _buttonContentView.backgroundColor = [UIColor colorWithHex:@"#FFFFFF"];
        
    }
    return _buttonContentView;
}

- (UIButton *)editPswBtn
{
    if (!_editPswBtn) {
        _editPswBtn = [UIButton new];
        
        _editPswBtn.titleLabel.font = KICON_FONT_(30);
        
        [_editPswBtn setTitle:@"\U0000e626" forState:UIControlStateNormal];
        
        [_editPswBtn setTitleColor:[UIColor colorWithHex:@"#00c776"] forState:UIControlStateNormal];
        
        _editPswBtn.contentEdgeInsets = UIEdgeInsetsMake(0,0, 25, 0);
        
        _editPswBtn.layer.borderColor = [UIColor colorWithHex:@"#BBBBBB"].CGColor;
        
        _editPswBtn.layer.borderWidth = 1;
        
        [_editPswBtn addTarget:self action:@selector(actionModifyPsw:) forControlEvents:UIControlEventTouchUpInside];
        

    }
    return _editPswBtn;
}

- (UILabel *)editPswLb
{
    if (!_editPswLb) {
        _editPswLb = [UILabel new];
        
        _editPswLb.font = KSYSTEM_FONT_BOLD_(14);
        
        _editPswLb.text = @"改密";
        
        _editPswLb.textAlignment = NSTextAlignmentCenter;
        
        _editPswLb.textColor = [UIColor colorWithHex:@"#4f4f4f"];
        
    }
    return _editPswLb;
}


- (UIButton *)customerBtn
{
    if (!_customerBtn) {
        _customerBtn = [UIButton new];
        
        _customerBtn.titleLabel.font = KICON_FONT_(30);
        
        [_customerBtn setTitle:@"\U0000e687" forState:UIControlStateNormal];
        
        [_customerBtn setTitleColor:[UIColor colorWithHex:@"#4DAAFF"] forState:UIControlStateNormal];
        
        _customerBtn.contentEdgeInsets = UIEdgeInsetsMake(0,0, 25, 0);
        
        [_customerBtn addTarget:self action:@selector(actionCustomer:) forControlEvents:UIControlEventTouchUpInside];
        
        _customerBtn.layer.borderColor = [UIColor colorWithHex:@"#BBBBBB"].CGColor;
        
        _customerBtn.layer.borderWidth = 1;
    }
    return _customerBtn;
}

- (UILabel *)customerLb
{
    if (!_customerLb) {
        _customerLb = [UILabel new];
        
        _customerLb.font = KSYSTEM_FONT_BOLD_(14);
        
        _customerLb.text = @"客服";
        
        _customerLb.textAlignment = NSTextAlignmentCenter;
        
        _customerLb.textColor = [UIColor colorWithHex:@"#4f4f4f"];
        
    }
    return _customerLb;
}


- (UIButton *)commissionBtn
{
    if (!_commissionBtn) {
        _commissionBtn = [UIButton new];
        
        _commissionBtn.titleLabel.font = KICON_FONT_(30);
        
        [_commissionBtn setTitle:@"\U0000e627" forState:UIControlStateNormal];
        
        _commissionBtn.contentEdgeInsets = UIEdgeInsetsMake(0,0, 25, 0);
        
        [_commissionBtn setTitleColor:[UIColor colorWithHex:@"#FF5860"] forState:UIControlStateNormal];
        
        _commissionBtn.layer.borderColor = [UIColor colorWithHex:@"#BBBBBB"].CGColor;
        
        _commissionBtn.layer.borderWidth = 1;
        
        [_commissionBtn addTarget:self action:@selector(actionCommison:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _commissionBtn;
}

- (UILabel *)commissionLb
{
    if (!_commissionLb) {
        _commissionLb = [UILabel new];
        
        _commissionLb.font = KSYSTEM_FONT_BOLD_(14);
        
        _commissionLb.text = @"佣金";
        
        _commissionLb.textAlignment = NSTextAlignmentCenter;
        
        _commissionLb.textColor = [UIColor colorWithHex:@"#4f4f4f"];
        
    }
    return _commissionLb;
}

- (UILabel *)commissionAmountLb
{
    if (!_commissionAmountLb) {
        _commissionAmountLb = [UILabel new];
        
        _commissionAmountLb.font = KSYSTEM_FONT_BOLD_(10);
        
        _commissionAmountLb.text = @"￥0.00元";
        
        _commissionAmountLb.textAlignment = NSTextAlignmentCenter;
        
        _commissionAmountLb.textColor = [UIColor colorWithHex:@"#FF5860"];
        
    }
    return _commissionAmountLb;
}

- (UILabel *)autoLogin
{
    if (!_autoLogin) {
        _autoLogin = [UILabel new];
        
        _autoLogin.font = KICON_FONT_(15);
        
        _autoLogin.textAlignment = NSTextAlignmentLeft;
        
        _autoLogin.textColor = [UIColor colorWithHex:@"#838383"];
        
        _autoLogin.text = @"\U0000e600   自动登录";
        
    }
    return _autoLogin;
}

- (UISwitch *)autoLoginSwitch
{
    if ((!_autoLoginSwitch)) {
        _autoLoginSwitch = [UISwitch new];
        
        _autoLoginSwitch.transform = CGAffineTransformMakeScale(.65, 0.65);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSNumber *isAutoLogin = [defaults objectForKey:kISAutoLogin];
        
        [_autoLoginSwitch setOn:isAutoLogin.boolValue];
        
        [_autoLoginSwitch addTarget:self action:@selector(actionSwitchAutoLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _autoLoginSwitch;
}

- (UIButton *)backToLoginBtn
{
    if (!_backToLoginBtn) {
        _backToLoginBtn = [UIButton new];
        
        _backToLoginBtn.titleLabel.font = KSYSTEM_FONT_BOLD_(14);
        
        [_backToLoginBtn setTitle:@"回到登录" forState:UIControlStateNormal];
        
        [_backToLoginBtn setTitleColor:[UIColor colorWithHex:@"#00E460"] forState:UIControlStateNormal];
        
        _backToLoginBtn.layer.borderColor = [UIColor colorWithHex:@"#00E460"].CGColor;
        
        _backToLoginBtn.layer.borderWidth = 1;
        
        _backToLoginBtn.layer.cornerRadius = 5;
        
        _backToLoginBtn.clipsToBounds = YES;
        
        [_backToLoginBtn addTarget:self action:@selector(acitonBackLogin:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _backToLoginBtn;
}


#pragma mark - 自定义事件

- (void)actionModifyPsw:(id)sender
{
    WEAK_SELF(weakSelf);
    if ([[RequestManager sharedManager].loginModel.remark isEqualToString:@"1"]) {//游客账号不能修改密码
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                       message:@"您当前账号为游客账号，需要先绑定手机才能修改密码"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"去绑定"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [weakSelf pushViewController:[BindphoneController new]];
                                                     }];
        
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消"
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
        
        [alter addAction:sure];
        [alter addAction:cancle];
        
        [self presentViewController:alter animated:YES completion:^{
            
        }];
        return;
    }
    
    if ([[RequestManager sharedManager].loginModel.ischeck isEqualToString:@"1"]) {//绑定过手机号
        [self pushViewController:[ModifyPswController new]];
    }else{
        [self pushViewController:[ModifypswNoBindPhoneController new]];
    }
}


- (void)actionCustomer:(id)sender
{
    UserWebBaseController *controller = [UserWebBaseController new];
    controller.isShowBackButton = YES;
    controller.requestUrlString = H5_HTG_FAQ;
    [self pushViewController:controller];

}

- (void)acitonBackLogin:(id)sender
{
    [RequestManager sharedManager].getLoginKeymodel.goToAutoLogin = @"0";//标记不自动登录，如果需要自动登录不光此字段未‘1’而且需要本地表示nsuserdefaults字段打开(即自动登录开关按钮打开)
    [[RequestManager sharedManager] resetNull];
    [[HTPangestureButtonManager sharedManager] hiddenHTPanGestureButton];
    HTPOSTNOTIFICATION(kHTGUniteSDKLogoutNotification);  //注销
    if ([[RequestManager sharedManager].showLoginAfterLogout isEqualToString:@"1"]) {
        [self pushViewController:[QuickLoginViewController new]];
    }else{
//        [[HTPangestureButtonManager sharedManager] showHTPanGestureButtonInKeyWindow];
        
        [[LoginWindow sharedInstance] dismiss];
    }
}

- (void)acitonBindphone:(id)sender
{
    if ([[RequestManager sharedManager].loginModel.ischeck isEqualToString:@"1"]) {//解绑
        [self pushViewController:[ReliveBindphoneController new]];
    }else{//绑定
        [self pushViewController:[BindphoneController new]];
    }
}

- (void)actionTapRealname:(UITapGestureRecognizer *)gesture
{
    [self pushViewController:[UserRealnamecontroller new]];
}

- (void)actionCommison:(UITapGestureRecognizer *)gesture
{
    if ([[RequestManager sharedManager].getLoginKeymodel.iscommission isEqualToString:@"1"]) {
        //佣金提现
        UserWebBaseController *controller = [UserWebBaseController new];
        controller.isShowBackButton = YES;
        controller.requestUrlString = H5_HTG_WITHDRAW;
        [self pushViewController:controller];
    }else{
        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE] title:kToastTips message:kNOTOpenText];
    }
}

- (void)loadCommisonAmount
{
    WEAK_SELF(weakSelf);

    if ([[RequestManager sharedManager].getLoginKeymodel.iscommission isEqualToString:@"1"]) {
        self.commissionAmountLb.hidden = NO;
        
        [[RequestManager sharedManager] ht_getcommissioninfoWithParam:nil
                                                              success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                                  NSString *commisionAmount = [RequestManager sharedManager].loginModel.commisionAmount;
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      weakSelf.commissionAmountLb.text = [NSString stringWithFormat:@"%@%@%@", @"￥",commisionAmount,@"元"];
                                                                  });
                                                              } failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                                  
                                                              }];
    }else{
        self.commissionAmountLb.hidden = YES;
    }
}

//TODO:加载数据
- (void)loadData
{
    WEAK_SELF(weakSelf);

    ModelLogin *quickModel = [RequestManager sharedManager].loginModel;
    if ([quickModel.isshiming isEqualToString:@"1"]) {//已实名
        weakSelf.realnameLb.text = @"已实名";
        weakSelf.realnameLb.backgroundColor = [UIColor colorWithHex:@"#00E460"];
    }else{
        weakSelf.realnameLb.text = @"未实名";
        weakSelf.realnameLb.backgroundColor = [UIColor colorWithHex:@"#FF575A"];
    }
    
    weakSelf.accountNameLb.text = [NSString stringWithFormat:@"账号：%@", quickModel.username];
    weakSelf.UIDLb.text = [NSString stringWithFormat:@"UID：%@", quickModel.uid];
    if ([quickModel.ischeck isEqualToString:@"1"]) {
        NSString *phone = quickModel.userphone;
        if (IS_EXIST_STR(phone) && phone.length>7) {
            phone = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
        weakSelf.phoneNumLb.text = [NSString stringWithFormat:@"手机号：%@",phone];
        weakSelf.phoneNumLb.textColor = [UIColor colorWithHex:@"#101010"];
    }else{
        NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"手机号：未绑定"]];
        
        [aString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#101010"]range:NSMakeRange(0,4)];
        
        [aString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#FF575A"]range:NSMakeRange(4,3)];
        
        weakSelf.phoneNumLb.attributedText= aString;
        
    }
    
    [self loadCommisonAmount];
}

- (void)actionSwitchAutoLogin:(id)sender
{
    if (self.autoLoginSwitch.isOn) {
        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE]
                                         title:kToastTips
                                       message:@"打开后每次可直接登录账号进入游戏"
         ];
    }else{
        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE]
                                         title:kToastTips
                                       message:@"关闭后每次进入游戏可重新选择账号登录"
         ];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber *isAutoLogin = [NSNumber numberWithBool:self.autoLoginSwitch.isOn];
    
    [defaults setObject:isAutoLogin forKey:kISAutoLogin];
    
    [defaults synchronize];
}

#pragma makr - TXScrollLabelView 代理

- (void)scrollLabelView:(TXScrollLabelView *)scrollLabelView didClickWithText:(NSString *)text atIndex:(NSInteger)index
{
    if ([[RequestManager sharedManager].getLoginKeymodel.isshare isEqualToString:@"1"]) {
        UserWebBaseController *controller = [UserWebBaseController new];
        controller.isShowBackButton = YES;
        controller.requestUrlString = H5_HTG_ACTIVITY;
        controller.titleText = kTXScrollLabelViewText;
        [self pushViewController:controller];
    }else{
        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE] title:kToastTips message:kNOTOpenText];
    }
    
}


@end
