//
//  RequestQuickLoginManager.m
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/20.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "RequestManager.h"
#import "HTPangestureButtonManager.h"
#import "NSString+parameterEncodeHT.h"
#import "HTNetWorkHelper.h"
#import "NSString+StringHT.h"
#import "DCTrackingAgent.h"

@implementation RequestManager


DEFINE_SINGLETON_FOR_CLASS(RequestManager)

- (instancetype)init
{
    if (self = [super init]) {
        
        self.getLoginKeymodel = [ModelGetLoginKey model];
        self.loginModel = [ModelLogin model];
        self.shareModel = [ModelShare model];
        self.payModel = [ModelUserPay model];
    }
    return self;
}


//TODO:初始化SDK
- (void)ht_getLoginKeyWithAppID:(NSString *)AppID
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:ISINITILIZE_KEY] isEqualToString:@"0"] || !IS_EXIST_STR([[NSUserDefaults standardUserDefaults] objectForKey:ISINITILIZE_KEY])) {
        //统计激活事件
        [self ht_getStatisticsWithEventType:@"1"];//'1'固定值激活事件统计
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addObjectIfNotBlank:HTPRODUCTID forKey:APPID_KEY];
    [dic addObjectIfNotBlank:HTUniteSDKVersion forKey:@"appversion"];
    [dic addObjectIfNotBlank:HTAC_GETLOGINKEY forKey:HTAC];
    [dic addObjectIfNotBlank:OSTYPE forKey:@"ostype"];
    
    [dic addObjectIfNotBlank:@"0" forKey:ISSHOW_RESPONSE_TOASTMESSAGE_KEY];
    
    [[HTHTTPSessionManager sharedManager] HT_GETWithParameters:dic
                                               isShowIndicator:YES
                                                       success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                           [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:ISINITILIZE_KEY];
                                                           if ([self.getLoginKeymodel loadModelInfoModelWithDic:responseDict]) {//解析数据
                                                               HTPOSTNOTIFICATION(kHTGUniteSDKInitDidFinishedNotification);
                                                               SYSTEMINFO_SET_( @"YES", KisFirstInstrument);
                                                               success(response, responseDict);
                                                           }
                                                       }
                                                       failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                           HTPOSTNOTIFICATION(kHTGUniteSDKInitFinishedFailNotification);
                                                           failure(response, error);
                                                       }];
}


//TODO:快速登录
- (void)ht_getQuickLoginWithParam:(NSDictionary *)param
                          success:(SuccessBlock)success
                          failure:(FailureBlock)failure
{
    if (!IS_DICTIONARY_CLASS(param)) {
        KLLog(@"%s", __func__);
        KLLog(@"++++++++非法的请求参数+++++++++++++");
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[ParametersUtil paseParametersWithProductId:@""
                                                                                                                  coopid:@""
                                                                                                                username:param[HTSDKUSERNAME]
                                                                                                                password:param[HTSDKPASSWORD]
                                                                                                              registType:@""
                                                                              ]];
    
    [dic addObjectIfNotBlank:HTAC_QUICKLOGIN forKey:HTAC];
    
    [dic addObjectIfNotBlank:param[HTSDKTYPE] forKey:HTSDKTYPE];

    [[HTHTTPSessionManager sharedManager] HT_GETWithParameters:dic
                                               isShowIndicator:YES
                                                       success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                           //清除上一个登录用户缓存信息
                                                           [self.loginModel resetNull];
                                                           //解析数据保存数据缓存
                                                           if([self.loginModel loadModelInfoModelWithDic:responseDict]) {
                                                               SYSTEMINFO_SET_( @"YES", KisFirstInstrument);
                                                               
                                                               //统计登录事件
                                                               [self ht_getStatisticsWithEventType:@"0"];//'0'固定值登录事件统计
                                                               
                                                           }
                                                           
                                                           success(response, responseDict);
                                                       }
                                                       failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                           failure(response, error);
                                                       }];
}

//TODO:用户名密码登录
- (void)ht_getUserNameLoginWithParam:(NSDictionary *)param
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[ParametersUtil paseParametersWithProductId:@""
                                                                                                                  coopid:@""
                                                                                                                username:param[HTSDKUSERNAME]
                                                                                                                password:param[HTSDKPASSWORD]
                                                                                                              registType:@""]];
    
    [dic addObjectIfNotBlank:HTAC_LOGIN forKey:HTAC];
    
    [[HTHTTPSessionManager sharedManager] HT_GETWithParameters:dic
                                               isShowIndicator:YES
                                                       success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                           //清除上一个登录用户缓存信息
                                                           [self.loginModel resetNull];
                                                           //解析数据保存数据缓存
                                                           if([self.loginModel loadModelInfoModelWithDic:responseDict]) {
                                                               SYSTEMINFO_SET_( @"YES", KisFirstInstrument);
                                                               
                                                               //统计登录事件
                                                               [self ht_getStatisticsWithEventType:@"0"];//'0'固定值登录事件统计
                                                               
                                                               success(response, responseDict);
                                                               
                                                           }
                                                       }
                                                       failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                           failure(response, error);
                                                       }];
}

//TODO:游客登录
- (void)ht_getTouristLoginWithParam:(NSDictionary *)param
                            success:(SuccessBlock)success
                            failure:(FailureBlock)failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[ParametersUtil paseParametersWithProductId:@""
                                                                                                                  coopid:@""
                                                                                                                username:@""
                                                                                                                password:@""
                                                                                                              registType:@"1"
                                                                              ]];
    
    [dic addObjectIfNotBlank:HTAC_TOURISTLOGIN forKey:HTAC];
    
    [dic addObjectIfNotBlank:@"1" forKey:@"remark"];//可找回游客账户标识：使用该接口全部传1
    
    [dic addObjectIfNotBlank:@"0" forKey:ISSHOW_RESPONSE_TOASTMESSAGE_KEY];
        
    [[HTHTTPSessionManager sharedManager] HT_GETWithParameters:dic
                                               isShowIndicator:YES
                                                       success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                           //清除上一个登录用户缓存信息
                                                           [self.loginModel resetNull];
                                                           //解析数据保存数据缓存
                                                           if([self.loginModel loadModelInfoModelWithDic:responseDict]) {
                                                               
                                                               if (IS_DICTIONARY_CLASS(responseDict) && [responseDict[@"isnew"] isEqualToString:@"1"]) {
                                                                   //统计注册事件
                                                                   [self ht_getStatisticsWithEventType:@"2"];//'2'固定值注册事件统计
                                                                   
                                                                   
                                                                   //fix by zfj 5.8
                                                                   //TODO:第三方数据统计接口调用GA\TD\DA
                                                                   NSString *account = self.loginModel.uid;
                                                                   NSString *accountName = self.loginModel.username;
                                                                   if (IS_EXIST_STR([RequestManager sharedManager].payModel.ad_appid)) {
                                                                       [DCTrackingPoint createAccount:account];
                                                                   }
                                                                   if (IS_EXIST_STR([RequestManager sharedManager].payModel.ga_appid)) {
                                                                       TDGAAccount *tdAccount = [TDGAAccount setAccount:account];
                                                                       [tdAccount setAccountName:accountName];
                                                                       [tdAccount setAccountType:kAccountRegistered];
                                                                   }
                                                                   if (IS_EXIST_STR([RequestManager sharedManager].payModel.de_appid)) {
                                                                       [TalkingDataAppCpa onRegister:account];
                                                                   }
                                                                   
                                                               }else{
                                                                   
                                                               }
                                                               success(response, responseDict);
                                                           }
                                                       }
                                                       failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                           failure(response, error);
                                                       }];
    
}

//TODO:发送短信验证码
- (void)ht_getCheckCodeWithParam:(NSDictionary *)param
                         success:(SuccessBlock)success
                         failure:(FailureBlock)failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic addObjectIfNotBlank:HTAC_CHECKCODE forKey:HTAC];
    
    [dic addObjectIfNotBlank:param[HTSDKPHONE] forKey:HTSDKPHONE];
    
    [dic addObjectIfNotBlank:param[HTSDKTYPE] forKey:HTSDKTYPE];
    
    [dic addObjectIfNotBlank:param[HTSDKSESSIONID] forKey:HTSDKSESSIONID];
    
    [dic addObjectIfNotBlank:HTPRODUCTID forKey:APPID_KEY];
    
    [dic addObjectIfNotBlank:param[HTSDKUSERNAME] forKey:HTSDKUSERNAME];

    [dic addObjectIfNotBlank:param[HTSDKBDINDTYPE] forKey:HTSDKBDINDTYPE];  //手机解绑和绑定  1:绑定 2：解绑
    
    [[HTHTTPSessionManager sharedManager] HT_GETWithParameters:dic
                                               isShowIndicator:YES
                                                       success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                           success(response, responseDict);
                                                       }
                                                       failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                           failure(response, error);
                                                       }];
}

//TODO:短信验证码登录
- (void)ht_getPhoneLoginWithParam:(NSDictionary *)param
                          success:(SuccessBlock)success
                          failure:(FailureBlock)failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[ParametersUtil paseCodeLoginWithProductId:@""
                                                                                                                 coopid:@""
                                                                                                                  phone:param[HTSDKPHONE]
                                                                                                                   code:param[HTSDKPHONECODE]
                                                                              ]];
    
    [dic addObjectIfNotBlank:HTAC_PHONELOGIN forKey:HTAC];
        
    [[HTHTTPSessionManager sharedManager] HT_GETWithParameters:dic
                                               isShowIndicator:YES
                                                       success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                           //清除上一个登录用户缓存信息
                                                           [self.loginModel resetNull];
                                                           //解析数据保存数据缓存
                                                           if([self.loginModel loadModelInfoModelWithDic:responseDict]) {
                                                               
                                                               //统计登录事件
                                                               [self ht_getStatisticsWithEventType:@"0"];//'0'固定值登录事件统计
                                                               
                                                           }
                                                           success(response, responseDict);
                                                       }
                                                       failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                           failure(response, error);
                                                       }];
}

//TODO:用户名注册
- (void)ht_getUserNameRegisterWithParam:(NSDictionary *)param
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure

{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[ParametersUtil paseUserNameRegisterWithProductId:@""
                                                                                                                        coopid:@""
                                                                                                                      username:param[HTSDKUSERNAME]
                                                                                                                      password:param[HTSDKPASSWORD]
                                                                                                                 cpChannelName:@""
                                                                                                                    registType:@"1"
                                                                                                                          code:@""
                                                                                                                         phone:@""
                                                                              ]];
    
    [dic addObjectIfNotBlank:HTAC_USERNAMEREGISTER forKey:HTAC];
    
    [[HTHTTPSessionManager sharedManager] HT_GETWithParameters:dic
                                               isShowIndicator:YES
                                                       success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                           //清除上一个登录用户缓存信息
                                                           [self.loginModel resetNull];
                                                           //解析数据保存数据缓存
                                                           if([self.loginModel loadModelInfoModelWithDic:responseDict]) {
                                                               
                                                               //统计注册事件
                                                               [self ht_getStatisticsWithEventType:@"2"];//'2'固定值注册事件统计
                                                               
                                                               //TODO:第三方数据统计接口调用GA\TD\DA
                                                               NSString *account = self.loginModel.uid;
                                                               NSString *accountName = self.loginModel.username;
                                                               if (IS_EXIST_STR([RequestManager sharedManager].payModel.ad_appid)) {
                                                                   [DCTrackingPoint createAccount:account];
                                                               }
                                                               if (IS_EXIST_STR([RequestManager sharedManager].payModel.ga_appid)) {
                                                                   TDGAAccount *tdAccount = [TDGAAccount setAccount:account];
                                                                   [tdAccount setAccountName:accountName];
                                                                   [tdAccount setAccountType:kAccountRegistered];
                                                               }
                                                               if (IS_EXIST_STR([RequestManager sharedManager].payModel.de_appid)) {
                                                                   [TalkingDataAppCpa onRegister:account];
                                                               }

                                                               
                                                           }
                                                           
                                                           success(response, responseDict);
                                                       }
                                                       failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                           failure(response, error);
                                                       }];
}

//TODO:手机号注册   同账号密码注册
- (void)ht_getPhoneRegisterWithParam:(NSDictionary *)param
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[ParametersUtil paseUserNameRegisterWithProductId:@""
                                                                                                                        coopid:@""
                                                                                                                      username:@""
                                                                                                                      password:@""
                                                                                                                 cpChannelName:@""
                                                                                                                    registType:@"1"
                                                                                                                          code:param[HTSDKPHONECODE]
                                                                                                                         phone:param[HTSDKPHONE]
                                                                              ]];
    
    [dic addObjectIfNotBlank:HTAC_PHONEREG forKey:HTAC];
    
    [[HTHTTPSessionManager sharedManager] HT_GETWithParameters:dic
                                               isShowIndicator:YES
                                                       success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                           //清除上一个登录用户缓存信息
                                                           [self.loginModel resetNull];
                                                           //解析数据保存数据缓存
                                                           if([self.loginModel loadModelInfoModelWithDic:responseDict]) {
                                                               
                                                               //TODO: fix by zfj 5.8
                                                               //保存用户名密码进数据库
                                                               UserInfo *insertUser = [UserInfo new];
                                                               insertUser.username = responseDict[@"phone"];
                                                               insertUser.password = responseDict[@"password"];
                                                               insertUser.dateline = [HTUtil getNowDate];
                                                               if(![[DBManager sharedDBManager] insertDataWithUserInfo:insertUser])
                                                               {//插入数据失败、更新原有用户时间戳
                                                                   [[DBManager sharedDBManager] updateDatelineWithUserInfo:insertUser];
                                                               }
                                                               
                                                               //统计注册事件
                                                               [self ht_getStatisticsWithEventType:@"2"];//'2'固定值注册事件统计
                                                               
                                                               //TODO:第三方数据统计接口调用GA\TD\DA
                                                               NSString *account = self.loginModel.uid;
                                                               NSString *accountName = self.loginModel.username;
                                                               if (IS_EXIST_STR([RequestManager sharedManager].payModel.ad_appid)) {
                                                                   [DCTrackingPoint createAccount:account];
                                                               }
                                                               if (IS_EXIST_STR([RequestManager sharedManager].payModel.ga_appid)) {
                                                                   TDGAAccount *tdAccount = [TDGAAccount setAccount:account];
                                                                   [tdAccount setAccountName:accountName];
                                                                   [tdAccount setAccountType:kAccountRegistered];
                                                               }
                                                               if (IS_EXIST_STR([RequestManager sharedManager].payModel.de_appid)) {
                                                                   [TalkingDataAppCpa onRegister:account];
                                                               }

                                                               
                                                           }
                                                           success(response, responseDict);

                                                       }
                                                       failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                           failure(response, error);
                                                       }];
}

//TODO:实名认证
- (void)ht_getRealNameWithParam:(NSDictionary *)param
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic addObjectIfNotBlank:HTAC_IDCARD forKey:HTAC];
    [dic addObjectIfNotBlank:param[@"idcard"] forKey:@"idcard"];
    [dic addObjectIfNotBlank:param[@"realname"] forKey:@"realname"];
    [dic addObjectIfNotBlank:param[@"username"] forKey:@"username"];
    [dic addObjectIfNotBlank:param[HTSDKTYPE] forKey:HTSDKTYPE];
    
    [[HTHTTPSessionManager sharedManager] HT_GETWithParameters:dic
                                               isShowIndicator:YES
                                                       success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                           KLLog(@"++++++++++实名认证成功++++++++++");
                                                           success(response, responseDict);
                                                       }
                                                       failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                           failure(response, error);
                                                       }];
}

//TODO:查询实名认证状态
- (void)ht_getRealNameStateWithParam:(NSDictionary *)param
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    ModelLogin *user = [RequestManager sharedManager].loginModel;
    
    [dic addObjectIfNotBlank:HTAC_GETUSERINFO forKey:HTAC];
    [dic addObjectIfNotBlank:user.sessionid forKey:HTSDKSESSIONID];
    [dic addObjectIfNotBlank:user.uid forKey:@"uid"];
    [dic addObjectIfNotBlank:@"0" forKey:ISSHOW_RESPONSE_TOASTMESSAGE_KEY];
    
    [[HTHTTPSessionManager sharedManager] HT_GETWithParameters:dic
                                               isShowIndicator:YES
                                                       success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                           KLLog(@"++++++++++实名认证状态查询成功++++++++++");
                                                           
                                                           //缓存用户认证状态信息
                                                           if (IS_DICTIONARY_CLASS(responseDict)) {
                                                               [RequestManager sharedManager].loginModel.realname = responseDict[@"realname"];
                                                               [RequestManager sharedManager].loginModel.idcard = responseDict[@"idcard"];
                                                           }
                                                           success(response, responseDict);
                                                       }
                                                       failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                           failure(response, error);
                                                       }];
}

//TODO:退出登录
- (void)ht_getLogoutWithParam:(NSDictionary *)param
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic addObjectIfNotBlank:HTAC_LOGOUT forKey:HTAC];
    [dic addObjectIfNotBlank:@"" forKey:@"sessionid"];
    [dic addObjectIfNotBlank:@"ht621798" forKey:@"username"];
    
    [[HTHTTPSessionManager sharedManager] HT_GETWithParameters:dic
                                               isShowIndicator:YES
                                                       success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                           
                                                       }
                                                       failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                           
                                                       }];
    
}

//TODO:修改密码  重置密码  忘记密码 同一个接口
- (void)ht_getModifyPswWithParam:(NSDictionary *)param
                         success:(SuccessBlock)success
                         failure:(FailureBlock)failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic addObjectIfNotBlank:param[HTAC] forKey:HTAC];
    [dic addObjectIfNotBlank:param[HTSDKSESSIONID] forKey:@"sessionid"];
    [dic addObjectIfNotBlank:param[HTSDKUSERNAME] forKey:@"username"];
    [dic addObjectIfNotBlank:param[@"oldpassword"] forKey:@"oldpassword"];
    [dic addObjectIfNotBlank:param[@"password"] forKey:@"password"];
    [dic addObjectIfNotBlank:param[@"password2"] forKey:@"password2"];
    [dic addObjectIfNotBlank:param[@"checkcode"] forKey:@"checkcode"];
    [dic addObjectIfNotBlank:param[HTSDKPHONE] forKey:HTSDKPHONE];

    [[HTHTTPSessionManager sharedManager] HT_GETWithParameters:dic
                                               isShowIndicator:YES
                                                       success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                           success(response, responseDict);
                                                       } failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                           
                                                       }];
    
}

//手机解绑、绑定
- (void)ht_getBindPhoneWithParam:(NSDictionary *)param
                         success:(SuccessBlock)success
                         failure:(FailureBlock)failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic addObjectIfNotBlank:HTAC_BINDACCOUNT forKey:HTAC];
    
    [dic addObjectIfNotBlank:param[HTSDKPHONE] forKey:HTSDKPHONE];
    
    [dic addObjectIfNotBlank:param[HTSDKTYPE] forKey:HTSDKTYPE];
    
    [dic addObjectIfNotBlank:param[HTSDKSESSIONID] forKey:HTSDKSESSIONID];
    
    [dic addObjectIfNotBlank:HTPRODUCTID forKey:APPID_KEY];
    
    [dic addObjectIfNotBlank:param[HTSDKSESSIONID] forKey:HTSDKSESSIONID];
    
    [dic addObjectIfNotBlank:param[@"code"] forKey:@"code"];//短信验证码
    
    [dic addObjectIfNotBlank:param[HTSDKBDINDTYPE] forKey:HTSDKBDINDTYPE];  //手机解绑和绑定  1:绑定 2：解绑
    
    [[HTHTTPSessionManager sharedManager] HT_GETWithParameters:dic
                                               isShowIndicator:YES
                                                       success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                           success(response, responseDict);
                                                       }
                                                       failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                           failure(response, error);
                                                       }];
    
}

//TODO:统计事件
- (void)ht_getStatisticsWithParam:(NSString *)eventType
                          success:(SuccessBlock)success
                          failure:(FailureBlock)failure
{
    ModelLogin *user = [RequestManager sharedManager].loginModel;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[ParametersUtil paseStatisticsWitheventType:eventType
                                                                                                                     uid:user.uid
                                                                                                                username:user.username
                                                                                                             productName:@""
                                                                                                                  amount:@""
                                                                                                                  charId:@""
                                                                                                                 orderId:@""
                                                                                                           advertisingId:@""
                                                                                                      dynamicChannelName:@""
                                                                                                           cpChannelName:@""
                                                                              ]
                                ];
    
    [dic addObjectIfNotBlank:@"1" forKey:ISSTATISTICSREQUEST];
    
    [[HTHTTPSessionManager sharedManager] HT_GETWithParameters:dic
                                               isShowIndicator:NO
                                                       success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                           KLLog(@"++++++++++++统计事件上传成功+++++++++++++");
                                               }
                                                       failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                           KLLog(@"++++++++++++统计事件上传失败+++++++++++++");
                                                       }];


}

- (void)ht_getStatisticsWithEventType:(NSString *)eventType
{
    [self ht_getStatisticsWithParam:eventType
                            success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                
                            }
                            failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                
                            }];
}


//TODO:角色提交
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
                           failure:(FailureBlock)failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic addObjectIfNotBlank:HTAC_ROLEINFO forKey:HTAC];
    
    [dic addObjectIfNotBlank:serverid forKey:@"serverid"];
    
    [dic addObjectIfNotBlank:serverName forKey:@"serverName"];
    
    [dic addObjectIfNotBlank:roleid forKey:@"roleid"];
    
    [dic addObjectIfNotBlank:rolename forKey:@"rolename"];
    
    [dic addObjectIfNotBlank:rolelevel forKey:@"rolelevel"];
    
    [dic addObjectIfNotBlank:roletime forKey:@"roletime"];
    
    [dic addObjectIfNotBlank:HTPRODUCTID forKey:@"productId"];
    
    [dic addObjectIfNotBlank:self.loginModel.sessionid forKey:@"sessionid"];
    
    [dic addObjectIfNotBlank:@"0" forKey:ISSHOW_RESPONSE_TOASTMESSAGE_KEY];

    [[HTHTTPSessionManager sharedManager] HT_GETWithParameters:dic
                                               isShowIndicator:NO
                                                       success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                           success(response, responseDict);
                                                       } failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                           failure(response, error);
                                                       }];
}

//TODO:获取分享链接
- (void)ht_getgetshareinfoWithParam:(NSDictionary *)param
                            success:(SuccessBlock)success
                            failure:(FailureBlock)failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic addObjectIfNotBlank:HTAC_getshareinfo forKey:HTAC];
    
    [dic addObjectIfNotBlank:[RequestManager sharedManager].loginModel.sessionid forKey:@"sessionid"];
    
    [dic addObjectIfNotBlank:[RequestManager sharedManager].loginModel.uid forKey:@"uid"];
    
    [dic addObjectIfNotBlank:OSTYPE forKey:@"platform"];
    
    [dic addObjectIfNotBlank:@"3" forKey:@"type"];//固定值  ‘3’  SDK
    
    [dic addObjectIfNotBlank:HTPRODUCTID forKey:@"productId"];
    
    [dic addObjectIfNotBlank:@"0" forKey:ISSHOW_RESPONSE_TOASTMESSAGE_KEY];

    [[HTHTTPSessionManager sharedManager] HT_GETWithParameters:dic
                                               isShowIndicator:YES
                                                       success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                           //清除上一个登录用户缓存信息
                                                           [self.shareModel resetNull];
                                                           //解析数据保存数据缓存
                                                           if([self.shareModel loadModelInfoModelWithDic:responseDict]) {
                                                               success(response, responseDict);
                                                           }
                                                       }
                                                       failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                           failure(response, error);
                                                       }];
}

//TODO:支付url拼接
- (NSString *)ht_payWithCharId:(NSString *)CharId
                serverId:(NSString *)serverId
               cporderid:(NSString *)cporderid
             productname:(NSString *)productname
                   money:(NSString *)money
            callbackInfo:(NSString *)callbackInfo
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[ParametersUtil pasePayOrderParametrWithCharId:CharId
                                                                                                               callbackInfo:callbackInfo
                                                                                                                   serverId:serverId
                                                                                                                  cporderid:cporderid
                                                                                                                productname:productname
                                                                                                                  productId:HTPRODUCTID
                                                                                                                      money:money
                                                                              ]
                                ];
    
    
    if (![NSJSONSerialization isValidJSONObject:dic]) {
        KLLog(@"不合法的json格式");
        return nil;
    }
    
    NSString *paramString = [NSString ht_parameterEncode:dic];
    
    paramString = [HTNetWorkHelper parseParams:paramString];
    
    NSString *requestString = [NSString stringWithFormat:@"%@?%@",KAPI_HEAD,paramString];
    
    // 截取字符串的方法!
    requestString = [requestString substringToIndex:requestString.length - 1];
    
    // 815
    requestString = [[NSString stringWithFormat:@"%@", requestString] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    return requestString;

}

//TODO:支付查询
- (void)ht_getchkorderWithParam:(NSDictionary *)param
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic addObjectIfNotBlank:HTAC_CHKORDER forKey:HTAC];
    
    NSString *cporderId = [RequestManager sharedManager].payModel.cporderid;
    
    [dic addObjectIfNotBlank:cporderId forKey:@"cporderid"];
    
    [dic addObjectIfNotBlank:HTPRODUCTID forKey:@"productId"];
    
    NSString *md5 = [NSString stringWithFormat:@"%@%@%@",cporderId, HTPRODUCTID,@"123321"];
    md5 = [md5 stringToMD5];
    
    [dic addObjectIfNotBlank:md5 forKey:@"sign"];
    
    [[HTHTTPSessionManager sharedManager] HT_GETWithParameters:dic
                                               isShowIndicator:YES
                                                       success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                           success(response, responseDict);
                                                       } failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                           failure(response, error);
                                                       }];

}

//TODO:佣金结算
- (void)ht_getcommissioninfoWithParam:(NSDictionary *)param
                              success:(SuccessBlock)success
                              failure:(FailureBlock)failure
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic addObjectIfNotBlank:HTAC_getcommissioninfo forKey:HTAC];
    
    [dic addObjectIfNotBlank:[RequestManager sharedManager].loginModel.sessionid forKey:@"sessionid"];
    
    [dic addObjectIfNotBlank:[RequestManager sharedManager].loginModel.uid forKey:@"uid"];
    
    [dic addObjectIfNotBlank:OSTYPE forKey:@"platform"];
    
    [dic addObjectIfNotBlank:@"3" forKey:@"type"];//固定值  ‘3’  SDK
    
    [dic addObjectIfNotBlank:HTPRODUCTID forKey:@"productId"];
    
    [dic addObjectIfNotBlank:@"0" forKey:ISSHOW_RESPONSE_TOASTMESSAGE_KEY];
    
    [[HTHTTPSessionManager sharedManager] HT_GETWithParameters:dic
                                               isShowIndicator:NO
                                                       success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                           //佣金金额解析缓存
                                                           self.loginModel.commisionAmount = responseDict[@"amount"];
                                                           
                                                           success(response, responseDict);
                                                       } failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                           failure(response, error);
                                                       }];
}

//TODO:跳转公告
- (void)skipToAnnouncement
{
    NSString *gonggaostatus = self.getLoginKeymodel.gonggaostatus;
    if ([gonggaostatus isEqualToString:kAnnouncementIsCloseStringTag]) {//关闭
        WEAK_SELF(weakSelf);
        //发送登录成功通知给CP
        HTPOSTNOTIFICATION(kHTGUniteSDKLoginNotification);  //登录成功
        
        //更新本地日期、本地数据库用户已经内购的次数
        [[DBManager sharedDBManager] updateLocalDateAndUserIapCount];
        
        ModelLogin *loginModel = [RequestManager sharedManager].loginModel;
        //TODO:第三方数据统计接口调用GA\TD\DA
        NSString *account = loginModel.uid;
        NSString *accountName = loginModel.username;
        if (IS_EXIST_STR([RequestManager sharedManager].payModel.ad_appid)) {
            [DCTrackingPoint login:account];
        }
        if (IS_EXIST_STR([RequestManager sharedManager].payModel.ga_appid)) {
            TDGAAccount *tdAccount = [TDGAAccount setAccount:account];
            [tdAccount setAccountName:accountName];
            [tdAccount setAccountType:kAccountRegistered];
        }
        if (IS_EXIST_STR([RequestManager sharedManager].payModel.de_appid)) {
            [TalkingDataAppCpa onLogin:account];
        }

        int64_t delayInSeconds = 1.0;      // 延迟的时间
        /*
         *@parameter 1,时间参照，从此刻开始计时
         *@parameter 2,延时多久，此处为秒级，还有纳秒等。10ull * NSEC_PER_MSEC
         */
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf closeWindow];
        });
        
    }else{//开启
        dispatch_async(dispatch_get_main_queue(), ^{
            [[HTGUniteSDK sharedInstance] showAnnouncement];
        });
    }
}

- (void)closeWindow
{
    //关闭mainwindow
    dispatch_async(dispatch_get_main_queue(), ^{
        [[LoginWindow sharedInstance] dismiss];
        [[HTPangestureButtonManager sharedManager] showHTPanGestureButtonInKeyWindow];
        
    });
}


- (void)resetNull
{
    
    //初始化
//    [self.getLoginKeymodel resetNull];
//    self.getLoginKeymodel = [ModelGetLoginKey model];
    
    //快速登录
    [self.loginModel resetNull];
    self.loginModel = [ModelLogin model];
    
}

@end
