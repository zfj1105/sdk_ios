//
//  FTProgressIndicator.h
//  FTIndicator
//
//  Created by liufengting on 16/7/26.
//  Copyright © 2016年 liufengting ( https://github.com/liufengting ). All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - FTProgressIndicatorMessageType

/**
 FTProgressIndicatorMessageType

 - FTProgressIndicatorMessageTypeInfo: FTProgressIndicatorMessageTypeInfo
 - FTProgressIndicatorMessageTypeSuccess: FTProgressIndicatorMessageTypeSuccess
 - FTProgressIndicatorMessageTypeError: FTProgressIndicatorMessageTypeError
 - FTProgressIndicatorMessageTypeProgress: FTProgressIndicatorMessageTypeProgress
 */
typedef NS_ENUM(NSUInteger, FTProgressIndicatorMessageType) {
    FTProgressIndicatorMessageTypeInfo,
    FTProgressIndicatorMessageTypeSuccess,
    FTProgressIndicatorMessageTypeError,
    FTProgressIndicatorMessageTypeProgress
};

#pragma mark - FTProgressIndicator
/**
 FTProgressIndicator
 */
@interface FTProgressIndicator : NSObject

/**
 showProgressWithMessage

 @param message message
 */
+ (void)showProgressWithMessage:(NSString *)message;

/**
 showProgressWithMessage userInteractionEnable

 @param message message
 @param userInteractionEnable userInteractionEnable
 */
+ (void)showProgressWithMessage:(NSString *)message userInteractionEnable:(BOOL)userInteractionEnable;


/**
 dismiss
 */
+ (void)dismiss;

/**
 setProgressIndicatorStyleToDefaultStyle
 */
+ (void)setProgressIndicatorStyleToDefaultStyle;

/**
 setProgressIndicatorStyle

 @param style style
 */
+ (void)setProgressIndicatorStyle:(UIBlurEffectStyle)style;

@end

#pragma mark - FTProgressIndicatorView

/**
 FTProgressIndicatorView
 */
@interface FTProgressIndicatorView : UIVisualEffectView

/**
 userInteractionEnable, if allows user touches at view
 */
@property (assign, nonatomic) BOOL userInteractionEnable;

/**
 showProgressWithType

 @param type type
 @param message message
 @param image custom image
 @param style style
 @param userInteractionEnable userInteractionEnable
 */
- (void)showProgressWithType:(FTProgressIndicatorMessageType )type message:(NSString *)message image:(UIImage *)image style:(UIBlurEffectStyle)style userInteractionEnable:(BOOL)userInteractionEnable;

/**
 getFrameForProgressViewWithMessage

 @param progressMessage progressMessage
 @return CGSize
 */
- (CGSize )getFrameForProgressViewWithMessage:(NSString *)progressMessage;

@end
