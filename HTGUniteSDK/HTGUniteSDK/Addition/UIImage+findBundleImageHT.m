//
//  UIImage+findBundleImageHT.m
//  HTSDK
//
//  Created by zfj2602 on 17/3/27.
//  Copyright © 2017年 zfj2602. All rights reserved.
//

#import "UIImage+findBundleImageHT.h"

@implementation UIImage (findBundleImageHT)

+ (UIImage *)imagesNamedFromCustomBundle:(NSString *)imgName
{
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"HTGUniteSDK.bundle/images"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *img_path = [bundle pathForResource:imgName ofType:@"png"];
    return [[UIImage imageWithContentsOfFile:img_path]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
@end
