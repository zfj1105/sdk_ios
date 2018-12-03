//
//  NSString+parameterEncodeHT.h
//  HTSDK
//
//  Created by zfj2602 on 17/3/18.
//  Copyright © 2017年 zfj2602. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (parameterEncodeHT)

/**
 对参数进行加密(HT加密规则)

 @param dic 要加密的字典
 @return 加密后的字符串
 */
+ (NSString *)ht_parameterEncode:(NSMutableDictionary *)dic;
@end
