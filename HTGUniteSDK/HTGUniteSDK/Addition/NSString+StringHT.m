//
//  NSString+StringHT.m
//  HTSDK
//
//  Created by zfj2602 on 17/3/17.
//  Copyright © 2017年 zfj2602. All rights reserved.
//

#import "NSString+StringHT.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (StringHT)

- (BOOL)isEmpty
{
    BOOL isempty = [self isKindOfClass:[NSNull class]] || self == nil || [self length] < 1  ? YES : NO ;
    return  isempty;
}

+ (NSString *)getHomeDirectoryFileWithFileName:(NSString *)fileName
{
    //获取当前应用沙盒的根目录
    NSString *homePath = NSHomeDirectory();
    //拼接路径
    NSString *docPath = [homePath stringByAppendingPathComponent:@"Documents"];
    //还要指定存储文件的文件名称,仍然使用字符串拼接
    NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
    return filePath;
}


#pragma mark --判断手机号合法性

- (BOOL)checkPhone

{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

#pragma mark 判断邮箱

- (BOOL)checkEmail
{
    
    //^(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w{2,3}){1,3})$
    
    NSString *regex = @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [emailTest evaluateWithObject:self];
    
}

#pragma mark   判断身份证号
- (BOOL)checkIdCard
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

#pragma mark    ---     MD5 加密
- (NSString *)stringToMD5{
    //1.首先将字符串转换成UTF-8编码, 因为MD5加密是基于C语言的,所以要先把字符串转化成C语言的字符串
    const char *fooData = [self UTF8String];
    
    //2.然后创建一个字符串数组,接收MD5的值
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    //3.计算MD5的值, 这是官方封装好的加密方法:把我们输入的字符串转换成16进制的32位数,然后存储到result中
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);
    /**
     第一个参数:要加密的字符串
     第二个参数: 获取要加密字符串的长度
     第三个参数: 接收结果的数组
     */
    
    //4.创建一个字符串保存加密结果
    NSMutableString *saveResult = [NSMutableString string];
    
    //5.从result 数组中获取加密结果并放到 saveResult中
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02x", result[i]];
    }
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     LKLLog("%02X", 0x888);  //888
     LKLLog("%02X", 0x4); //04
     */
    return saveResult;

}

#pragma mark    ---     MD5 加密
- (NSString *)STRINGTOMD5{
    
    NSData *dd = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char result[16];
    CC_MD5([dd bytes], (int)[dd length], result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];//x就是小写的字母，X就是大写的字母，2个字节不足补0
    }
    return hash;
}

//TODO:生成注册用户名随机数
+ (NSString *)return16LetterAndNumber
{
    //定义一个包含数字，大小写字母的字符串
    NSString * strAll = @"abcdefghijkmnpqrstuvwxyz";
    
    //获取随机数
    NSInteger index = arc4random() % (strAll.length-1);
    char tempStr = [strAll characterAtIndex:index];
    
    //定义一个结果
    NSString * result = [[NSMutableString alloc]initWithFormat:@"%c",tempStr];

    int x = arc4random() % 1000000;
    
    result = (NSMutableString *)[result stringByAppendingString:[NSString stringWithFormat:@"%d",x]];
    
    return result;
}

@end
