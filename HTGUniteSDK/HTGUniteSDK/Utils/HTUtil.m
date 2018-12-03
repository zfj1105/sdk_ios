//
//  HTUtil.m
//  CYUserLogin
//
//  Created by zfj2602 on 16/9/19.
//  Copyright © 2016年 zfj2602. All rights reserved.
//

#import "HTUtil.h"
#import <UIKit/UIKit.h>

#import "HTSSKeychain.h"
#import <AdSupport/AdSupport.h>


#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "sys/utsname.h"
#import "HTReachability.h"

#include <sys/types.h>

#include <sys/param.h>

#include <sys/ioctl.h>

#include <sys/socket.h>

#include <net/if.h>

#include <netinet/in.h>

#include <net/if_dl.h>

#include <sys/sysctl.h>

@implementation HTUtil

/**
 *  获取设备唯一码
 */
+ (NSString *)getUUID
{
    //获取设备唯一码
    
    if (![HTSSKeychain passwordForService:kService account:kAccount])
        
    {
        
        NSString *uuid = [self gen_uuid];
        
        [HTSSKeychain setPassword:uuid forService:kService account:kAccount];
        
    }
    
    
    
    NSString *devicenumber = [HTSSKeychain passwordForService:kService account:kAccount];
    
    return devicenumber;
}
+ (NSString *)gen_uuid

{
    
    CFUUIDRef uuid_ref=CFUUIDCreate(nil);
    
    CFStringRef uuid_string_ref=CFUUIDCreateString(nil, uuid_ref);
    
    CFRelease(uuid_ref);
    
    NSString *uuid=[NSString stringWithString:(__bridge NSString * _Nonnull)(uuid_string_ref)];
    
    CFRelease(uuid_string_ref);
    
    return uuid;
    
}

/**
 *  获取手机系统语言
 */
+ (NSString*)getPhoneLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    return preferredLang;
}

/**
 *  获取手机系统语言代码
 */
+ (NSString*)getPhoneLanguageCode
{
    NSString *localeLanguageCode = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    return localeLanguageCode;
}


/**
 获取设备IFDA码
 */
+ (NSString *)getIDFA{
   return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}


/**
 获取电信运营商

 @return CTTelephonyNetworkInfo
 */
+ (NSString *)getTelecomOperators{
    //获取本机运营商名称
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    
    CTCarrier *carrier = [info subscriberCellularProvider];
    
    //当前手机所属运营商名称
    
    NSString *mobile;
    
    //先判断有没有SIM卡，如果没有则不获取本机运营商
    
    if (!carrier.isoCountryCode) {
        
        NSLog(@"没有SIM卡");
        
        mobile = @"无运营商";
        
    }else{
        mobile = [carrier carrierName];
    }
    return mobile;
}

+ (NSString *)getMacAddress
{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    // MAC地址带冒号
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2),
    // *(ptr+3), *(ptr+4), *(ptr+5)];
    
    // MAC地址不带冒号
    NSString *outstring = [NSString
                           stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr + 1), *(ptr + 2), *(ptr + 3), *(ptr + 4), *(ptr + 5)];
    
    free(buf);
    
    return [outstring uppercaseString];
}

/**
 获取iOS版本号码

 @return iOSVersion
 */
+ (NSString *)getiOSVersion{
    return [[UIDevice currentDevice] systemVersion];
}
// 机型
+ (NSString *) getDeviceType{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceString;

}

+ (NSString *)internetStatus {
    
    HTReachability *reachability   = [HTReachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    NSString *net = @"WIFI";
    switch (internetStatus) {
        case ReachableViaWiFi:
            net = @"WIFI";
            break;
            
        case ReachableViaWWAN:
            net = [self getNetType];   //判断具体类型
            break;
            
        case NotReachable:
            net = @"NoNetWork";
        default:
            break;
    }
    
    return net;
}

+ (NSString *)getNetType
{
    NSString *netconnType = @"";

    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    NSString *currentStatus = info.currentRadioAccessTechnology;
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
        netconnType = @"GPRS";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
        netconnType = @"2.75G EDGE";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
        netconnType = @"3.5G HSDPA";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
        netconnType = @"3.5G HSUPA";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
        netconnType = @"2G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
        netconnType = @"HRPD";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
        netconnType = @"4G";
    }
    return netconnType;
}


// 国家
+ (NSString *) getCountry{
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    return countryCode;
}

///检测手机号码的合法性
+ (BOOL) isValidMobile:(NSString * ) mobile
{
    NSString * MOBILE = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestmobile evaluateWithObject:mobile] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (UIImage *)getAppIcon
{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    
    UIImage* image = [UIImage imageNamed:icon];
    
    return image;

}

+ (NSString *)getNowDate
{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}


//获取当地时间

+ (NSString *)getCurrentTime
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    
    return dateTime;
    
}

/**
 *  简单截屏并将图片保存到本地
 */
+(void)makeScreenShotCompletion:(void(^)(UIImage * image))completion
{
    UIWindow*screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContext(screenWindow.frame.size);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    //获取图片
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    completion(image);
    
    /**
     *  将图片保存到本地相册
     */
    UIImageWriteToSavedPhotosAlbum(image, self , @selector(onCompleteCapture:didFinishSavingWithError:contextInfo:), nil);//保存图片到照片库
}
/**
 *  图片保存到本地后的回调
 */
//图片保存完后调用的方法
+ (void)onCompleteCapture:(UIImage *)screenImage didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error){
        //保存失败
#ifdef DEBUG
        NSLog(@"屏幕截图保存相册失败：%@",error);
#endif
    }else {
        //保存成功
#ifdef DEBUG
        NSLog(@"屏幕截图保存相册成功");
#endif
    }
}

@end
