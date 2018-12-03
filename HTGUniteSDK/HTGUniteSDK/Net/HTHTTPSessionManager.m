//
//  HTHTTPSessionManager.m
//  HttpRequestTest
//
//  Created by zfj2602 on 17/3/10.
//  Copyright © 2017年 zfj2602. All rights reserved.

//  modify by zhangfujun
//

#import "HTHTTPSessionManager.h"
#import "KLURLSessionManager.h"
#import "NSData+parameterDecodeHT.h"
@implementation HTHTTPSessionManager

/**
 单例
 */
DEFINE_SINGLETON_FOR_CLASS(HTHTTPSessionManager)

- (void)HT_GETWithParameters:(NSMutableDictionary *)parameters
             isShowIndicator:(BOOL)isShowIndicator
                     success:(SuccessBlock)success
                     failure:(FailureBlock)failure
{
    NSString *domain = KAPI_HEAD;
    
    __block BOOL isShowResponseToast = [parameters[ISSHOW_RESPONSE_TOASTMESSAGE_KEY] isEqualToString:ISSHOW_RESPONSE_TOASTMESSAGE] ? NO :YES;
    
    if ([parameters[ISSTATISTICSREQUEST] isEqualToString:@"1"]) {//统计事件domain特殊化处理
        domain = KAPI_STATISTICS;
    }
    
    [KLURLSessionManager KL_GET:domain
                     parameters:parameters
                      isShowHUD:isShowIndicator
                        success:^(NSURLResponse * _Nonnull respose, id  _Nullable responseObject) {
                            NSError *error = nil;
                            
                            NSData *responseData = [NSData ht_decodeData:responseObject];

                            //统计事件出参不解密
                            if ([parameters[ISSTATISTICSREQUEST] isEqualToString:@"1"]) {
                                responseData = responseObject;
                            }
                            
                            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                        options:NSJSONReadingMutableLeaves
                                                                                          error:&error];
                            NSString *codeResponse = [NSString stringWithFormat:@"%@", responseDic[@"code"]];
                            
                            if (error) {//NSJSONSerialization 解析报错
                                KLLog(@"接口名（%@） 出参:::%@",parameters[@"ac"], @"server端返回非法的json字符串");
                                failure(respose, [NSError errorWithDomain:NSCocoaErrorDomain code:codeResponse.intValue userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"server端返回非法的json字符串", NSLocalizedDescriptionKey, nil]]);
                            }else {
                                KLLog(@"接口名（%@） 出参:::%@",parameters[@"ac"], responseDic);
                                
                                
                                if ([parameters[ISSTATISTICSREQUEST] isEqualToString:@"1"]) {//统计事件success  code 为200！！！！！
                                    if ([codeResponse isEqualToString:@"200"]) {
                                        success(respose, responseDic);
                                    }
                                    
                                }else if ([codeResponse isEqualToString:@"1"]) {//只有状态为‘1’才是返回成功数据的json
                                    if (isShowResponseToast) {
                                        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE] title:kToastTips message:responseDic[@"msg"]];
                                    }
                                    success(respose, responseDic);
                                }else{
                                    if (isShowResponseToast) {
                                        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE] title:kToastTips message:responseDic[@"msg"]];
                                    }
                                    failure(respose, [NSError errorWithDomain:NSCocoaErrorDomain code:codeResponse.intValue userInfo:[NSDictionary dictionaryWithObjectsAndKeys:responseDic[@"msg"], NSLocalizedDescriptionKey, nil]]);
                                }
                                
                            }

                        } failure:^(NSURLResponse * _Nullable respose, NSError * _Nonnull error) {
                            
                            failure(respose,error);
                            [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE] title:kToastTips message:[error localizedDescription]];
                        }];
}

@end

