//
//  NSData+parameterDecodeHT.m
//  HTSDK
//
//  Created by zfj2602 on 17/3/18.
//  Copyright © 2017年 zfj2602. All rights reserved.
//

#import "NSData+parameterDecodeHT.h"

@implementation NSData (parameterDecodeHT)
+ (NSData *)ht_parameterDecode:(NSString *)strEncode
{
    NSString * strDecode = [strEncode stringByRemovingPercentEncoding];
    NSData * dataDecode = [[NSData alloc] initWithBase64EncodedString:strDecode options:0];
    Byte * byteData = (Byte *)[dataDecode bytes];
    
    int len = (int)[dataDecode length];
    for (int i = 0; i < len; ++i)
    {
        byteData[i] ^= 123;
    }
    NSData * newData = [[NSData alloc] initWithBytes:byteData length:[dataDecode length]];
    return newData;
}

+ (NSData *)ht_decodeData:(NSData *)encodeData
{
    NSString *encodeString = [[NSString alloc] initWithData:encodeData encoding:NSUTF8StringEncoding];
    
    NSData *decodeData = [self ht_parameterDecode:encodeString];
    
    return decodeData;

}

@end
