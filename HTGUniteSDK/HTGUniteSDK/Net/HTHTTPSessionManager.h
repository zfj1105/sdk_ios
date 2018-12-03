//
//  HTHTTPSessionManager.h
//  HttpRequestTest
//
//  Created by zfj2602 on 17/3/10.
//  Copyright © 2017年 zfj2602. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(NSURLResponse * _Nonnull response, id _Nullable responseDict);
typedef void(^FailureBlock)(NSURLResponse * _Nullable response, NSError * _Nonnull error);


@interface HTHTTPSessionManager : NSObject

/**
 单例

 @return HTHTTPSessionManager 的实例对象
 */
DEFINE_SINGLETON_FOR_HEADER(HTHTTPSessionManager)

/**
 GET 请求

 @param parameters 请求参数字典
 @param success 成功回调
 @param failure 失败回调
 */
- (void)HT_GETWithParameters:(NSMutableDictionary *)parameters
             isShowIndicator:(BOOL)isShowIndicator
                     success:(SuccessBlock)success
                     failure:(FailureBlock)failure;

@end
