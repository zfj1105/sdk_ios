//
//  RealnameManager.m
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/24.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "RealnameManager.h"
#import "RealnameController.h"

@implementation RealnameManager : NSObject


+ (void)isGotoRealnamePageWithVc:(LoginBaseViewController *)controller
{
    //休眠2s等待提示框显示之后  退出mainwindow
//    [NSThread sleepForTimeInterval:.7];
    
    NSString *shimingrenzheng = [RequestManager sharedManager].getLoginKeymodel.shimingrenzheng;
    NSString *isShiming = [RequestManager sharedManager].loginModel.isshiming;
    
    if ([shimingrenzheng isEqualToString:@"1"]) {//不开启实名认证
        [[RequestManager sharedManager] skipToAnnouncement];
    }else if ([shimingrenzheng isEqualToString:@"2"]) {//2 强制认证,无法关闭
        if ([isShiming isEqualToString:@"1"]) {//用户已经做过实名认证
            [[RequestManager sharedManager] skipToAnnouncement];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [controller pushViewController:[RealnameController new]];
            });
        }

    }else if ([shimingrenzheng isEqualToString:@"3"]) {//3 提醒认证,可关闭
        [[RequestManager sharedManager] skipToAnnouncement];
    }else{
        [[RequestManager sharedManager] skipToAnnouncement];
    }
}



@end
