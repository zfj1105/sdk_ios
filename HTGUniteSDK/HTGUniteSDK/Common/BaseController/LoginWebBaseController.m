//
//  LoginWebBaseController.m
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/25.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "LoginWebBaseController.h"
#import "WKWebViewJavascriptBridge.h"


@interface LoginWebBaseController() <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webview;

@property (nonatomic, strong) UIProgressView* progressView;
@end

@implementation LoginWebBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"用户协议";
        
    if (self.isShowBackButton) {
        [self showBackButton];
    }
    
    NSURLRequest *requet = [NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrlString relativeToURL:nil]];
    
    [self.webview loadRequest:requet];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self customNavigationControllerWithWidth:NAVIGATIONCONTROLLERHWIDTH height:300 isCenterInParent:YES originY:0];
    
}

- (void)initSubviews
{
    [super initSubviews];
    
    [self.view addSubview:self.webview];
    
    [self.view addSubview:self.progressView];
}

- (void)layoutSubviews
{
    
    WEAK_SELF(weakSelf);
    
    [super layoutSubviews];
    
    [self.webview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(2));
        make.top.equalTo(weakSelf.navigationView.mas_bottom);
        make.left.right.equalTo(weakSelf.webview);
    }];
}

- (WKWebView *)webview
{
    if (!_webview) {
        _webview = [WKWebView new];
        _webview.navigationDelegate = self;
    }
    return _webview;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        if (!IOS7)
        {
            _progressView.transform = CGAffineTransformMakeScale(1.f, 2.5f);
            
        }
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.progressTintColor = [UIColor colorWithHex:@"#54B67E"];
        _progressView.progress = 0.0f;
    }
    return _progressView;
}

- (void)back
{
    if ([self.webview canGoBack]) {
        [self.webview goBack];
        return;
    }
    [super back];
}

#pragma mark - WKNavigationDelegate  代理

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    KLLog(@"是否允许这个导航");
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    //    Decides whether to allow or cancel a navigation after its response is known.
    
    KLLog(@"知道返回内容之后，是否允许加载，允许加载");
    decisionHandler(WKNavigationResponsePolicyAllow);
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    KLLog(@"开始加载");
    
    [_progressView setProgress:.9f animated:YES];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    KLLog(@"跳转到其他的服务器");
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    KLLog(@"网页由于某些原因加载失败");
    [self cb_finishProgress];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    KLLog(@"网页开始接收网页内容");
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    KLLog(@"网页导航加载完毕");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
//    WEAK_SELF(weakSelf);
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable ss, NSError * _Nullable error) {
        KLLog(@"----document.title:%@---webView title:%@",ss,webView.title);
        
//        weakSelf.titleLabel.text = webView.title;
    }];
    
    [self cb_finishProgress];
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    KLLog(@"加载失败,失败原因:%@",[error description]);
    [self cb_finishProgress];
}
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    KLLog(@"网页加载内容进程终止");
}

#pragma mark - 自定义事件

- (void)cb_finishProgress
{
    [_progressView setProgress:1.0f animated:YES];
    
    [self performSelector:@selector(cb_clearProgress) withObject:nil afterDelay:0.8f];//延迟进度条的销毁
}

- (void)cb_clearProgress
{
    [_progressView removeFromSuperview];
}

@end
