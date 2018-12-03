//
//  BindphoneController.m
//  HTGUniteSDK
//
//  Created by zfj2602 on 2018/4/16.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "BindphoneController.h"
#import "UserWebBaseController.h"

@interface BindphoneController () <UITextFieldDelegate>

@property (nonatomic, strong) InputTextView *userPhoneNum;             //!<  用户手机号输入框

@property (nonatomic, strong) InputTextView *messageNum;               //!<  短信验证码输入框

@property (nonatomic, strong) UIButton    *nextButton;                 //!<  下一步按钮

@property (nonatomic, strong) UIButton    *noMessageBtn;               //!<  收不到验证码


@end

@implementation BindphoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self editBackImg:@"\U0000e63b"];
    
    self.titleLabel.text = @"绑定";
    
}

- (void)initSubviews
{
    [super initSubviews];
    
    [self.view addSubview:self.userPhoneNum];
    
    [self.view addSubview:self.messageNum];
    
    [self.view addSubview:self.nextButton];
    
    [self.view addSubview:self.noMessageBtn];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.userPhoneNum mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.navigationView.mas_bottom).offset(15);
        make.height.equalTo(@(42));
    }];
    
    [self.messageNum mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.userPhoneNum);
        make.top.equalTo(self.userPhoneNum.mas_bottom).offset(10);
        make.height.equalTo(@(42));
    }];

    [self.nextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.userPhoneNum);
        make.top.equalTo(self.messageNum.mas_bottom).offset(20);
        make.height.equalTo(@(39));
    }];
    
    [self.nextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.userPhoneNum);
        make.top.equalTo(self.messageNum.mas_bottom).offset(20);
        make.height.equalTo(@(39));
    }];

    [self.noMessageBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nextButton);
        make.top.equalTo(self.nextButton.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(100, 12));
    }];
}

#pragma mark - 懒加载

- (InputTextView *)userPhoneNum
{
    if (!_userPhoneNum) {
        _userPhoneNum = [InputTextView new];
        
        _userPhoneNum.textField.delegate = self;
        
        _userPhoneNum.textField.placeholder = @"请输入手机号";
        
        _userPhoneNum.textField.tag = 10000;
        
        _userPhoneNum.leftLabel.text = @"\U0000e693";
        
        [_userPhoneNum.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _userPhoneNum;
}

- (InputTextView *)messageNum
{
    if (!_messageNum) {
        _messageNum = [InputTextView new];
        
        _messageNum.textField.delegate = self;
        
        _messageNum.textField.placeholder = @"请输入验证码";
        
        [_messageNum.leftLabel setText:@"\U0000e60d"];
        
        _messageNum.textField.tag = 10001;
        
        [_messageNum.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        _messageNum.rightButton.hidden = YES;
        
        _messageNum.countDownButton.hidden = NO;
        
        [_messageNum.countDownButton addTarget:self action:@selector(BindPhoneSendMessage:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _messageNum;
}

- (UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [UIButton new];
        
        _nextButton.backgroundColor = kQuickLoginNormalTextColor;
        
        [_nextButton setTitle:@"确认绑定" forState:UIControlStateNormal];
        
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _nextButton.layer.cornerRadius = 4;
        
        _nextButton.titleLabel.font = KSYSTEM_FONT_(14);
        
        [_nextButton addTarget:self action:@selector(BindPhone:) forControlEvents:UIControlEventTouchUpInside];
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


- (void)BindPhoneSendMessage:(id)sender
{
    WEAK_SELF(weakSelf);
    if (![HTUtil isValidMobile:self.userPhoneNum.textField.text]) {
        
        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE]
                                         title:kToastTips
                                       message:@"请输入正确的手机号!"
         ];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param addObjectIfNotBlank:self.userPhoneNum.textField.text forKey:HTSDKPHONE];
    
    [param addObjectIfNotBlank:@"2" forKey:HTSDKTYPE];
    
    [param addObjectIfNotBlank:@"1" forKey:HTSDKBDINDTYPE];//绑定手机号
    
    [param addObjectIfNotBlank:[RequestManager sharedManager].loginModel.sessionid forKey:HTSDKSESSIONID];
    
    [param addObjectIfNotBlank:[RequestManager sharedManager].loginModel.username forKey:HTSDKUSERNAME];
    
    [[RequestManager sharedManager] ht_getCheckCodeWithParam:param
                                                     success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             [weakSelf.messageNum actionStartCountDown];
                                                         });
                                                     } failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                         
                                                     }];
}

- (void)BindPhone:(id)sender
{
    if (![HTUtil isValidMobile:self.userPhoneNum.textField.text]) {
        
        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE]
                                         title:kToastTips
                                       message:@"请输入正确的手机号!"
         ];
        return;
    }

   __block  NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param addObjectIfNotBlank:self.userPhoneNum.textField.text forKey:HTSDKPHONE];
    
    [param addObjectIfNotBlank:@"2" forKey:HTSDKTYPE];
    
    [param addObjectIfNotBlank:@"1" forKey:HTSDKBDINDTYPE];//绑定手机号
    
    [param addObjectIfNotBlank:[RequestManager sharedManager].loginModel.sessionid forKey:HTSDKSESSIONID];
    
    [param addObjectIfNotBlank:[RequestManager sharedManager].loginModel.username forKey:HTSDKUSERNAME];
    
    [param addObjectIfNotBlank:self.messageNum.textField.text forKey:@"code"];
    
    [[RequestManager sharedManager] ht_getBindPhoneWithParam:param
                                                     success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                         [RequestManager sharedManager].loginModel.ischeck = @"1";
                                                         [RequestManager sharedManager].loginModel.userphone = param[HTSDKPHONE];
                                                         [RequestManager sharedManager].loginModel.remark = @"0";
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             [self back];
                                                         });
                                                     } failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                         
                                                     }];
}

- (void)actionNoMessage:(id)sender
{
    UserWebBaseController *controller = [UserWebBaseController new];
    controller.isShowBackButton = YES;
    controller.requestUrlString = H5_HTG_FAQ;
    [self pushViewController:controller];
}


#pragma mark - 输入框代理

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.tag == 10001) {//验证码
        
    }else if (textField.tag == 10000){//手机号输入框
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

@end
