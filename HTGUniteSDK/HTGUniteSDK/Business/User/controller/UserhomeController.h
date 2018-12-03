//
//  UserhomeController.h
//  HTGUniteSDK
//
//  Created by zfj2602 on 2018/4/16.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "UserCenterBaseController.h"

@interface UserhomeController : UserCenterBaseController

@property (readwrite, nonatomic, strong) UILabel    *iconLb;                        //!< 头像

@property (readwrite, nonatomic, strong) UILabel    *realnameLb;                    //!< 是否实名标识

@property (readwrite, nonatomic, strong) UILabel    *accountNameLb;                 //!< 账号

@property (readwrite, nonatomic, strong) UILabel    *UIDLb;                         //!< UID

@property (readwrite, nonatomic, strong) UILabel    *phoneNumLb;                    //!< 手机号

@property (readwrite, nonatomic, strong) UIButton    *editPhoneNumBtn;                //!< 修改手机号

@property (nonatomic, strong) UIView *buttonContentView;                            //!< 点击事件的背景

@property (nonatomic, strong) UIButton *editPswBtn;                            //!< 修改密码

@property (nonatomic, strong) UILabel *editPswLb;                            //!< 修改密码


@property (nonatomic, strong) UIButton *customerBtn;                            //!< 客服

@property (nonatomic, strong) UILabel *customerLb;                            //!< 客服


@property (nonatomic, strong) UIButton *commissionBtn;                            //!< 佣金

@property (nonatomic, strong) UILabel *commissionLb;                            //!< 佣金

@property (nonatomic, strong) UILabel *commissionAmountLb;                            //!< 佣金金额

@property (readwrite, nonatomic, strong) UILabel    *autoLogin;                    //!< 自动登录

@property (readwrite, nonatomic, strong) UISwitch    *autoLoginSwitch;                    //!< 自动登录switch

@property (nonatomic, strong) UIButton *backToLoginBtn;                            //!< 返回到登录页面


@end
