//
//  HTPanGestureButton.m
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/27.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "HTPanGestureButton.h"


/**水平方向距边界的间隔倍率*/
CGFloat kLeanProportion = 0.;
/**竖直方向距边界的间隔*/
CGFloat kVerticalMargin = 0.;
CGFloat kBorderLineW = 0.;

#define htpanbuttonwidth   40
#define htpanbuttonheigth   40

#define hiddenWidth   20




@implementation HTPanGestureButton

- (instancetype)initWithFrame:(CGRect)frame Delegate:(id<HTPanGestureButtonDelegate>)delegate;
{
    if(self = [super initWithFrame:frame])
    {
        
        self.isPanGestureButtonLeft = YES;//默认在屏幕左边
        self.delegate = delegate;
        
        self.userInteractionEnabled = YES;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
        
        pan.delaysTouchesBegan = YES;
        
        [self addGestureRecognizer:pan];
        
        [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];

    }
    return self;
}

- (void)statusBarOrientationChange:(NSNotification *)notification
{
    
    [self hiddenHTPanBugtton];
    [self showHTPanGestureButtonInView:self.superAddedView];
    
}

#pragma mark - event response
- (void)handlePanGesture:(UIPanGestureRecognizer*)p
{
    //父控件的中心点
    CGPoint panPoint = [p locationInView:self.superview];
    
    if(p.state == UIGestureRecognizerStateBegan) {
        
    }else if(p.state == UIGestureRecognizerStateChanged) {
        
        self.center = CGPointMake(panPoint.x, panPoint.y);
        
    }else if(p.state == UIGestureRecognizerStateEnded || p.state == UIGestureRecognizerStateCancelled) {
        CGFloat ballWidth = self.frame.size.width;
        CGFloat ballHeight = self.frame.size.height;
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        
        CGFloat left = fabs(panPoint.x);
        CGFloat right = fabs(screenWidth - left);
        CGFloat top = fabs(panPoint.y);
        
        CGFloat minSpace = 0;
        //横向滑动
        minSpace = MIN(left, right);
        
        CGPoint newCenter = CGPointZero;
        CGFloat targetY = 0;
        
        //Correcting Y
        if (panPoint.y < kVerticalMargin + ballHeight / 2.0) {
            targetY = kVerticalMargin + ballHeight / 2.0;
        }else if (panPoint.y > (screenHeight - ballHeight / 2.0 - kVerticalMargin)) {
            targetY = screenHeight - ballHeight / 2.0 - kVerticalMargin;
        }else{
            targetY = panPoint.y;
        }
        
        CGFloat centerXSpace = (0.5 - kLeanProportion) * ballWidth;
        CGFloat centerYSpace = (0.5 - kLeanProportion) * ballHeight;
        
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        if (minSpace == left) {
            if (IS_IPHONE_X && orientation == UIInterfaceOrientationLandscapeRight) {//始终保持在右边
                newCenter = CGPointMake(screenWidth - centerXSpace, targetY);
                self.isPanGestureButtonLeft = NO;
            }else{
                newCenter = CGPointMake(centerXSpace, targetY);
                self.isPanGestureButtonLeft = YES;
            }
        }else if (minSpace == right) {
            if (IS_IPHONE_X && orientation == UIInterfaceOrientationLandscapeLeft) {//始终保持在左边
                newCenter = CGPointMake(centerXSpace, targetY);
                self.isPanGestureButtonLeft = YES;
            }else{
                newCenter = CGPointMake(screenWidth - centerXSpace, targetY);
                self.isPanGestureButtonLeft = NO;
            }
        }else if (minSpace == top) {
            newCenter = CGPointMake(panPoint.x, centerYSpace);
        }else {
            newCenter = CGPointMake(panPoint.x, screenHeight - centerYSpace);
        }
        self.enabled = NO;
        [UIView animateWithDuration:.25 animations:^{
            self.center = newCenter;
        } completion:^(BOOL finished) {
            [self animationPanGestureButton];//收缩按钮
        }];
    }else{
        
    }
}

- (void)click
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         if (self.isPanGestureButtonLeft) {
                             CGRect rect = self.frame;
                             rect.origin.x += hiddenWidth;
                             self.frame = rect;
                         }else{
                             CGRect rect = self.frame;
                             rect.origin.x -= hiddenWidth;
                             self.frame = rect;
                         }
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    if([self.delegate respondsToSelector:@selector(htPanGestureButtonClick:)])
    {
        [self.delegate htPanGestureButtonClick:self];
    }
}


- (void)showHTPanGestureButtonInView:(UIView *)aView
{
    
    self.superAddedView = aView;
    
    if ([[RequestManager sharedManager].getLoginKeymodel.isiap isEqualToString:@"true"]) {
        //不显示用户中心
        return;
    }
    
    WEAK_SELF(weakSelf);
    
    self.enabled = NO;
    [aView addSubview:self];
    
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(aView);
        if (IS_IPHONE_X) {
            UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
            if (orientation == UIInterfaceOrientationLandscapeLeft) {
                make.left.equalTo(aView);
                self.isPanGestureButtonLeft = YES;
            }else{
                make.right.equalTo(aView);
                self.isPanGestureButtonLeft = NO;
            }
        }else{
            if (weakSelf.isPanGestureButtonLeft) {
                make.left.equalTo(aView);
            }else{
                make.right.equalTo(aView);
            }
        }
        make.size.mas_equalTo(CGSizeMake(htpanbuttonwidth, htpanbuttonheigth));
    }];
    
    [self animationPanGestureButton];
    
}

- (void)animationPanGestureButton
{
    WEAK_SELF(weakSelf);
    
    int64_t delayInSeconds = 1.0;      // 延迟的时间
    /*
     *@parameter 1,时间参照，从此刻开始计时
     *@parameter 2,延时多久，此处为秒级，还有纳秒等。10ull * NSEC_PER_MSEC
     */
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:0.2
                         animations:^{
                             if (weakSelf.isPanGestureButtonLeft) {
                                 CGRect rect = self.frame;
                                 rect.origin.x -= hiddenWidth;
                                 weakSelf.frame = rect;
                             }else{
                                 CGRect rect = self.frame;
                                 rect.origin.x += hiddenWidth;
                                 weakSelf.frame = rect;
                             }
                         }
                         completion:^(BOOL finished) {
                             self.enabled = YES;
                         }];
    });
    
    
}

- (void)hiddenHTPanBugtton
{
    [self removeFromSuperview];
}
@end
