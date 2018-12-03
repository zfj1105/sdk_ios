//
//  RealnameController.m
//  HTGUniteSDK
//
//  Created by zfj2602 on 2018/4/13.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "RealnameController.h"
#import "UIColor+Addition.h"

@interface RealnameController () <UITextFieldDelegate>

@property (nonatomic, strong) InputTextView *usernameField;          //!<  实名用户姓名

@property (nonatomic, strong) InputTextView *IDCardField;            //!<  实名用户身份证

@property (nonatomic, strong) UIButton    *cancelButton;             //!<  取消实名按钮

@property (nonatomic, strong) UIButton    *conmmitButton;            //!<  提交实名认证按钮

@property (nonatomic, strong) UILabel     *tipsLb;                   //!<  提示信息框视图


@end

@implementation RealnameController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"实名认证";
    
}

- (void)initSubviews
{
    [super initSubviews];
    
    [self.view addSubview:self.usernameField];
    
    [self.view addSubview:self.IDCardField];
    
    [self.view addSubview:self.cancelButton];
    
    [self.view addSubview:self.conmmitButton];
    
    [self.view addSubview:self.tipsLb];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.usernameField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(60);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo((@40));
    }];
    
    [self.IDCardField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameField.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo((@40));
    }];
    
    [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.IDCardField);
        make.right.equalTo(self.view.mas_left).offset(145);
        make.top.equalTo(self.IDCardField.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    [self.conmmitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.IDCardField);
        make.left.equalTo(self.view).offset(150);
        make.top.equalTo(self.cancelButton);
        make.height.mas_equalTo(40);
    }];
    
    [self.tipsLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.IDCardField);
        make.top.equalTo(self.conmmitButton.mas_bottom).offset(15);
        make.height.equalTo(@(30));
    }];

}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self customNavigationControllerWithWidth:NAVIGATIONCONTROLLERHWIDTH height:250 isCenterInParent:YES originY:0];
    
}

#pragma mark - 懒加载

- (InputTextView *)usernameField
{
    if (!_usernameField) {
        _usernameField = [InputTextView new];
        
        _usernameField.backgroundColor = [UIColor whiteColor];
        
        _usernameField.textField.delegate = self;
        
        _usernameField.textField.placeholder = @"请输入真实姓名";
        
        _usernameField.leftLabel.text = @"\U0000e62e";
        
    }
    return _usernameField;
}

- (InputTextView *)IDCardField
{
    if (!_IDCardField) {
        _IDCardField = [InputTextView new];
        
        _IDCardField.backgroundColor = [UIColor whiteColor];
        
        _IDCardField.textField.delegate = self;
        
        _IDCardField.textField.placeholder = @"请输入身份证号码";
        
        _IDCardField.leftLabel.text = @"\U0000E674";
    }
    return _IDCardField;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [UIButton new];
        
        _cancelButton.backgroundColor = kQuickLoginCancelTextColor;
        
        [_cancelButton setTitle:kTextCancelGanme forState:UIControlStateNormal];
        
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _cancelButton.layer.cornerRadius = 4;
        
        _cancelButton.titleLabel.font = KSYSTEM_FONT_(14);
        
        [_cancelButton addTarget:self action:@selector(actionDismissWindow:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)conmmitButton
{
    if (!_conmmitButton) {
        _conmmitButton = [UIButton new];
        
        _conmmitButton.backgroundColor = kQuickLoginNormalTextColor;
        
        [_conmmitButton setTitle:@"提交认证" forState:UIControlStateNormal];
        
        [_conmmitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _conmmitButton.layer.cornerRadius = 4;
        
        _conmmitButton.titleLabel.font = KSYSTEM_FONT_(14);
        
        [_conmmitButton addTarget:self action:@selector(actionRealName:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _conmmitButton;
}

- (UILabel *)tipsLb
{
    if (!_tipsLb) {
        _tipsLb = [UILabel new];
        
        _tipsLb.font = [UIFont systemFontOfSize:12];
        
        _tipsLb.textColor = [UIColor colorWithHex:@"#BFBFBF"];
        
        _tipsLb.numberOfLines = 2;
        
        _tipsLb.textAlignment = NSTextAlignmentLeft;
        
        _tipsLb.text = kRealnameBottomTips;
    }
    return _tipsLb;
}

- (void)actionDismissWindow:(id)sender
{
    [[RequestManager sharedManager] skipToAnnouncement];
}

- (void)actionRealName:(id)sender
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *username = [RequestManager sharedManager].loginModel.username;
    NSString *realname = self.usernameField.textField.text;
    NSString *idcard = self.IDCardField.textField.text;
    if (!IS_EXIST_STR(realname) || !IS_EXIST_STR(idcard)) {
        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE]
                                         title:kToastTips
                                       message:@"姓名或身份证号码不能为空!"
         ];

        return;
    }
    [param addObjectIfNotBlank:@"1" forKey:HTSDKTYPE];//'1'认证  ‘2’重新认证
    [param addObjectIfNotBlank:idcard forKey:@"idcard"];
    [param addObjectIfNotBlank:username forKey:@"username"];
    [param addObjectIfNotBlank:realname forKey:@"realname"];
    
    [[RequestManager sharedManager] ht_getRealNameWithParam:param
                                                    success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                        [RequestManager sharedManager].loginModel.isshiming = @"1";  //fix by zfj 5.8  标记已实名
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE]
                                                                                             title:kToastTips
                                                                                           message:@"认证成功"
                                                             ];
                                                            [[RequestManager sharedManager] skipToAnnouncement];
                                                        });

                                                    } failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                        
                                                    }];
}

@end
