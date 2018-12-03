//
//  HTBaseController.h
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/26.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTBaseController : UIViewController

/**
 重置导航控制器画布frame
 
 @param aWidth   当前导航控制视图的宽
 @param aHeight  当前导航控制视图的高
 @param isCenter 在父视图中是否居中显示
 @param originY  距离父视图顶部的间距
 
 */
- (void)customNavigationControllerWithWidth:(float)aWidth
                                     height:(float)aHeight
                           isCenterInParent:(BOOL)isCenter
                                    originY:(float)originY;

- (void)orientationChange:(BOOL)landscapeRight;



@end
