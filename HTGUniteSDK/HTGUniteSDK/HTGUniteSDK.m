//
//  HTGUniteSDK.m
//  HTGUniteSDK
//
//  Created by zfj2602 on 2018/4/5.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "HTGUniteSDK.h"
#import <Foundation/Foundation.h>

//test
#import "UserhomeController.h"
#import "QuickLoginViewController.h"
#import "UserPayWebController.h"
#import "AnnouncementWebController.h"
#import "DBManager.h"
#import "HTMai.h"
#import "LoginViewController.h"
#import "HTPangestureButtonManager.h"

@interface HTGUniteSDK ()

@end

@implementation HTGUniteSDK

/**
 *   @brief 获取HTGUniteSDK实例
 */
+ (HTGUniteSDK *)sharedInstance
{
    static HTGUniteSDK *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @synchronized(self){
            sharedInstance = [[self alloc] init];
        }
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

/**
 *  @brief  平台初始化方法
 *
 *  @param  appId 游戏在接入联运分配的appId
 *  @param  showLoginAfterLogout 游戏在执行注销操作之后
 ‘1’SDK 里面在注销之后自动显示登录界面  ‘0’不显示 由CP 接入方自己决定在收到 通知名为 kHTGUniteSDKLogoutNotification 的回调之后
 是否调用- (void)HTGUniteLogin  函数显示登录界面
 *  @param  GAKey 游戏在接入联运分配的GAKey
 *  @param  ADKEY 游戏在接入联运分配的ADKEY
 *  @param  DEKEY 游戏在接入联运分配的DEKEY
 *  @param  TTAppID 游戏在接入头条SDK申请分配的TTAppID
 *  @param  TTChannel 游戏在接入头条SDK的渠道名称，建议正式版App Store 内测版local_test 灰度版用发布的渠道名，如pp
 *  @param  TTAppName 游戏在接入头条SDK申请分配的TTAppName
 *  @param  isToutiaoSDK     是否接入头条SDK  yes 开启，no 关闭 ；这个值为no时，TTAppID、TTChannel、TTAppName 传 @“” 即可
 *  @param  showLog     是否开启Log输出    YES 开启; NO 关闭.  默认关闭
 *
 */
- (void)initWithAppId:(NSString *)appId
 showLoginAfterLogout:(NSString *)showLoginAfterLogout
                GAKey:(NSString *)GAKey
                ADKEY:(NSString *)ADKEY
                DEKEY:(NSString *)DEKEY
              TTAppID:(NSString *)TTAppID
            TTChannel:(NSString *)TTChannel
            TTAppName:(NSString *)TTAppName
         isToutiaoSDK:(BOOL)isToutiaoSDK
              showLog:(BOOL)showLog
{
    //保存cp方productid
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:appId forKey:kUserDefaultProductID_KEY];
    [ud synchronize];
    
    
    //TODO:缓存传入的参数
    [RequestManager sharedManager].payModel.ga_appid = GAKey;
    [RequestManager sharedManager].payModel.ad_appid = ADKEY;
    [RequestManager sharedManager].payModel.de_appid = DEKEY;
    
    if (isToutiaoSDK) {
        //头条统计SDK
        [[TTTracker sharedInstance] setSessionEnable:YES];
        [TTTracker startWithAppID:TTAppID
                          channel:TTChannel
                          appName:TTAppName];
        [RequestManager sharedManager].isToutiaoSDK = isToutiaoSDK;
    }
    
    [RequestManager sharedManager].showLoginAfterLogout = showLoginAfterLogout;
    
    WEAK_SELF(weakSelf);
    [[RequestManager sharedManager] ht_getLoginKeyWithAppID:appId
                                                    success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                        if (GAKey.length > 1) {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [TalkingDataGA onStart:GAKey withChannelId:GA_AD_DE_CHANNELNAME];
                                                            });
                                                        }
                                                        
                                                        if (ADKEY.length > 1) {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [TalkingDataAppCpa init:ADKEY withChannelId:GA_AD_DE_CHANNELNAME];
                                                            });
                                                        }
                                                        
                                                        if (DEKEY.length > 1) {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [DCTrackingAgent initWithAppId:DEKEY andChannelId:GA_AD_DE_CHANNELNAME];
                                                            });
                                                        }
                                                        //进入登录
                                                        [weakSelf HTGUniteLogin];
                                                    } failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                        
                                                    }];
    [HTCustomLog setLogEnabled:showLog];
    
}

/**
 *  @brief HTGUniteSDK 登录界面入口
 *
 */
- (void)HTGUniteLogin
{
    [self showLogin];
}

/**
 *  @brief HTGUniteSDK 用户界面入口
 *
 */
- (void)HTGUniteUserCenter
{
    [self showUsercenter];
}

/**
 *  @brief HTGUniteSDK 注销, 即退出登录
 *
 */
- (void)HTGUniteLogout
{
    [RequestManager sharedManager].getLoginKeymodel.goToAutoLogin = @"0";//标记不自动登录，如果需要自动登录不光此字段未‘1’而且需要本地表示nsuserdefaults字段打开(即自动登录开关按钮打开)
    [[RequestManager sharedManager] resetNull];
    [[HTPangestureButtonManager sharedManager] hiddenHTPanGestureButton];
    HTPOSTNOTIFICATION(kHTGUniteSDKLogoutNotification);  //注销
    if ([[RequestManager sharedManager].showLoginAfterLogout isEqualToString:@"1"]) {
        [self showLogin];
    }
}

/**
 *  @brief 充值, 该接口首先获取支付渠道，然后支付并进入web支付页面
 *
 *  @param rmb          充值金额 单位元
 *  @param productID    iTunes 苹果后台配置的内购物品的产品ID
 *  @param name         商品名
 *  @param charid       角色ID
 *  @param serverid     服务器ID
 *  @param info         扩展信息
 *  @param cporderid    游戏商订单ID
 *
 */
- (void)HTGUniteFuWu:(NSString *)rmb
           productID:(NSString *)productID
         productName:(NSString *)name
              charId:(NSString *)charid
            serverId:(NSString *)serverid
          expandInfo:(NSString *)info
           cporderId:(NSString *)cporderid
{
    
    
}

/**
 *  @brief 获取本次登录的token,token即sessionid
 */
- (NSString*)HTGUniteToken
{
    return [RequestManager sharedManager].loginModel.sessionid;
}

/**
 *  @brief 获取登录的openuid, 用于标记一个用户
 */
- (NSString*)HTGUniteUID
{
    return [RequestManager sharedManager].loginModel.uid;
}

/**
 *  @brief 当前登录用户名
 */
- (NSString *)HTGUniteUserName
{
    return [RequestManager sharedManager].loginModel.username;
}

/**
 效果点事件提交接口
 
 @param pointId 效果点ID
 @param eventDic 效果字典   （字典规则细化）
 */
- (void) submitEvent:(NSString *)pointId eventDic:(NSDictionary *)eventDic
{
    if (!IS_EXIST_STR(pointId)) {
        NSLog(@"内部错误  请联系开发人员");
        return;
    }else if(pointId.intValue <= 100){
        NSLog(@"自定义事件eventType字段须大于100");
        return;
    }else if(!IS_DICTIONARY_CLASS(eventDic)){
        NSLog(@"内部错误  请联系开发人员");
        return;
    }
    ModelLogin *user = [RequestManager sharedManager].loginModel;

    NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithDictionary:
                                [ParametersUtil paseStatisticsWitheventType:pointId
                                                                        uid:user.uid
                                                                   username:user.username
                                                                productName:@""
                                                                     amount:@""
                                                                     charId:@""
                                                                    orderId:@""
                                                              advertisingId:@""
                                                         dynamicChannelName:@""
                                                              cpChannelName:@""
                                                                     remark:eventDic]];
    [dic addObjectIfNotBlank:@"1" forKey:ISSTATISTICSREQUEST];
    [[HTHTTPSessionManager sharedManager] HT_GETWithParameters:dic
                                               isShowIndicator:NO success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                   KLLog(@"++++++++++++效果点事件提交接口上传成功+++++++++++++");
                                               } failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                   KLLog(@"++++++++++++效果点事件提交接口上传失败+++++++++++++");
                                               }];
}

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
                           success:(void(^)(NSURLResponse * _Nonnull response, id _Nullable responseDict))success
                           failure:(void(^)(NSURLResponse * _Nullable response, NSError * _Nonnull error))failure
{
    [[RequestManager sharedManager] submitRoleInfoWithServerid:serverid
                                                    serverName:serverName
                                                        roleid:roleid
                                                      roleName:rolename
                                                     rolelevel:rolelevel
                                                      roleTime:roletime
                                                       success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                           success(response, responseDict);
                                                       } failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                           failure(response, error);
                                                       }];
}

/**
 支付接口
 @param CharId 角色ID
 @param serverId 服务器ID
 @param cporderid 游戏商订单ID
 @param productname 商品名
 @param money 商品金额
 @param callbackInfo 不是必要参数 默认为：callBack
 */
- (void)HTGSDKServiceWithCharId:(NSString *)CharId
                       serverId:(NSString *)serverId
                      cporderid:(NSString *)cporderid
                    productname:(NSString *)productname
                      paymentid:(NSString *)paymentid
                          money:(NSString *)money
                   callbackInfo:(NSString *)callbackInfo
{
    
    //头条SDK缓存本次支付请求数据模型
    ModelTTPay *ttpayModel = [ModelTTPay model];
    ttpayModel.contentName = productname;
    ttpayModel.currency = money;
    [RequestManager sharedManager].modelTTPay = ttpayModel;

    if ([[RequestManager sharedManager].getLoginKeymodel.isiap isEqualToString:@"true"]) {//开启内购,走内购业务
        [self appleIapPayWithCharId:CharId
                           serverId:serverId
                          cporderid:cporderid
                        productname:productname
                          paymentid:paymentid
                              money:money
                          productId:HTPRODUCTID
                       callbackInfo:callbackInfo
         ];
    }else{//走第三方支付
        [self theThirdPaymentWithCharId:CharId
                               serverId:serverId
                              cporderid:cporderid
                            productname:productname
                              paymentid:paymentid
                                  money:money
                              productId:HTPRODUCTID
                           callbackInfo:callbackInfo
         ];
    }
}


#pragma mark -  内部函数

- (void)showLogin
{
    NSArray *namesArray = [[DBManager sharedDBManager] queryDataUserNames];
    
    if (IS_ARRAY_CLASS(namesArray)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [LoginWindow sharedInstance].mainWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:[QuickLoginViewController new]];
            
            [[LoginWindow sharedInstance] show];
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [LoginWindow sharedInstance].mainWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:[LoginViewController new]];
            
            [[LoginWindow sharedInstance] show];
        });
    }
    
}

- (void)showUsercenter
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [LoginWindow sharedInstance].mainWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:[UserhomeController new]];
        
        [[LoginWindow sharedInstance] show];
    });
}

- (void)showUserpay
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [LoginWindow sharedInstance].mainWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:[UserPayWebController new]];
        
        [[LoginWindow sharedInstance] show];
    });
}

- (void)showAnnouncement
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [LoginWindow sharedInstance].mainWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:[AnnouncementWebController new]];
        
        [[LoginWindow sharedInstance] show];
    });
}

//TODO:苹果内购
- (void)appleIapPayWithCharId:(NSString *)CharId
                     serverId:(NSString *)serverId
                    cporderid:(NSString *)cporderid
                  productname:(NSString *)productname
                    paymentid:(NSString *)paymentid
                        money:(NSString *)money
                    productId:(NSString *)productId
                 callbackInfo:(NSString *)callbackInfo
{
    
    if ([SYSTEMINFO_GET_(KisFirstInstrument) isEqualToString:@"NO"]) {
        return;
    }
    
    SYSTEMINFO_SET_( @"NO", KisFirstInstrument);
    
    ModelUserPay *payModel = [RequestManager sharedManager].payModel;
    NSMutableDictionary *deviceInfo = [NSMutableDictionary dictionary];
    [deviceInfo addObjectIfNotBlank:payModel.de_appid forKey:@"de_appid"];
    [deviceInfo addObjectIfNotBlank:[DCTrackingAgent getUID] forKey:@"de_uid"];
    [deviceInfo addObjectIfNotBlank:payModel.ad_appid forKey:@"ad_appid"];
    [deviceInfo addObjectIfNotBlank:[TalkingDataAppCpa getDeviceId] forKey:@"ad_uid"];
    [deviceInfo addObjectIfNotBlank:payModel.ga_appid forKey:@"ga_appid"];
    [deviceInfo addObjectIfNotBlank:[HTUtil getIDFA] forKey:@"idfa"];
    [deviceInfo addObjectIfNotBlank:[HTUtil getiOSVersion] forKey:@"osversion"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"ac"] = @"htg_iosorder";
    parameters[@"productname"] = productname;
    parameters[@"money"] = money;
    parameters[@"productId"] = productId;
    parameters[@"serverId"] = serverId;
    parameters[@"charId"] = CharId;
    parameters[@"uid"] = [[HTGUniteSDK sharedInstance] HTGUniteUID];
    parameters[@"callbackInfo"] = IS_EXIST_STR(callbackInfo) ? callbackInfo : @"callBack";
    parameters[@"cporderid"] = cporderid;
    
    [parameters setValue:deviceInfo forKey:@"deviceInfo"];

    [parameters addObjectIfNotBlank:@"0" forKey:ISSHOW_RESPONSE_TOASTMESSAGE_KEY];

    KLLog(@"*** IAP 内购下订单 HTTPRequest ***");
    
    [[HTHTTPSessionManager sharedManager] HT_GETWithParameters:parameters
                                               isShowIndicator:YES
                                                       success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                           KLLog(@" IAP 内购下订单 return Parameter %@",responseDict);
                                                           
                                                           NSString *status = (NSString *)[responseDict objectForKey:@"status"];
                                                           if ([status isEqualToString:@"fail"]) {
                                                               SYSTEMINFO_SET_( @"YES", KisFirstInstrument);
                                                               [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE] title:kToastTips message:[responseDict objectForKey:@"msg"]];
                                                               return ;
                                                           }
                                                           
                                                           if ([status isEqualToString:@"sucess"]) {
                                                               SYSTEMINFO_SET_( @"NO", KisFirstInstrument);
                                                               [[HTMai shareHTMai] startMaiProductId:paymentid andOrderID:[responseDict objectForKey:@"orderid"]];
                                                               
                                                           }
                                                       } failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                           SYSTEMINFO_SET_( @"YES", KisFirstInstrument);
                                                           
                                                           KLLog(@" IAP 内购下订单 Error %@",error);
                                                       }];
}


//TODO:第三方支付
- (void)theThirdPaymentWithCharId:(NSString *)CharId
                         serverId:(NSString *)serverId
                        cporderid:(NSString *)cporderid
                      productname:(NSString *)productname
                        paymentid:(NSString *)paymentid
                            money:(NSString *)money
                        productId:(NSString *)productId
                     callbackInfo:(NSString *)callbackInfo
{
    ModelGetLoginKey *getkeyModel = [RequestManager sharedManager].getLoginKeymodel;
    ModelLogin *loginModel = [RequestManager sharedManager].loginModel;
    UserInfo *user = [[DBManager sharedDBManager] queryDataUserIapCountWithUserName:loginModel.username];
    NSString *userIapCount = user.iapCount;//用户已经在内购档购内购的本地缓存
    NSString *needIapCount = getkeyModel.count;//需要满足的内购次数
    NSString *leval = getkeyModel.level;
    NSArray *levalArray = [leval componentsSeparatedByString:@","];
    if (IS_ARRAY_CLASS(levalArray) && [levalArray containsObject:paymentid] && userIapCount.integerValue < needIapCount.integerValue) {//内购档包含此次用户发起支付的productID并且用户已经内购的次数少于后台配置需要满足的内购次数，走内购流程
        [self appleIapPayWithCharId:CharId
                           serverId:serverId
                          cporderid:cporderid
                        productname:productname
                          paymentid:paymentid
                              money:money
                          productId:productId
                       callbackInfo:callbackInfo];
    }else{
        NSString *payUrlString = [[RequestManager sharedManager] ht_payWithCharId:CharId
                                                                         serverId:serverId
                                                                        cporderid:cporderid
                                                                      productname:productname
                                                                            money:money
                                                                     callbackInfo:callbackInfo];
        
        [RequestManager sharedManager].payModel.payUrl = payUrlString;
        
        [RequestManager sharedManager].payModel.cporderid = cporderid;//缓存CP本次支付订单号

        
        [self showUserpay];
    }
    
}

@end

