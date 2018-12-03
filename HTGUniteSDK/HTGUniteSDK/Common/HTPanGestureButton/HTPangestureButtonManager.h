//
//  HTPangestureButtonManager.h
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/27.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTPanGestureButton.h"


@interface HTPangestureButtonManager : NSObject <HTPanGestureButtonDelegate>

DEFINE_SINGLETON_FOR_HEADER(HTPangestureButtonManager)

@property (nonatomic, strong) HTPanGestureButton *panButton;   //可移动按钮

- (void)showHTPanGestureButtonInKeyWindow;

- (void)showHTPanGestureButtonInMainWindow;

- (void)hiddenHTPanGestureButton;


@end
