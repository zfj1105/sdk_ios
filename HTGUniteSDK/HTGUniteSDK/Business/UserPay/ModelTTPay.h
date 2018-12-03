//
//  ModelTTPay.h
//  HTGUniteSDKDev
//
//  Created by zfj2602 on 2018/9/20.
//  Copyright © 2018年 haitui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ModelTTPay : NSObject

DEFINE_MODEL_FOR_HEADER

@property (nonatomic, strong) NSString *contentType;  //!<  内容类型如“配备”、“皮肤”

@property (nonatomic, strong) NSString *contentName;   //!<    商品或内容名称

@property (nonatomic, strong) NSString *contentID;  //!<   商品或内容标识符

@property (nonatomic, strong) NSString *contentNumber;  //!<   商品数量

@property (nonatomic, strong) NSString *paymentChannel;  //!<   支付渠道名，如支付宝、微信等

@property (nonatomic, strong) NSString *currency;  //!<   真实货币类型，ISO 4217代码，如：“USD”

@property (nonatomic, strong) NSString *currency_amount;  //!<   本次支付的真实货币的金额

@property (nonatomic, strong) NSString *isSuccess;  //!<   支付是否成功


@end

NS_ASSUME_NONNULL_END
