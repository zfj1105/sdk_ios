//
//  HTNetWorkHelper.h
//  HTGUniteSDK
//
//  Created by zfj2602 on 2018/4/19.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTNetWorkHelper : NSObject


//重新封装参数 加入app相关信息
+ (NSString *)parseParams:(NSString *)paramBase64EncodeString;


+ (NSString *)parseStatisticsParams:(NSDictionary *)parameters;
@end
