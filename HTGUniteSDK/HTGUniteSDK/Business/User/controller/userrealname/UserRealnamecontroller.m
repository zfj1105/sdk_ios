//
//  UserRealnamecontroller.m
//  HTGUniteSDK
//
//  Created by zfj2602 on 2018/4/16.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "UserRealnamecontroller.h"
#import "UserRerealnameController.h"

@interface UserRealnamecontroller () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel     *tipsLb;                   //!<  提示信息框视图

@property (nonatomic, strong) InputTextView *userRealname;             //!<  真实姓名

@property (nonatomic, strong) InputTextView *idcardNum;               //!<  身份证号码


@end

@implementation UserRealnamecontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"实名认证";
    
    [self editBackImg:@"\U0000e63b"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    WEAK_SELF(weakSelf);
    
    [[RequestManager sharedManager] ht_getRealNameStateWithParam:nil
                                                         success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                             [weakSelf loadData];
                                                         } failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                             
                                                         }];
}

- (void)initSubviews
{
    [super initSubviews];
    
    [self.view addSubview:self.tipsLb];
    
    [self.view addSubview:self.realnameState];
    
    [self.view addSubview:self.userRealname];

    [self.view addSubview:self.idcardNum];

    [self.view addSubview:self.nextButton];
    
    [self.view addSubview:self.reRealnameButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.tipsLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(@(30));
    }];
    
    [self.realnameState mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.tipsLb.mas_bottom).offset(10);
        make.height.mas_equalTo(@(12));
    }];
    
    [self.userRealname mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.realnameState.mas_bottom).offset(10);
        make.height.equalTo(@(42));
    }];

    [self.idcardNum mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.userRealname.mas_bottom).offset(10);
        make.height.equalTo(@(42));
    }];

    [self.nextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.userRealname);
        make.top.equalTo(self.idcardNum.mas_bottom).offset(20);
        make.height.equalTo(@(39));
    }];
    
    [self.reRealnameButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.userRealname);
        make.top.equalTo(self.idcardNum.mas_bottom).offset(20);
        make.height.equalTo(@(39));
    }];


}

#pragma mark  - 懒加载

- (UILabel *)tipsLb
{
    if (!_tipsLb) {
        _tipsLb = [UILabel new];
        
        _tipsLb.font = [UIFont systemFontOfSize:12];
        
        _tipsLb.textColor = [UIColor colorWithHex:@"#888888"];
        
        _tipsLb.numberOfLines = 2;
        
        _tipsLb.textAlignment = NSTextAlignmentLeft;
        
        _tipsLb.text = kUserRealnameTopTips;
    }
    return _tipsLb;
}

- (UILabel *)realnameState
{
    if (!_realnameState) {
        _realnameState = [UILabel new];

        _realnameState.font = [UIFont systemFontOfSize:12];


        _realnameState.textAlignment = NSTextAlignmentCenter;

        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"认证状态：未认证"]];
        
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#B7B9BC"] range:NSMakeRange(0,5)];
        
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#D3404C"] range:NSMakeRange(5,3)];
        
        _realnameState.attributedText = attributeString;

    }
    return _realnameState;
}

- (InputTextView *)userRealname
{
    if (!_userRealname) {
        _userRealname = [InputTextView new];

        _userRealname.textField.delegate = self;

        _userRealname.textField.placeholder = @"请输入真实姓名";

        _userRealname.leftLabel.text = @"\U0000e62e";

    }
    return _userRealname;
}

- (InputTextView *)idcardNum
{
    if (!_idcardNum) {
        _idcardNum = [InputTextView new];

        _idcardNum.textField.delegate = self;

        _idcardNum.textField.placeholder = @"请输入身份证号码";

        _idcardNum.textField.delegate = self;

        [_idcardNum.leftLabel setText:@"\U0000e674"];

    }
    return _idcardNum;
}

- (UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [UIButton new];

        _nextButton.backgroundColor = kQuickLoginNormalTextColor;

        [_nextButton setTitle:@"提交认证" forState:UIControlStateNormal];

        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        _nextButton.layer.cornerRadius = 4;

        _nextButton.titleLabel.font = KSYSTEM_FONT_(14);
        
        _nextButton.hidden = NO;
        
        [_nextButton addTarget:self action:@selector(actionRealName:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

- (UIButton *)reRealnameButton
{
    if (!_reRealnameButton) {
        _reRealnameButton = [UIButton new];
        
        [_reRealnameButton setTitle:@"重新认证 >" forState:UIControlStateNormal];
        
        [_reRealnameButton setTitleColor:[UIColor colorWithHex:@"#68C389"]  forState:UIControlStateNormal];
        
        _reRealnameButton.titleLabel.font = KSYSTEM_FONT_(14);
        
        _reRealnameButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _reRealnameButton.hidden = YES;
        
        [_reRealnameButton addTarget:self action:@selector(actionreRealname:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reRealnameButton;
}

- (void)actionRealName:(id)sender
{
    WEAK_SELF(weakSelf);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *username = [RequestManager sharedManager].loginModel.username;
    NSString *realname = self.userRealname.textField.text;
    NSString *idcard = self.idcardNum.textField.text;
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
                                                                                           message:@"认证成功，欢迎进入游戏"
                                                             ];
                                                            [weakSelf back];
                                                        });
                                                    } failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                        
                                                    }];
}

//重新认证
- (void)actionreRealname:(id)sender
{
    [self pushViewController:[UserRerealnameController new]];
}

- (void)loadData
{
    WEAK_SELF(weakSelf);
    __block NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"认证状态：未认证"]];
    __block NSString *isshiming = [RequestManager sharedManager].loginModel.isshiming;
    
    __block NSString *realname = [RequestManager sharedManager].loginModel.realname;
    
    __block NSString *idcard = [RequestManager sharedManager].loginModel.idcard;

    if (IS_EXIST_STR(isshiming) && [isshiming isEqualToString:@"1"]) {//已认证
        attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"认证状态：已认证"]];
        
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#B7B9BC"] range:NSMakeRange(0,5)];
        
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#65BC81"] range:NSMakeRange(5,3)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.reRealnameButton.hidden = NO;
            
            weakSelf.nextButton.hidden = YES;
            
            weakSelf.userRealname.textField.text = realname;
            NSString *idCardNew = [idcard stringByReplacingCharactersInRange:NSMakeRange(3, 11) withString:@"***********"];
            weakSelf.idcardNum.textField.text = idCardNew;
            
            weakSelf.userRealname.textField.userInteractionEnabled = NO;
            weakSelf.idcardNum.textField.userInteractionEnabled = NO;
        });

    }else{
        
        
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#B7B9BC"] range:NSMakeRange(0,5)];
        
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#D3404C"] range:NSMakeRange(5,3)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.userRealname.textField.userInteractionEnabled = YES;
            weakSelf.idcardNum.textField.userInteractionEnabled = YES;

            weakSelf.reRealnameButton.hidden = YES;
            
            weakSelf.nextButton.hidden = NO;
        });

    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.realnameState.attributedText = attributeString;
    });
}

@end
