//
//  HTReachabilityHandle.h
//  HTSDK
//
//  Created by zfj2602 on 17/4/7.
//  Copyright © 2017年 zfj2602. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTReachabilityHandle : NSObject

/**
 网络是否可用

 @return return value description
 */
+ (BOOL)htIsAbilityNetwork;


/**
 获取当前网络的状态

 @return 4G Wifi 。。。
 */
+ (NSString *)getNetconnType;

@end
