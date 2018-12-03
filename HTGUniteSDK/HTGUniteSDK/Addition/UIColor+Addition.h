//
//  UIColor+Additions.h
//  JDPay4iPhone
//
//  Created by Alex on 13-8-2.
//  Copyright (c) 2013年 jd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Addition)

+ (UIColor *)colorWithHex:(NSString *)hexColor alpha:(float)alpha;
+ (UIColor *)colorWithHex:(NSString *)hexColor;
+ (UIColor *)color:(UIColor *)color_ withAlpha:(float)alpha_;

@end
