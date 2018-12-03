//
//  HTUtil.h
//  CYUserLogin
//
//  Created by zfj2602 on 16/9/19.
//  Copyright © 2016年 zfj2602. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTUtil : NSObject

/**
 *  获取设备唯一码
 *
 *  @return 唯一码
 */
+ (NSString *)getUUID;

/**
 *  手机语言
 * en-CN 或en  英文  zh-Hans-CN或zh-Hans  简体中文   zh-Hant-CN或zh-Hant  繁体中文    ja-CN或ja  日本  ......
 */
+ (NSString*)getPhoneLanguage;

+ (NSString*)getPhoneLanguageCode;

+ (NSString *)getIDFA;

+ (NSString *)getTelecomOperators;

+ (NSString *)getiOSVersion;

+ (NSString *) getDeviceType;

+ (NSString *) getCountry;

+ (NSString *)getMacAddress;

+ (NSString *)internetStatus;

+ (BOOL) isValidMobile:(NSString * ) mobile;

+ (UIImage *)getAppIcon;

+ (NSString *)getNowDate;

+ (NSString *)getCurrentTime;


/**
 *  简单截屏并将图片保存到本地
 */
+(void)makeScreenShotCompletion:(void(^)(UIImage * image))completion;


@end
