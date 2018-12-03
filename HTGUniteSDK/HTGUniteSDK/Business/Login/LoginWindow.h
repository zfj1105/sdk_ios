//
//  LoginWindow.h
//  HTGUniteSDK
//
//  Created by zfj2602 on 2018/4/5.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LoginWindowDelegate <NSObject>

- (void)touchWindow;

@end

@interface LoginWindow : NSObject

@property (nonatomic, assign) id<LoginWindowDelegate> delegate;

@property (nonatomic, strong) UIButton *windowButton;


+ (instancetype) sharedInstance;
- (void) show;
- (void) dismiss;

@property (nonatomic, strong) UIWindow *keyWindow;

@property (nonatomic, strong) UIWindow *mainWindow;


@end
