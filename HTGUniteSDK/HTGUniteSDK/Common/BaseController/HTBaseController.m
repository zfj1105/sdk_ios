//
//  HTBaseController.m
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/26.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "HTBaseController.h"

@interface HTBaseController ()

@end

@implementation HTBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)deviceOrientationDidChange
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if(orientation == UIDeviceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        
        [self orientationChange:NO];
        
        //注意： UIDeviceOrientationLandscapeLeft 与 UIInterfaceOrientationLandscapeRight
    } else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        

        [self orientationChange:YES];
    }
}

- (void)orientationChange:(BOOL)landscapeRight
{
    if (landscapeRight) {//横屏
        KLLog(@"!!!横屏!!!");
        [UIView animateWithDuration:0.2f animations:^{
            self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
            
            [self customNavigationControllerWithWidth:500 height:300 isCenterInParent:YES originY:0];

        }];
    } else {//竖屏
        KLLog(@"!!!竖屏!!!");
        [UIView animateWithDuration:0.2f animations:^{
            self.view.transform = CGAffineTransformMakeRotation(0);
            
            [self customNavigationControllerWithWidth:NAVIGATIONCONTROLLERHWIDTH height:300 isCenterInParent:YES originY:0];
        }];
    }
}

//TODO:控制画布大小
- (void)customNavigationControllerWithWidth:(float)aWidth
                                     height:(float)aHeight
                           isCenterInParent:(BOOL)isCenter
                                    originY:(float)originY
{
    
    self.navigationController.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    
    if (isCenter) {
        [self.navigationController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo([LoginWindow sharedInstance].mainWindow);
            make.size.mas_equalTo(CGSizeMake(aWidth, aHeight));
        }];
    }else{
        [self.navigationController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo([LoginWindow sharedInstance].mainWindow);
            make.top.equalTo([LoginWindow sharedInstance].mainWindow).offset(originY);
            make.size.mas_equalTo(CGSizeMake(aWidth, aHeight));
        }];
    }
    
    self.navigationController.view.layer.cornerRadius = 8;
    self.navigationController.view.clipsToBounds=YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    // 如果该界面需要支持横竖屏切换
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationLandscapeLeft;
    
}


@end
