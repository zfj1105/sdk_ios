//
//  ModelLogin.h
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/20.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTBaseModel.h"

@interface ModelLogin : HTBaseModel

@property (nonatomic, strong) NSString *code;

@property (nonatomic, strong) NSString *ischeck;  //!<  是否进行了绑定手机号操作1：已绑定 0：未绑定

@property (nonatomic, strong) NSString *isidcard;   //!<    是否进行了绑定身份证操作1：已绑定 0：未绑定

@property (nonatomic, strong) NSString *isshiming;  //!<   是否进行了实名操作1：已实名 0：未实名

@property (nonatomic, strong) NSString *msg;

@property (nonatomic, strong) NSString *remark;    //!<  标记是否是游客登录，如果是游客登录不能修改密码

@property (nonatomic, strong) NSString *sessionid;

@property (nonatomic, strong) NSString *uid;

@property (nonatomic, strong) NSString *username;

@property (nonatomic, strong) NSString *userphone;

@property (nonatomic, strong) NSString *isnew;  //!<  游客登录是否是最新生成的

@property (nonatomic, strong) NSString *password;  //!<  游客登录  成功返回server端分配的账号密码

//TODO:用户实名认证状态
@property (nonatomic, strong) NSString *realname;  //!<  实名认证真实姓名

@property (nonatomic, strong) NSString *idcard;  //!<  游客登录  实名认证真实身份证号


//TODO:佣金结算金额查询值
@property (nonatomic, strong) NSString *commisionAmount;  //!<  佣金金额

- (BOOL)resetNull;

DEFINE_MODEL_FOR_HEADER

@end
