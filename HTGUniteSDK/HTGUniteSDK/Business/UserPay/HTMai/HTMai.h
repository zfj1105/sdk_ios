//
//  HTMai.h
//  HTSDK
//
//  Created by zfj2602 on 17/4/8.
//  Copyright © 2017年 zfj2602. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import <CommonCrypto/CommonCrypto.h>

@protocol HTIPAMaiDelegate <NSObject>

/**
 不允许程序内付费购买
 */
- (void)sdkStoreNotAllowMai;


/**
 无法获取商品信息
 */
- (void)sdkStoreNoProductInfo;


/**
 购买商品中
 */
- (void)sdkStoreMaing;

/**
 交易是否失败
 */
- (void)sdkStoreMaiComplete:(BOOL)isComplete;
@end

@interface HTMai : NSObject <SKPaymentTransactionObserver,SKProductsRequestDelegate,HTIPAMaiDelegate>
@property (nonatomic, strong)           NSString *pubKey;
/**
 处理购买过程事务的代理
 */
@property (nonatomic, assign)           id <HTIPAMaiDelegate>ipaDelegate;

/**
 商品ID
 */
@property (nonatomic, strong)           NSString *productID;

/**
 订单信息
 */
@property (nonatomic, strong)           NSString *orderID;



/**
 iOS 内购类的单例
 */
+ (HTMai *)shareHTMai;


/**
 开始购买
 */
- (void)startMaiProductId:(NSString*)productId andOrderID:(NSString *)orederID;

@end
