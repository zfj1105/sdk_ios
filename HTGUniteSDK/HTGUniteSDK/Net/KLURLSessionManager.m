//
//  KLURLSessionManager.m
//  HttpRequestTest
//
//  Created by zfj2602 on 17/3/10.
//  Copyright © 2017年 zfj2602. All rights reserved.
//

#import "KLURLSessionManager.h"
#import "HTNetWorkHelper.h"
#import "NSString+parameterEncodeHT.h"

@implementation KLURLSessionManager


static NSInteger timeOutInterval = 15;

/**
 GET 请求
 */
+ (void)KL_GET:(NSString *)URLString
    parameters:(NSMutableDictionary *)parameters
     isShowHUD:(BOOL)isShowIndicator
       success:(nullable void (^)(NSURLResponse * _Nonnull, id _Nullable))success
       failure:(nullable void (^)(NSURLResponse * _Nullable, NSError * _Nonnull))failure

{
    
    if (![NSJSONSerialization isValidJSONObject:parameters]) {
        return;
        KLLog(@"不合法的json格式");
    }
    
    KLLog(@"接口名（%@） 入参:::%@",parameters[@"ac"], parameters);

    NSString *paramString = [NSString ht_parameterEncode:parameters];
    
    paramString = [HTNetWorkHelper parseParams:paramString];
    
    NSString *requestString = [NSString stringWithFormat:@"%@?%@",URLString,paramString];
    
    //统计事件特殊处理参数
    if ([parameters[ISSTATISTICSREQUEST] isEqualToString:@"1"]) {
        requestString = [NSString stringWithFormat:@"%@%@",URLString,[HTNetWorkHelper parseStatisticsParams:parameters]];
    }
    
    // 截取字符串的方法!
    requestString = [requestString substringToIndex:requestString.length - 1];
    
    // 815
    requestString = [[NSString stringWithFormat:@"%@", requestString] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:requestString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutInterval];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    if (isShowIndicator) {
        [FTIndicator showProgressWithMessage:@"请求数据..." userInteractionEnable:NO];
    }

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [FTIndicator dismissProgress];
        });
        
        if (error) {
            if (failure) {
                KLLog(@"接口名（%@） errorCoce:::%ld errorMsg:::%@",parameters[@"ac"], (long)error.code, [error localizedDescription]);
                
                [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE] title:kToastTips message:[error localizedDescription]];
                
                failure(response, error);
            }
        } else {
            if (success) {
                success(response, data);
            }
        }
        
    }];
    
    [dataTask resume];
}

/**
 POST 请求
 */
+ (void)KL_POST:(NSString *)URLString
     parameters:(NSMutableDictionary *)parameters
        success:(void (^)(NSURLResponse * _Nonnull, id _Nullable))success
        failure:(void (^)(NSURLResponse * _Nullable, NSError * _Nonnull))failure
{
    
    NSURL *url = [NSURL URLWithString:URLString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:timeOutInterval];
    
    [request setHTTPMethod:@"POST"];
    
    //将需要的信息放入请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //把参数放到请求体内
    NSString *paramString = [NSString ht_parameterEncode:parameters];
    paramString = [HTNetWorkHelper parseParams:paramString];
    request.HTTPBody = [paramString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure(response, error);
            }
        } else {
            if (success) {
                success(response, data);
            }
        }
    }];
    
    [dataTask resume];
    
}

@end
