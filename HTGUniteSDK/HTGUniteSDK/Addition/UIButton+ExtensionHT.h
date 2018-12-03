//
//  UIButton+ExtensionHT.h
//  HTSDK
//
//  Created by zfj2602 on 17/3/27.
//  Copyright © 2017年 zfj2602. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ExtensionHT)
/**
 倒计时
 
 @param timeout 倒计时时间
 @param tittle 倒计时前的title
 @param waitTittle 倒计时后的title
 */
-(void)startTime:(NSInteger )timeout title:(NSString *)tittle waitTittle:(NSString *)waitTittle;


/**
 设置button的圆角
 */
- (void)setCornerRadius;


/**
 设置点击的图片

 @param imageName 普通状态下
 @param hightName 高亮状态下
 */
- (void)setNormalImage:(NSString *)imageName andHightImage:(NSString *)hightName;
@end
