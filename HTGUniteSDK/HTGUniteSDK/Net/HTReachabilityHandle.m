//
//  HTReachabilityHandle.m
//  HTSDK
//
//  Created by zfj2602 on 17/4/7.
//  Copyright © 2017年 zfj2602. All rights reserved.
//

#import "HTReachabilityHandle.h"

#import "HTReachability.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
@implementation HTReachabilityHandle
+ (BOOL)htIsAbilityNetwork
{
    BOOL isAble;
    HTReachability *reach = [HTReachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    switch (status) {
        case NotReachable:
            isAble = NO;
            break;
        case ReachableViaWiFi:
            isAble = YES;
            break;
        case ReachableViaWWAN:
            isAble = YES;
            break;

        default:
            break;
    }
    if (!isAble) {
        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE]
                                         title:kToastTips
                                       message:@"网络连接失败,请检查网络!"];

    }
    
    return isAble;
}


+ (NSString *)getNetconnType{
    
    NSString *netconnType = @"";
    HTReachability *reach = [HTReachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    
    switch (status) {
        case NotReachable:// 没有网络
        {
            
            netconnType = @"no network";
        }
            break;
            
        case ReachableViaWiFi:// Wifi
        {
            netconnType = @"Wifi";
        }
            break;
            
        case ReachableViaWWAN:// 手机自带网络
        {
            // 获取手机网络类型
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
        }
            break;
            
        default:
            break;
    }
    
    return netconnType;
}







@end
