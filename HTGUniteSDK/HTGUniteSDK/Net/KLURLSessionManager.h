//
//  KLURLSessionManager.h
//  HttpRequestTest
//
//  Created by zfj2602 on 17/3/10.
//  Copyright © 2017年 zfj2602. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KLURLSessionManager : NSObject


/**
 NS_ASSUME_NONNULL_BEGIN
 系统宏定义, 取消 Pointer is missing a nullability type specifier 警告
 NS_ASSUME_NONNULL_END
 */
NS_ASSUME_NONNULL_BEGIN

/**
 GET 请求
 
 @param URLString 接口字符串
 @param parameters 请求参数字典
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)KL_GET:(NSString *)URLString
    parameters:(NSMutableDictionary *)parameters
     isShowHUD:(BOOL)isShowIndicator
       success:(nullable void (^)(NSURLResponse *respose, id _Nullable responseObject))success
       failure:(nullable void (^)(NSURLResponse * _Nullable respose , NSError *error))failure;


/**
 POST 请求
 
 @param URLString 接口字符串
 @param parameters 请求参数字典
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)KL_POST:(NSString *)URLString
     parameters:(NSMutableDictionary *)parameters
        success:(nullable void (^)(NSURLResponse *respose, id _Nullable responseObject))success
        failure:(nullable void (^)(NSURLResponse * _Nullable respose , NSError *error))failure;


NS_ASSUME_NONNULL_END
@end
