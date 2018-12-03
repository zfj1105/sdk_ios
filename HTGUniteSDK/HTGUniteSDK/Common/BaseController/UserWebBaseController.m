//
//  UserWebBaseController.m
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/25.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "UserWebBaseController.h"
#import "WKWebViewJavascriptBridge.h"
#import "ModelShare.h"

@interface UserWebBaseController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webview;

@property (nonatomic, strong) UIProgressView* progressView;

@end

@implementation UserWebBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isShowBackButton) {
        //显示返回按钮
        [self showBackButton];
        
        [self editBackImg:@"\U0000e63b"];
    }
    
    NSURLRequest *requet = [NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrlString relativeToURL:nil]];
    
    [self.webview loadRequest:requet];
}

- (void)initSubviews
{
    [super initSubviews];
    
    [self.view addSubview:self.webview];
    
    [self.view addSubview:self.progressView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    WEAK_SELF(weakSelf);
    
    [self.webview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.navigationView.mas_bottom);
        make.left.right.bottom.equalTo(weakSelf.view);
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
    
   NSString *redicturlString = navigationAction.request.URL.absoluteString;
    
    //佣金分享
    if ([redicturlString containsString:kUserCenterShareBtnClick]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        [self actionShareRequest];
        return;
    }
    
    //佣金提现
    if ([redicturlString containsString:kUserCenterCommision]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        [self skipAppWithURL:redicturlString];
        return;
    }

    
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
    
    WEAK_SELF(weakSelf);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable ss, NSError * _Nullable error) {
        KLLog(@"----document.title:%@---webView title:%@",ss,webView.title);
        
        weakSelf.titleLabel.text = webView.title;
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

- (void)actionShareRequest
{
    WEAK_SELF(weakSelf);
    [[RequestManager sharedManager] ht_getgetshareinfoWithParam:nil
                                                        success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [weakSelf actionShare];
                                                            });
                                                        }
                                                        failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                            
                                                        }];
}

- (void)actionShare
{
    ModelShare *shareModel = [RequestManager sharedManager].shareModel;
    NSString *textToShare = shareModel.intro == nil ? @"" :shareModel.intro;
    UIImage *imageToShare = [HTUtil getAppIcon];
    NSString *urlToString =shareModel.url == nil ? @"" :shareModel.url;
    NSURL *urlToShare = [NSURL URLWithString:urlToString];
    
    // 分享的图片不能为空
    NSArray *activityItems = nil;
    if (imageToShare == nil) {
        activityItems = @[textToShare, urlToShare];
    }else{
        activityItems = @[textToShare, imageToShare, urlToShare];
    }
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    
    // 排除（UIActivityTypeAirDrop）AirDrop 共享、(UIActivityTypePostToFacebook)Facebook
    activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypeAirDrop];
    [self presentViewController:activityVC animated:YES completion:nil];
    
    // 通过block接收结果处理
    UIActivityViewControllerCompletionWithItemsHandler completionHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        if (completed) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE]
                                                 title:kToastTips
                                               message:@"恭喜你，分享成功！"
                 ];
            });
            KLLog(@"恭喜你，分享成功！");
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE]
                                                 title:kToastTips
                                               message:@"很遗憾，分享失败！"
                 ];
            });
            KLLog(@"很遗憾，分享失败！");
        }
    };
    activityVC.completionWithItemsHandler = completionHandler;
}

- (void)skipAppWithURL:(NSString *)url {
   NSURL *appstoreUrl = [NSURL URLWithString:url];
    
    NSURL *appUrl = [NSURL URLWithString:HTGCPSSCHEME];
    
    if ([[UIApplication sharedApplication] canOpenURL:appUrl]) {//安装了App直接打开app
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:appUrl
                                               options:@{}
                                     completionHandler:^(BOOL success) {
                                         
                                     }];
        } else {
            // Fallback on earlier versions
        }
    }else{//没有安装应用跳转App Store对应的App页面
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:appstoreUrl
                                               options:@{}
                                     completionHandler:^(BOOL success) {
                                         
                                     }];
        } else {
            // Fallback on earlier versions
        }
    }
    
}

@end
