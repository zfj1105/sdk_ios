//
//  ParametersUtil.m
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/20.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "ParametersUtil.h"
#import "DCTrackingAgent.h"
#import "TalkingDataAppCpa.h"
#import "TalkingDataGA.h"

@implementation ParametersUtil

+ (NSDictionary *)paseParametersWithProductId:(NSString *)productId
                                       coopid:(NSString *)coopid
                                     username:(NSString *)username
                                     password:(NSString *)password
                                   registType:(NSString *)registType
{
    //请求参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *mobileInfo = [NSMutableDictionary dictionary];
    [mobileInfo addObjectIfNotBlank:[HTUtil getUUID] forKey:@"deviceId"];
    [mobileInfo addObjectIfNotBlank:[HTUtil getPhoneLanguage] forKey:@"language"];
    [dic setValue:mobileInfo forKey:@"mobileInfo"];
    
    NSMutableDictionary *clientInfo = [NSMutableDictionary dictionary];
    [clientInfo addObjectIfNotBlank:HTPRODUCTID forKey:@"productId"];
    [dic setValue:clientInfo forKey:@"clientInfo"];
        
    NSMutableDictionary *gameInfo = [NSMutableDictionary dictionary];
    [gameInfo addObjectIfNotBlank:HTCOOPID forKey:@"coopid"];
    [dic setValue:gameInfo forKey:@"gameInfo"];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo addObjectIfNotBlank:username forKey:@"username"];
    [userInfo addObjectIfNotBlank:password forKey:@"password"];
    [userInfo addObjectIfNotBlank:OSTYPE forKey:@"ostype"];
    [userInfo addObjectIfNotBlank:registType forKey:@"registType"];
    [userInfo addObjectIfNotBlank:OSTYPE forKey:@"code"];
    [userInfo addObjectIfNotBlank:registType forKey:@"phone"];


    [dic setValue:userInfo forKey:@"userInfo"];

    
    return dic;

}

+ (NSDictionary *)paseCodeLoginWithProductId:(NSString *)productId
                                      coopid:(NSString *)coopid
                                       phone:(NSString *)phone
                                        code:(NSString *)code

{
    //请求参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *mobileInfo = [NSMutableDictionary dictionary];
    [mobileInfo addObjectIfNotBlank:[HTUtil getUUID] forKey:@"deviceId"];
    [mobileInfo addObjectIfNotBlank:[HTUtil getPhoneLanguage] forKey:@"language"];
    [dic setValue:mobileInfo forKey:@"mobileInfo"];
    
    NSMutableDictionary *clientInfo = [NSMutableDictionary dictionary];
    [clientInfo addObjectIfNotBlank:productId forKey:@"productId"];
    [dic setValue:clientInfo forKey:@"clientInfo"];
    
    NSMutableDictionary *gameInfo = [NSMutableDictionary dictionary];
    [gameInfo addObjectIfNotBlank:coopid forKey:@"coopid"];
    [dic setValue:gameInfo forKey:@"gameInfo"];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo addObjectIfNotBlank:code forKey:@"code"];
    [userInfo addObjectIfNotBlank:phone forKey:@"phone"];
    [dic setValue:userInfo forKey:@"userInfo"];
    
    
    return dic;
    
}

+ (NSDictionary *)paseUserNameRegisterWithProductId:(NSString *)productId
                                             coopid:(NSString *)coopid
                                           username:(NSString *)username
                                           password:(NSString *)password
                                      cpChannelName:(NSString *)cpChannelName
                                         registType:(NSString *)registType
                                               code:(NSString *)code
                                              phone:(NSString *)phone
{
    //请求参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *mobileInfo = [NSMutableDictionary dictionary];
    [mobileInfo addObjectIfNotBlank:[HTUtil getUUID] forKey:@"deviceId"];
    [mobileInfo addObjectIfNotBlank:[HTUtil getPhoneLanguage] forKey:@"language"];
    [dic setValue:mobileInfo forKey:@"mobileInfo"];
    
    NSMutableDictionary *clientInfo = [NSMutableDictionary dictionary];
    [clientInfo addObjectIfNotBlank:HTPRODUCTID forKey:@"productId"];
    [dic setValue:clientInfo forKey:@"clientInfo"];
    
    NSMutableDictionary *gameInfo = [NSMutableDictionary dictionary];
    [gameInfo addObjectIfNotBlank:coopid forKey:@"coopid"];
    [dic setValue:gameInfo forKey:@"gameInfo"];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo addObjectIfNotBlank:username forKey:@"username"];
    [userInfo addObjectIfNotBlank:password forKey:@"password"];
    
    [userInfo addObjectIfNotBlank:phone forKey:HTSDKPHONE];
    [userInfo addObjectIfNotBlank:code forKey:HTSDKPHONECODE];

    [userInfo addObjectIfNotBlank:OSTYPE forKey:@"ostype"];
    [userInfo addObjectIfNotBlank:registType forKey:@"registType"];
    [dic setValue:userInfo forKey:@"userInfo"];
    
    NSMutableDictionary *htInfo = [NSMutableDictionary dictionary];
    [htInfo addObjectIfNotBlank:HTCPCHANNELNAME forKey:@"cpChannelName"];
    [htInfo addObjectIfNotBlank:[HTUtil getIDFA] forKey:@"idfa"];
    [dic setValue:OSTYPE forKey:@"platform"];
    [dic setValue:[HTUtil getUUID] forKey:@"uuid"];

    
    
    return dic;
    
}

//TODO:统计事件
+ (NSDictionary *)paseStatisticsWitheventType:(NSString *)eventType
                                          uid:(NSString *)uid
                                     username:(NSString *)username
                                  productName:(NSString *)productName
                                       amount:(NSString *)amount
                                       charId:(NSString *)charId
                                      orderId:(NSString *)orderId
                                advertisingId:(NSString *)advertisingId
                           dynamicChannelName:(NSString *)dynamicChannelName
                                cpChannelName:(NSString *)cpChannelName
{
    //请求参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    
    [dic addObjectIfNotBlank:@"2" forKey:@"platform"];//固定值‘2’代表ios
    
    [dic addObjectIfNotBlank:HTPRODUCTID forKey:@"productId"];

    [dic addObjectIfNotBlank:eventType forKey:@"eventType"];
    
    [dic addObjectIfNotBlank:[HTUtil getTelecomOperators] forKey:@"operator"];
    
    [dic addObjectIfNotBlank:[HTUtil internetStatus] forKey:@"network"];

    [dic addObjectIfNotBlank:[HTUtil getiOSVersion] forKey:@"osVersion"];
    
    [dic addObjectIfNotBlank:[HTUtil getDeviceType] forKey:@"deviceType"];
    
    [dic addObjectIfNotBlank:[HTUtil getPhoneLanguage] forKey:@"lang"];
    
    [dic addObjectIfNotBlank:[HTUtil getPhoneLanguageCode] forKey:@"langCode"];

    [dic addObjectIfNotBlank:[HTUtil getCountry] forKey:@"country"];
    
    [dic addObjectIfNotBlank:uid forKey:@"uid"];

    [dic addObjectIfNotBlank:username forKey:@"userName"];
    
    [dic addObjectIfNotBlank:productName forKey:@"productName"];
    
    [dic addObjectIfNotBlank:amount forKey:@"amount"];
    
    [dic addObjectIfNotBlank:charId forKey:@"charId"];
    
    [dic addObjectIfNotBlank:orderId forKey:@"orderId"];

    [dic addObjectIfNotBlank:[HTUtil getUUID] forKey:@"deviceId"];
    
    [dic addObjectIfNotBlank:[HTUtil getIDFA] forKey:@"idfa"];

    [dic addObjectIfNotBlank:@"" forKey:@"ime1"];
    
    [dic addObjectIfNotBlank:@"" forKey:@"ime2"];
    
    [dic addObjectIfNotBlank:[HTUtil getMacAddress] forKey:@"mac"];
    
    [dic addObjectIfNotBlank:@"" forKey:@"androidId"];
    
    [dic addObjectIfNotBlank:advertisingId forKey:@"advertisingId"];
    
    [dic addObjectIfNotBlank:dynamicChannelName forKey:@"dynamicChannelName"];
    
    [dic addObjectIfNotBlank:HTCPCHANNELNAME forKey:@"cpChannelName"];

    
    return dic;
    
}

//TODO:埋点入参组合
+ (NSDictionary *)paseStatisticsWitheventType:(NSString *)eventType
                                          uid:(NSString *)uid
                                     username:(NSString *)username
                                  productName:(NSString *)productName
                                       amount:(NSString *)amount
                                       charId:(NSString *)charId
                                      orderId:(NSString *)orderId
                                advertisingId:(NSString *)advertisingId
                           dynamicChannelName:(NSString *)dynamicChannelName
                                cpChannelName:(NSString *)cpChannelName
                                       remark:(NSDictionary *)remark
{
    //请求参数
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:[self paseStatisticsWitheventType:eventType
                                                                                                            uid:uid
                                                                                                       username:username
                                                                                                    productName:productName
                                                                                                         amount:amount
                                                                                                         charId:charId
                                                                                                        orderId:orderId
                                                                                                  advertisingId:advertisingId
                                                                                             dynamicChannelName:dynamicChannelName
                                                                                                  cpChannelName:cpChannelName]];
    
    [dic addObjectIfNotBlank:remark forKey:@"remark"];
    
    return dic;
    
}

+ (NSDictionary *)pasePayOrderParametrWithCharId:(NSString *)CharId
                                    callbackInfo:(NSString *)callbackInfo
                                        serverId:(NSString *)serverId
                                       cporderid:(NSString *)cporderid
                                     productname:(NSString *)productname
                                       productId:(NSString *)productId
                                           money:(NSString *)money
{
    //请求参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    
    ModelLogin *loginModel = [RequestManager sharedManager].loginModel;
    ModelUserPay *payModel = [RequestManager sharedManager].payModel;
    
    NSMutableDictionary *deviceInfo = [NSMutableDictionary dictionary];
    [deviceInfo addObjectIfNotBlank:payModel.de_appid forKey:@"de_appid"];
    [deviceInfo addObjectIfNotBlank:[DCTrackingAgent getUID] forKey:@"de_uid"];
    [deviceInfo addObjectIfNotBlank:payModel.ad_appid forKey:@"ad_appid"];
    [deviceInfo addObjectIfNotBlank:[TalkingDataAppCpa getDeviceId] forKey:@"ad_uid"];
    [deviceInfo addObjectIfNotBlank:payModel.ga_appid forKey:@"ga_appid"];
    [deviceInfo addObjectIfNotBlank:[HTUtil getIDFA] forKey:@"idfa"];
    [deviceInfo addObjectIfNotBlank:[HTUtil getiOSVersion] forKey:@"osversion"];
    [dic setValue:deviceInfo forKey:@"deviceInfo"];
    
    
    [dic addObjectIfNotBlank:CharId forKey:@"charId"];
    
    [dic addObjectIfNotBlank:loginModel.sessionid forKey:@"sessionid"];

    [dic addObjectIfNotBlank:HTAC_PAY forKey:@"ac"];

    [dic addObjectIfNotBlank: IS_EXIST_STR(callbackInfo) ? callbackInfo : @"callBack" forKey:@"callbackInfo"];

    [dic addObjectIfNotBlank:serverId forKey:@"serverId"];

    [dic addObjectIfNotBlank:cporderid forKey:@"cporderid"];

    [dic addObjectIfNotBlank:HTUniteSDKVersion forKey:@"sdkversion"];

    [dic addObjectIfNotBlank:OSTYPE forKey:@"ostype"];

    [dic addObjectIfNotBlank:productname forKey:@"productname"];

    [dic addObjectIfNotBlank:productId forKey:@"productId"];

    [dic addObjectIfNotBlank:money forKey:@"money"];

    return dic;
    
}

@end
