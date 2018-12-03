//
//  LoginWindow.m
//  HTGUniteSDK
//
//  Created by zfj2602 on 2018/4/5.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "LoginWindow.h"
#import "QuickLoginViewController.h"
#import "Masonry.h"
#import "UserhomeController.h"
#import "HTPangestureButtonManager.h"

@interface LoginWindow()

@end

@implementation LoginWindow

+ (instancetype)sharedInstance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.keyWindow = [UIApplication sharedApplication].keyWindow;
        
        if (self.keyWindow) {
            [self.keyWindow makeKeyWindow];
        }
                
    }
    return self;
}

- (void) show{
    self.mainWindow.hidden = NO;
    [self.mainWindow makeKeyAndVisible];
}

- (void) dismiss{
    self.mainWindow.hidden = YES;
    [self.mainWindow resignKeyWindow];
    [self.keyWindow makeKeyAndVisible];
}

- (void) showWithViewCOntroller{
    self.mainWindow.hidden = NO;
}

#pragma mark - 懒加载

- (UIWindow *)mainWindow
{
    if (!_mainWindow) {
        
        _mainWindow = [UIWindow new];
        
        _mainWindow.frame = [UIScreen mainScreen].bounds;
        
        _mainWindow.windowLevel = CGFLOAT_MAX;
        
        _mainWindow.backgroundColor = [UIColor clearColor];
        
        [_mainWindow addSubview:self.windowButton];
        
        
        CGRect frame = CGRectMake(_mainWindow.frame.origin.x, _mainWindow.frame.origin.y, _mainWindow.frame.size.width*3, _mainWindow.frame.size.height*3);
        [self.windowButton setFrame:frame];
        
    }
    return _mainWindow;
}

- (UIButton *)windowButton
{
    if (!_windowButton) {
        _windowButton = [UIButton new];
        
        _windowButton.backgroundColor = [UIColor clearColor];
        
        [_windowButton addTarget:self action:@selector(viewTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        _windowButton.enabled = NO;
        
    }
    return _windowButton;
}

-(void)viewTapped:(id)sender
{
    
    [self.mainWindow endEditing:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchWindow)]) {
        [self.delegate touchWindow];
    }
}


@end
