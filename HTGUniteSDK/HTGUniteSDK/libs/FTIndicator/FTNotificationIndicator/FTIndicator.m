//
//  FTIndicator.m
//  FTIndicator
//
//  Created by liufengting on 16/7/21.
//  Copyright © 2016年 liufengting ( https://github.com/liufengting ). All rights reserved.
//

#import "FTIndicator.h"

@interface FTIndicator ()

@end

@implementation FTIndicator

+ (void)setIndicatorStyleToDefaultStyle
{
    [self setIndicatorStyle:UIBlurEffectStyleLight];
}

+ (void)setIndicatorStyle:(UIBlurEffectStyle)style
{
    [FTToastIndicator setToastIndicatorStyle:style];
    [FTProgressIndicator setProgressIndicatorStyle:style];
    [FTNotificationIndicator setNotificationIndicatorStyle:style];
}

#pragma mark - FTToastIndicator
/**
 *  FTToastIndicator
 */
+ (void)showToastMessage:(NSString *)toastMessage
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [FTToastIndicator showToastMessage:toastMessage];
        [FTIndicator dismissToast];
    });

}

+ (void)dismissToast
{
    [FTToastIndicator dismiss];
}


#pragma mark - FTProgressIndicator
/**
 *  FTProgressIndicator
 */
+ (void)showProgressWithMessage:(NSString *)message
{
    [self showProgressWithMessage:message userInteractionEnable:YES];
}
+ (void)showProgressWithMessage:(NSString *)message userInteractionEnable:(BOOL)userInteractionEnable
{
    [FTProgressIndicator showProgressWithMessage:message userInteractionEnable:userInteractionEnable];
}

+ (void)dismissProgress
{
    [FTProgressIndicator dismiss];
}

#pragma mark - FTNotificationIndicator
/**
 *  FTNotificationIndicator
 */
+ (void)showNotificationWithTitle:(NSString *)title message:(NSString *)message
{
    [self showNotificationWithImage:nil title:title message:message autoDismiss:YES tapHandler:nil completion:nil];
}

+ (void)showNotificationWithTitle:(NSString *)title message:(NSString *)message tapHandler:(FTNotificationTapHandler)tapHandler
{
    [self showNotificationWithImage:nil title:title message:message autoDismiss:YES tapHandler:tapHandler completion:nil];
}

+ (void)showNotificationWithTitle:(NSString *)title message:(NSString *)message tapHandler:(FTNotificationTapHandler)tapHandler completion:(FTNotificationCompletion)completion
{
    [self showNotificationWithImage:nil title:title message:message autoDismiss:YES tapHandler:tapHandler completion:completion];
}

+ (void)showNotificationWithImage:(UIImage *)image title:(NSString *)title message:(NSString *)message
{
    [self showNotificationWithImage:image title:title message:message autoDismiss:YES tapHandler:nil completion:nil];
}

+ (void)showNotificationWithImage:(UIImage *)image title:(NSString *)title message:(NSString *)message tapHandler:(FTNotificationTapHandler)tapHandler
{
    [self showNotificationWithImage:image title:title message:message autoDismiss:YES tapHandler:tapHandler completion:nil];
}

+ (void)showNotificationWithImage:(UIImage *)image title:(NSString *)title message:(NSString *)message tapHandler:(FTNotificationTapHandler)tapHandler completion:(FTNotificationCompletion)completion
{
    [self showNotificationWithImage:image title:title message:message autoDismiss:YES tapHandler:tapHandler completion:completion];
}

+ (void)showNotificationWithImage:(UIImage *)image title:(NSString *)title message:(NSString *)message autoDismiss:(BOOL)autoDismiss tapHandler:(FTNotificationTapHandler)tapHandler completion:(FTNotificationCompletion)completion
{
    [FTNotificationIndicator showNotificationWithImage:image title:title message:message autoDismiss:autoDismiss tapHandler:tapHandler completion:completion];
}

+ (void)dismissNotification
{
    [FTNotificationIndicator dismiss];
}

@end
