//
//  HTPangestureButtonManager.m
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/27.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "HTPangestureButtonManager.h"
#import "UIImage+findBundleImageHT.h"

@implementation HTPangestureButtonManager


DEFINE_SINGLETON_FOR_CLASS(HTPangestureButtonManager)

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (HTPanGestureButton *)panButton
{
    if (!_panButton) {
        
        _panButton = [[HTPanGestureButton alloc] initWithFrame:CGRectZero Delegate:self];
        [_panButton setImage:[UIImage imagesNamedFromCustomBundle:@"4398icon"] forState:UIControlStateNormal];
        
    }
    return _panButton;
}

- (void)showHTPanGestureButtonInKeyWindow
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.panButton removeFromSuperview];
        
        [self.panButton showHTPanGestureButtonInView:[LoginWindow sharedInstance].keyWindow];
    });

}

- (void)showHTPanGestureButtonInMainWindow
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.panButton removeFromSuperview];
        
        [self.panButton showHTPanGestureButtonInView:[LoginWindow sharedInstance].mainWindow];
    });

}

- (void)hiddenHTPanGestureButton
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.panButton removeFromSuperview];
    });
}
#pragma mark - suspensionview 代理

- (void)htPanGestureButtonClick:(HTPanGestureButton *)panButton
{
    
    [[HTGUniteSDK sharedInstance] showUsercenter];
}




@end
