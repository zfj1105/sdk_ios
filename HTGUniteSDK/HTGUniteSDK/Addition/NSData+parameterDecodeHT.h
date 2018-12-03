//
//  NSData+parameterDecodeHT.h
//  HTSDK
//
//  Created by zfj2602 on 17/3/18.
//  Copyright © 2017年 zfj2602. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (parameterDecodeHT)

/**
 解码参数(HT解码规则)

 @param strEncode 要解码的字符串
 @return 解码完的NSData
 */
+ (NSData *)ht_parameterDecode:(NSString *)strEncode;

+ (NSData *)ht_decodeData:(NSData *)encodeDatas;
@end
