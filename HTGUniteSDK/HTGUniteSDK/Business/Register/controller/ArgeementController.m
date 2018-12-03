//
//  ArgeementController.m
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/24.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "ArgeementController.h"
#import "WKWebViewJavascriptBridge.h"

@interface ArgeementController ()

@property (nonatomic, strong) WKWebView *webview;

@end

@implementation ArgeementController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"用户协议";
    
    //显示返回按钮
    [self showBackButton];
    
    NSURLRequest *requet = [NSURLRequest requestWithURL:[NSURL URLWithString:H5_CONTACT relativeToURL:nil]];
    
    [self.webview loadRequest:requet];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self customNavigationControllerWithWidth:300 height:300 isCenterInParent:YES originY:0];
    
}


- (void)initSubviews
{
    [super initSubviews];
    
    [self.view addSubview:self.webview];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.webview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (WKWebView *)webview
{
    if (!_webview) {
        _webview = [WKWebView new];
    }
    return _webview;
}


@end
