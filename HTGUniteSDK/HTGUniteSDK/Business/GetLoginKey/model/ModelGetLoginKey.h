//
//  ModelGetLoginKey.h
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/20.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HTBaseModel.h"

@interface ModelGetLoginKey : HTBaseModel

@property (nonatomic, strong) NSString *closelogin;  //!< 关闭登录功能

@property (nonatomic, strong) NSString *closepay;   //!< 是否关闭支付

@property (nonatomic, strong) NSString *closereg;   //!< 是否关闭注册

@property (nonatomic, strong) NSString *code;   //!< 返回标识

@property (nonatomic, strong) NSString *gonggaostatus;    //!< 是否关闭公告

@property (nonatomic, strong) NSString *gonggaourl;    //!< 公告地址

@property (nonatomic, strong) NSString *isbandingphone;   //!< 1 该字段不使用

@property (nonatomic, strong) NSString *iscommission;    //!< 1 佣金设置是否开启 1：开启 0：关闭

@property (nonatomic, strong) NSString *isiap;   //!< 是否开启内购

@property (nonatomic, strong) NSString *isopenshiming;   //!< 1 不开启 2 强制实名,无法关闭 3 提醒认证,可关闭

@property (nonatomic, strong) NSString *isreview;    //!< 1 正在审核 0 审核失败、通过、开发中 安卓不做处理

@property (nonatomic, strong) NSString *kefu;   //!< 客服QQ

@property (nonatomic, strong) NSString *manage;  //!< 悬浮窗账号中心

@property (nonatomic, strong) NSString *moreapp;   //!< 悬浮窗 更多游戏

@property (nonatomic, strong) NSString *msg;    //!< 返回描述

@property (nonatomic, strong) NSString *isshare;   //!< 1 分享设置是否开启 1：开启 0：关闭

@property (nonatomic, strong) NSString *pack;   //!< 是否开启悬浮窗礼包

@property (nonatomic, strong) NSString *paylog;   //!< 悬浮窗 充值记录

@property (nonatomic, strong) NSString *phoneregister;   //!< 是否开启手机注册

@property (nonatomic, strong) NSString *shimingrenzheng;   //!< 1 不开启 2 强制认证,无法关闭 3 提醒认证,可关闭

@property (nonatomic, strong) NSString *level;   //!< 上线内购档

@property (nonatomic, strong) NSString *count;   //!< 上线内购次数


@property (nonatomic, strong) NSString *goToAutoLogin;   //!< 标记是否进入自动登录流程  如果为‘0’表示是从用户中心点击‘回到登录’打开的快速登录界面  因此不进行自动登录流程业务 否则为‘1’表示初始化之后进入的快速登录  进入自动登录流程




DEFINE_MODEL_FOR_HEADER


@end
