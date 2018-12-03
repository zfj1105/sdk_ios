//
//  RequestQuickLoginManager.h
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/20.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelGetLoginKey.h"
#import "ModelLogin.h"
#import "ModelShare.h"
#import "ModelUserPay.h"
#import "ModelTTPay.h"


@interface RequestManager : NSObject


@property (strong, nonatomic) ModelGetLoginKey *getLoginKeymodel;      //!<  初始化数据模型

@property (strong, nonatomic) ModelLogin *loginModel;      //!<  快速登录数据模型

@property (strong, nonatomic) ModelShare *shareModel;      //!<  佣金分享数据模型

@property (strong, nonatomic) ModelUserPay *payModel;      //!<  支付数据模型

@property (strong, nonatomic) NSString *showLoginAfterLogout;  //!< 注销之后是否显示登录界面  '1'显示  ‘0’不显示

@property (strong, nonatomic) ModelTTPay *modelTTPay;  //!< 头条SDK支付接口模型

@property (nonatomic, assign) BOOL  isToutiaoSDK;  //!<   是否接入头条SDK


DEFINE_SINGLETON_FOR_HEADER(RequestManager)

//初始化接口
- (void)ht_getLoginKeyWithAppID:(NSString *)AppID
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure;

- (void)ht_getQuickLoginWithParam:(NSDictionary *)param
                          success:(SuccessBlock)success
                          failure:(FailureBlock)failure;

- (void)ht_getUserNameLoginWithParam:(NSDictionary *)param
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure;


- (void)ht_getTouristLoginWithParam:(NSDictionary *)param
                            success:(SuccessBlock)success
                            failure:(FailureBlock)failure;


//发送短信验证码接口
- (void)ht_getCheckCodeWithParam:(NSDictionary *)param
                         success:(SuccessBlock)success
                         failure:(FailureBlock)failure;


//短信验证码登录
- (void)ht_getPhoneLoginWithParam:(NSDictionary *)param
                          success:(SuccessBlock)success
                          failure:(FailureBlock)failure;


//用户名注册
- (void)ht_getUserNameRegisterWithParam:(NSDictionary *)param
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure;


//手机号注册
- (void)ht_getPhoneRegisterWithParam:(NSDictionary *)param
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure;


//实名认证
- (void)ht_getRealNameWithParam:(NSDictionary *)param
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure;

//查询实名认证状态
- (void)ht_getRealNameStateWithParam:(NSDictionary *)param
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure;

//退出登录
- (void)ht_getLogoutWithParam:(NSDictionary *)param;

//修改密码
- (void)ht_getModifyPswWithParam:(NSDictionary *)param
                         success:(SuccessBlock)success
                         failure:(FailureBlock)failure;



//手机解绑、绑定
- (void)ht_getBindPhoneWithParam:(NSDictionary *)param
                         success:(SuccessBlock)success
                         failure:(FailureBlock)failure;

//统计事件
- (void)ht_getStatisticsWithParam:(NSString *)eventType
                          success:(SuccessBlock)success
                          failure:(FailureBlock)failure;


- (void)ht_getStatisticsWithEventType:(NSString *)eventType;

/**
 角色提交
 提交的时机为: 每次登录 或者每次退出 或者是 角色等级升级的时候 三个时段都调用那是最好的 . 至少满足角色等级升级的时候调用
 @param serverid 服务器编号
 @param serverName 服务器名称
 @param roleid 角色ID
 @param rolename 角色名称
 @param rolelevel 角色等级
 @param roletime 角色创建时间 秒时间戳
 */

- (void)submitRoleInfoWithServerid:(NSString *)serverid
                        serverName:(NSString *)serverName
                            roleid:(NSString *)roleid
                          roleName:(NSString *)rolename
                         rolelevel:(NSString *)rolelevel
                          roleTime:(NSString *)roletime
                           success:(SuccessBlock)success
                           failure:(FailureBlock)failure;

//获取分享链接
- (void)ht_getgetshareinfoWithParam:(NSDictionary *)param
                            success:(SuccessBlock)success
                            failure:(FailureBlock)failure;

//支付url拼接
- (NSString *)ht_payWithCharId:(NSString *)CharId
                serverId:(NSString *)serverId
               cporderid:(NSString *)cporderid
             productname:(NSString *)productname
                   money:(NSString *)money
            callbackInfo:(NSString *)callbackInfo;
//支付查询
- (void)ht_getchkorderWithParam:(NSDictionary *)param
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure;

//佣金结算
- (void)ht_getcommissioninfoWithParam:(NSDictionary *)param
                              success:(SuccessBlock)success
                              failure:(FailureBlock)failure;

//TODO:跳转公告
- (void)skipToAnnouncement;

- (void)resetNull;


@end
