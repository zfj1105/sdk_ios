//
//  HTCustomLog.m
//  HTSDK
//
//  Created by zfj2602 on 17/3/13.
//  Copyright © 2017年 zfj2602. All rights reserved.
//

#import "HTCustomLog.h"
static BOOL HT_Log_Switch = YES;
static BOOL HT_TrackPrint_Switch = YES;

@implementation HTCustomLog

#pragma mark - 自定义打印开关
+ (void)setLogEnabled:(BOOL)value {
    HT_Log_Switch = value;
}

+ (BOOL)logEnable {
    return HT_Log_Switch;
}

+ (void)setTrackPrintEnabled:(BOOL)value {
    HT_TrackPrint_Switch = value;
}

+ (BOOL)trackPrintEnable {
    return HT_TrackPrint_Switch;
}

@end
