//
//  UserInfo.h
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/19.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, strong) NSString *username;  //!<  用户名

@property (nonatomic, strong) NSString *password;  //!< 用户输入密码，或本地缓存密码

@property (nonatomic, strong) NSString *phoneNum;  //!< 用户绑定的手机号

@property (nonatomic, strong) NSString *sessionid;  //!< token

@property (nonatomic, strong) NSString *ischeck; //!<  是否绑定了手机号码  '0'未绑定  ‘1’已绑定

@property (nonatomic, strong) NSString *isidcard; //!<  是否进行了绑定身份证操作1：已绑定 0：未绑定

@property (nonatomic, strong) NSString *isshiming; //!<  是否进行了绑定身份证操作1：已绑定 0：未绑定

@property (nonatomic, strong) NSString *uid; //!<  UID

@property (nonatomic, strong) NSString *remark; //!<  1：游客账号 个人中心不允许直接修改密码

@property (nonatomic, strong) NSString *isnew; //!<  1：新增 0：之前生成的账号

@property (nonatomic, strong) NSString *dateline; //!<  插入数据用户的时间戳

@property (nonatomic, strong) NSString *isCodeLogin;  //!<  当登录名是手机号时标记是否是短信验证码登录  '1'是   ‘0’不是   作用：快速登录接口  type=phone

@property (nonatomic, strong) NSString *iapCount; //!<  用户已经内购的次数


@end
