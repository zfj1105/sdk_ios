//
//  NSString+StringHT.h
//  HTSDK
//
//  Created by zfj2602 on 17/3/17.
//  Copyright © 2017年 zfj2602. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringHT)

/**
 判断字符串是否为空

 @return YES : NO
 */
- (BOOL)isEmpty;

/**
 获取沙盒下的文件

 @param fileName 文件名
 @return return value description
 */
+ (NSString *)getHomeDirectoryFileWithFileName:(NSString *)fileName;

/**
 判断手机号合法性
 
 @return return value description
 */
- (BOOL)checkPhone;

/**
 判断邮箱的合法性

 @return return value description
 */
- (BOOL)checkEmail;

/**
 判断身份证号

 @return return value description
 */
- (BOOL)checkIdCard;


/**
 MD5 加密

 @return return value description
 */
- (NSString *)stringToMD5;
- (NSString *)STRINGTOMD5;

+ (NSString *)return16LetterAndNumber;

@end
