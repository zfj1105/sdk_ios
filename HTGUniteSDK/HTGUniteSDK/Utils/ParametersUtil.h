//
//  ParametersUtil.h
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/20.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParametersUtil : NSObject

+ (NSDictionary *)paseParametersWithProductId:(NSString *)productId
                                       coopid:(NSString *)coopid
                                     username:(NSString *)username
                                     password:(NSString *)password
                                   registType:(NSString *)registType;

+ (NSDictionary *)paseCodeLoginWithProductId:(NSString *)productId
                                       coopid:(NSString *)coopid
                                        phone:(NSString *)phone
                                        code:(NSString *)code;

+ (NSDictionary *)paseUserNameRegisterWithProductId:(NSString *)productId
                                      coopid:(NSString *)coopid
                                    username:(NSString *)username
                                           password:(NSString *)password
                                      cpChannelName:(NSString *)cpChannelName
                                         registType:(NSString *)registType
                                               code:(NSString *)code
                                              phone:(NSString *)phone;

+ (NSDictionary *)paseStatisticsWitheventType:(NSString *)eventType
                                          uid:(NSString *)uid
                                     username:(NSString *)username
                                  productName:(NSString *)productName
                                       amount:(NSString *)amount
                                       charId:(NSString *)charId
                                      orderId:(NSString *)orderId
                                advertisingId:(NSString *)advertisingId
                           dynamicChannelName:(NSString *)dynamicChannelName
                                cpChannelName:(NSString *)cpChannelName;

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
                                       remark:(NSDictionary *)remark;


+ (NSDictionary *)pasePayOrderParametrWithCharId:(NSString *)CharId
                                    callbackInfo:(NSString *)callbackInfo
                                        serverId:(NSString *)serverId
                                       cporderid:(NSString *)cporderid
                                     productname:(NSString *)productname
                                       productId:(NSString *)productId
                                           money:(NSString *)money;

@end
