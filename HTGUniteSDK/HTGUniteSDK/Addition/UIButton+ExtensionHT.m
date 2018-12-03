//
//  UIButton+ExtensionHT.m
//  HTSDK
//
//  Created by zfj2602 on 17/3/27.
//  Copyright © 2017年 zfj2602. All rights reserved.
//

#import "UIButton+ExtensionHT.h"
#import "UIImage+findBundleImageHT.h"
static const CGFloat cornerRadius = 4;

@implementation UIButton (ExtensionHT)
-(void)startTime:(NSInteger )timeout title:(NSString *)tittle waitTittle:(NSString *)waitTittle
{
    UIColor *oldColor = self.backgroundColor;
    __block NSInteger timeOut = timeout - 1; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeOut<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.backgroundColor = oldColor;
                [self setTitle:tittle forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeOut % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self setTitle:[NSString stringWithFormat:@"%@(%@)",waitTittle,strTime] forState:UIControlStateNormal];
                self.backgroundColor = [UIColor lightGrayColor];
                self.userInteractionEnabled = NO;
                
            });
            timeOut--;
            
        }
    });
    dispatch_resume(_timer);
    
    
}

- (void)setCornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)setNormalImage:(NSString *)imageName andHightImage:(NSString *)hightName
{
    [self setImage:[UIImage imagesNamedFromCustomBundle:imageName] forState:UIControlStateNormal];
    [self setImage:[UIImage imagesNamedFromCustomBundle:hightName] forState:UIControlStateHighlighted];
}
@end
