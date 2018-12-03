//
//  ModelUserPay.h
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/28.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "HTBaseModel.h"


@interface ModelUserPay : HTBaseModel

DEFINE_MODEL_FOR_HEADER


@property (nonatomic, strong) NSString *de_appid;  //!<  DataEye Appid

@property (nonatomic, strong) NSString *ad_appid;   //!<    AD Appid

@property (nonatomic, strong) NSString *ga_appid;  //!<   GA Appid

@property (nonatomic, strong) NSString *payUrl;  //!<   支付跳转的URL  server 返回的出参

@property (nonatomic, strong) NSString *cporderid;  //!<   cp订单号



//@property (nonatomic, strong) NSString *de_appid;  //!<  DataEye Appid
//
//@property (nonatomic, strong) NSString *ad_appid;   //!<    AD Appid
//
//@property (nonatomic, strong) NSString *ga_appid;  //!<   GA Appid
//
//@property (nonatomic, strong) NSString *payUrl;  //!<   支付跳转的URL  server 返回的出参



@end
