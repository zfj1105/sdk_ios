//
//  AnnouncementWebController.m
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/25.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "AnnouncementWebController.h"
#import "WKWebViewJavascriptBridge.h"
#import "UserWebBaseController.h"
#import "HTPangestureButtonManager.h"

@interface AnnouncementWebController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webview;

@property (nonatomic, strong) UIProgressView* progressView;

@property (nonatomic, strong) UIView* bottomView;

@property (nonatomic, strong) UIButton* iKnowButton;



@end

@implementation AnnouncementWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backButton.hidden = YES;
    
    self.titleLabel.text = @"公告";
    
    [self webLoadDataWithUrlString:[RequestManager sharedManager].getLoginKeymodel.gonggaourl];

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
    
    [self.view addSubview:self.bottomView];
    
    [self.bottomView addSubview:self.iKnowButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    WEAK_SELF(weakSelf);
    
    
    [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(2));
        make.top.equalTo(weakSelf.navigationView.mas_bottom);
        make.left.right.equalTo(weakSelf.webview);
    }];
    
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(weakSelf.view);
        make.height.equalTo(@(50));
    }];
    
    [self.iKnowButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bottomView);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    [self.webview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.navigationView.mas_bottom);
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];


}

- (void)close:(id)sender
{
    //发送登录成功通知给CP
    HTPOSTNOTIFICATION(kHTGUniteSDKLoginNotification);  //登录成功
    
    //更新本地日期、本地数据库用户已经内购的次数
    [[DBManager sharedDBManager] updateLocalDateAndUserIapCount];

    ModelLogin *loginModel = [RequestManager sharedManager].loginModel;
    //TODO:第三方数据统计接口调用GA\TD\DA
    NSString *account = loginModel.uid;
    NSString *accountName = loginModel.username;
    if (IS_EXIST_STR([RequestManager sharedManager].payModel.ad_appid)) {
        [DCTrackingPoint login:account];
    }
    if (IS_EXIST_STR([RequestManager sharedManager].payModel.ga_appid)) {
        TDGAAccount *tdAccount = [TDGAAccount setAccount:account];
        [tdAccount setAccountName:accountName];
        [tdAccount setAccountType:kAccountRegistered];
    }
    if (IS_EXIST_STR([RequestManager sharedManager].payModel.de_appid)) {
        [TalkingDataAppCpa onLogin:account];
    }

    [[HTPangestureButtonManager sharedManager] showHTPanGestureButtonInKeyWindow];
    
    [[LoginWindow sharedInstance] dismiss];
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
    if ([redicturlString containsString:@"itunes.apple.com"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
        __block  NSString *appstoreUrl = redicturlString;
        
        NSURL *urlString = [NSURL URLWithString:appstoreUrl];
        
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:urlString
                                               options:@{}
                                     completionHandler:^(BOOL success) {
                                         
                                     }];
        } else {
            // Fallback on earlier versions
        }
    }else if([redicturlString containsString:@".apk"]){
        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE] title:kToastTips message:@"该手机暂不支持安卓版本下载"];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
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
        
    //结束加载控件
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


- (void)webLoadDataWithUrlString:(NSString *)urlString
{
    NSURLRequest *requet = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString relativeToURL:nil]];
    
    [self.webview loadRequest:requet];

}

#pragma mark - 懒加载

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    }
    return _bottomView;
}

- (UIView *)iKnowButton
{
    if (!_iKnowButton) {
        _iKnowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _iKnowButton.backgroundColor = kQuickLoginNormalTextColor;
        
        [_iKnowButton setTitle:@"知道了!" forState:UIControlStateNormal];
        
        [_iKnowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _iKnowButton.layer.cornerRadius = 4;
        
        _iKnowButton.titleLabel.font = KSYSTEM_FONT_(15);
        
        _iKnowButton.hidden = NO;
        
        [_iKnowButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _iKnowButton;
}

@end
