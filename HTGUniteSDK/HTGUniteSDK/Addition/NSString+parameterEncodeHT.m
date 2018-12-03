//
//  NSString+parameterEncodeHT.m
//  HTSDK
//
//  Created by zfj2602 on 17/3/18.
//  Copyright © 2017年 zfj2602. All rights reserved.
//

#import "NSString+parameterEncodeHT.h"

@implementation NSString (parameterEncodeHT)
+ (NSString *)ht_parameterEncode:(NSMutableDictionary *)dic
{
    // 字典转NSData
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    // NSData 转字节数组
    Byte * byteData = (Byte *)[data bytes];
    
    // 字节数组分别做异或运算
    int len = (int)[data length];
    for (int i = 0; i < len; ++i)
    {
        byteData[i] ^= 123;
    }
    
    NSData * newData = [NSData dataWithBytes:byteData length:[data length]];
    
    // base64编码
    NSString * str = [newData base64EncodedStringWithOptions:0];
    
    // URL编码
    NSString * strUrlEncode = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    return strUrlEncode;
}
@end
