//
//  UIImage+findBundleImageHT.h
//  HTSDK
//
//  Created by zfj2602 on 17/3/27.
//  Copyright © 2017年 zfj2602. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (findBundleImageHT)

/**
 从bundle找到图片

 @param imgName 图片名
 @return return value description
 */
+ (UIImage *)imagesNamedFromCustomBundle:(NSString *)imgName;

@end
