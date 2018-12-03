//
//  HTNetWorkHelper.m
//  HTGUniteSDK
//
//  Created by zfj2602 on 2018/4/19.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "HTNetWorkHelper.h"

@implementation HTNetWorkHelper


#pragma mark - POST请求参数组合

//重新封装参数 加入app相关信息
+ (NSString *)parseParams:(NSString *)paramBase64EncodeString
{
    
    NSString *result = [NSString stringWithFormat:@"%@=%@&", HTPARAMKEY, paramBase64EncodeString];
    
    return result;
}

//重新统计事件接口封装参数  不加密直接GET请求 加入app相关信息
+ (NSString *)parseStatisticsParams:(NSDictionary *)parameters
{
    
    __block NSString *result = @"?";//[NSString stringWithFormat:@"%@=%@&", HTPARAMKEY, paramBase64EncodeString];

    
    if (IS_DICTIONARY_CLASS(parameters)) {
        [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (![key isEqualToString:ISSTATISTICSREQUEST]) {
                result = [NSString stringWithFormat:@"%@%@=%@&", result,key,obj];
            }
        }];
    }
    
    
    return result;
}


@end
