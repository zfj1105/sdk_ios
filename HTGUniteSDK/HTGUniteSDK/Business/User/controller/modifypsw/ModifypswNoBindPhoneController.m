//
//  ModifypswNoBindPhoneController.m
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/24.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "ModifypswNoBindPhoneController.h"
#import "BindphoneController.h"
#import "UserWebBaseController.h"

@interface ModifypswNoBindPhoneController ()<UITextFieldDelegate>

@property (nonatomic, strong) InputTextView *userPhoneNum;             //!<  用户手机号输入框

@property (nonatomic, strong) InputTextView *messageNum;               //!<  短信验证码输入框

@property (nonatomic, strong) InputTextView *newedPsw;                 //!<  新密码输入框

@property (nonatomic, strong) UIButton    *nextButton;                 //!<  下一步按钮

@property (nonatomic, strong) UILabel     *tipsLb;                     //!<  绑定手机号的提示

@property (nonatomic, strong) UIButton    *goBindPhone;                //!<  去绑定手机操作


@end

@implementation ModifypswNoBindPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"改密";
    
    [self editBackImg:@"\U0000e63b"];
    
    self.userPhoneNum.textField.text = [RequestManager sharedManager].loginModel.username;
}

- (void)initSubviews
{
    [super initSubviews];
    
    [self.view addSubview:self.userPhoneNum];
    
    [self.view addSubview:self.messageNum];
    
    [self.view addSubview:self.newedPsw];
    
    [self.view addSubview:self.nextButton];
    
    [self.view addSubview:self.noMessageBtn];
    
    [self.view addSubview:self.tipsView];
    
    [self.tipsView addSubview:self.tipsLb];
    
    [self.tipsView addSubview:self.goBindPhone];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.tipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navigationView.mas_bottom);
        make.height.equalTo(@(20));
    }];
    
    [self.tipsLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.tipsView);
        make.width.equalTo(@(230));
    }];
    
    [self.goBindPhone mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tipsView).offset(-2);
        make.centerY.equalTo(self.tipsLb);
        make.size.mas_equalTo(CGSizeMake(60, 15));
    }];
    
    [self.userPhoneNum mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo((@40));
    }];
    
    [self.messageNum mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userPhoneNum.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo((@40));
    }];
    
    [self.newedPsw mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageNum.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo((@40));
    }];
    
    [self.nextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.newedPsw);
        make.top.equalTo(self.newedPsw.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    [self.noMessageBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nextButton);
        make.top.equalTo(self.nextButton.mas_bottom).offset(5);
        make.height.equalTo(@(30));
    }];
    
    
}

#pragma mark - 懒加载

- (UIView *)tipsView
{
    if (!_tipsView) {
        _tipsView = [UIView new];
        
        _tipsView.backgroundColor = [UIColor colorWithHex:@"#FCF5B2"];
    }
    return _tipsView;
}

- (UILabel *)tipsLb
{
    if (!_tipsLb) {
        _tipsLb = [UILabel new];
        
        _tipsLb.text = kTextModifyPswTips;
        
        _tipsLb.textAlignment = NSTextAlignmentLeft;
        
        _tipsLb.font =KSYSTEM_FONT_(12);
        
        _tipsLb.textColor = [UIColor colorWithHex:@"#101010"];
    }
    return _tipsLb;
}

- (UIButton *)goBindPhone
{
    if (!_goBindPhone) {
        _goBindPhone = [UIButton new];
        
        _goBindPhone.backgroundColor = [UIColor colorWithHex:@"#C41B31"];
        
        [_goBindPhone setTitle:@"绑定手机" forState:UIControlStateNormal];
        
        [_goBindPhone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _goBindPhone.layer.cornerRadius = 2;
        
        _goBindPhone.titleLabel.font = KSYSTEM_FONT_(12);
        
        [_goBindPhone addTarget:self action:@selector(goBindPhone:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goBindPhone;
}


- (InputTextView *)userPhoneNum
{
    if (!_userPhoneNum) {
        _userPhoneNum = [InputTextView new];
        
        _userPhoneNum.textField.delegate = self;
        
        _userPhoneNum.textField.placeholder = @"请输入手机号";
        
        _userPhoneNum.userInteractionEnabled = NO;
        
        _userPhoneNum.leftLabel.text = @"\U0000e693";
        
    }
    return _userPhoneNum;
}

- (InputTextView *)messageNum
{
    if (!_messageNum) {
        _messageNum = [InputTextView new];
        
        _messageNum.textField.delegate = self;
        
        _messageNum.textField.placeholder = @"请输入原密码";
        
        [_messageNum.leftLabel setText:@"\U0000e626"];
        
        _messageNum.textField.secureTextEntry = YES;
        
    }
    return _messageNum;
}

- (InputTextView *)newedPsw
{
    if (!_newedPsw) {
        _newedPsw = [InputTextView new];
        
        _newedPsw.textField.delegate = self;
        
        _newedPsw.textField.placeholder = @"请输入新密码";
        
        _newedPsw.textField.secureTextEntry = YES;
        
        _newedPsw.leftLabel.text = @"\U0000e626";
        
    }
    return _newedPsw;
}


- (UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [UIButton new];
        
        _nextButton.backgroundColor = kQuickLoginNormalTextColor;
        
        [_nextButton setTitle:@"确认修改" forState:UIControlStateNormal];
        
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _nextButton.layer.cornerRadius = 4;
        
        _nextButton.titleLabel.font = KSYSTEM_FONT_(14);
        
        [_nextButton addTarget:self action:@selector(actionModifyPSW:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

- (UIButton *)noMessageBtn
{
    if (!_noMessageBtn) {
        _noMessageBtn = [UIButton new];
        
        _noMessageBtn.backgroundColor = [UIColor clearColor];
        
        [_noMessageBtn setTitle:@"收不到验证码?" forState:UIControlStateNormal];
        
        [_noMessageBtn setTitleColor:[UIColor colorWithHex:@"#939297"] forState:UIControlStateNormal];
        
        _noMessageBtn.titleLabel.font = KSYSTEM_FONT_(12);
        
        _noMessageBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        
        [_noMessageBtn addTarget:self action:@selector(actionNoMessage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noMessageBtn;
}

#pragma mark - 私有函数


- (void)actionNoMessage:(id)sender
{
    UserWebBaseController *controller = [UserWebBaseController new];
    controller.isShowBackButton = YES;
    controller.requestUrlString = H5_HTG_FAQ;
    [self pushViewController:controller];
}

- (void)goBindPhone:(id)sender
{
    [self pushViewController:[BindphoneController new]];
}

- (void)actionModifyPSW:(id)sender
{//修改密码
    
    NSString *username = self.userPhoneNum.textField.text;
    NSString *oldPsw = self.messageNum.textField.text;
    NSString *newPsw = self.newedPsw.textField.text;
    if (!IS_EXIST_STR(username)) {
        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE]
                                         title:kToastTips
                                       message:@"用户名不能为空!"
         ];
        return;
    }
    if (!IS_EXIST_STR(oldPsw)) {
        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE]
                                         title:kToastTips
                                       message:@"原密码不能为空!"
         ];
        return;
    }

    if (!IS_EXIST_STR(newPsw)) {
        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE]
                                         title:kToastTips
                                       message:@"新密码不能为空!"
         ];
        return;
    }
    ModelLogin *user = [RequestManager sharedManager].loginModel;
    NSString *sessionid = user.sessionid;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param addObjectIfNotBlank:HTAC_CHANGEPASSWORD forKey:HTAC];
    [param addObjectIfNotBlank:username forKey:HTSDKUSERNAME];
    [param addObjectIfNotBlank:oldPsw forKey:@"oldpassword"];
    [param addObjectIfNotBlank:newPsw forKey:@"password"];
    [param addObjectIfNotBlank:newPsw forKey:@"password2"];
    [param addObjectIfNotBlank:sessionid forKey:HTSDKSESSIONID];

    [[RequestManager sharedManager] ht_getModifyPswWithParam:param
                                                     success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             [self back];
                                                         });
                                                     } failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                         
                                                     }];
}


@end
