//
//  UserPayWebController.m
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/25.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "UserPayWebController.h"
#import "WKWebViewJavascriptBridge.h"
#import "UserWebBaseController.h"

@interface UserPayWebController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webview;

@property (nonatomic, strong) UIProgressView* progressView;

@end

@implementation UserPayWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotification];
    
    self.backButton.hidden = YES;
    
    self.scrollLabelView.hidden = NO;
    
    [self webLoadDataWithUrlString:[RequestManager sharedManager].payModel.payUrl];

}

- (void)addNotification
{
    //在web view开始加载URL，唤起微信支付之前，需要给app添加一个监听事件，判断app再次进入到前台时候的监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterForegroundAction) name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)initSubviews
{
    [super initSubviews];
    
    [self.view addSubview:self.webview];
    
    [self.view addSubview:self.progressView];
    
    [self.scrollLabelView beginScrolling];
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
    
    [self.scrollLabelView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.right.equalTo(self.navigationView);
        make.height.equalTo(@(15));
    }];
    
    [self.webview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollLabelView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
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

- (void)close:(id)sender{
    [super close:sender];
    HTPOSTNOTIFICATION(kHTGUniteSDKHTMaiFailureNotification);
}

#pragma mark - WKNavigationDelegate  代理

/**
  https://pay.heepay.com/Payment/Index.aspx?version=1&is_phone=1&agent_id=2110215&agent_bill_id=201805021413273290&agent_bill_time=20180502141327&pay_type=30&pay_amt=6.00&notify_url=http://api_dev.zfj2602.com/sdkapi.php?ac=heepay_notify&return_url=http%3A%2F%2Fapi_dev.zfj2602.com%2Fsdkapi.php%3Fac%3Dchkwxh5order%26orderid%3D201805021413273290&user_ip=49.66.133.248&is_frame=0&goods_name=18112356949%3A%B9%BA%C2%F2%B2%BB%D6%AA%C3%FB%D3%CE%CF%B7%A3%A8iOS%A3%A9%B3%E4%D6%B5%B9%BA%C2%F2%D4%AA%B1%A6&goods_num=1&remark=yyjplatformdemo&goods_note=18112356949%3A%B9%BA%C2%F2%B2%BB%D6%AA%C3%FB%D3%CE%CF%B7%A3%A8iOS%A3%A9%B3%E4%D6%B5%B9%BA%C2%F2%D4%AA%B1%A6&meta_option=eyJzIjoiV0FQIiwibiI6ImdhbWVfZGV2LmhhaXR1aWRhdGEuY29tIiwiaWQiOiJodHRwOi8vZ2FtZV9kZXYuaGFpdHVpZGF0YS5jb20ifQ%3D%3D&sign=3e96673e8c0dc217fe4eb99a8cb7700a
 **/

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    KLLog(@"是否允许这个导航");
    
    NSURL *absoluteUrl = navigationAction.request.URL;
    NSString *absoluteString = absoluteUrl.absoluteString;
    
    if([self isJumpToExternalAppWithURL:absoluteUrl]) {
        //空白地址就直接返回不执行加载
        if ([absoluteString hasPrefix:@"about:blank"]) {
            return;
        }
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:absoluteUrl
                                               options:@{}
                                     completionHandler:^(BOOL success) {
                                         
                                     }
             ];
        } else {
            [[UIApplication sharedApplication] openURL:absoluteUrl];
        }
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
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    WEAK_SELF(weakSelf);
    
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable ss, NSError * _Nullable error) {
        KLLog(@"----document.title:%@---webView title:%@",ss,webView.title);
        weakSelf.titleLabel.text = webView.title;
    }];
    
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


- (BOOL)isJumpToExternalAppWithURL:(NSURL *)URL{
    NSSet *validSchemes = [NSSet setWithArray:@[@"http", @"https"]];
    return ![validSchemes containsObject:URL.scheme];
}

#pragma makr - TXScrollLabelView 代理

- (void)scrollLabelView:(TXScrollLabelView *)scrollLabelView didClickWithText:(NSString *)text atIndex:(NSInteger)index
{
    
    if ([[RequestManager sharedManager].getLoginKeymodel.isshare isEqualToString:@"1"]) {
        UserWebBaseController *controller = [UserWebBaseController new];
        controller.isShowBackButton = YES;
        controller.requestUrlString = H5_HTG_ACTIVITY;
        controller.titleText = kTXScrollLabelViewText;
        [self pushViewController:controller];
    }else{
        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE] title:kToastTips message:kNOTOpenText];
    }

}

- (void)enterForegroundAction
{
    
    __block ModelTTPay *ttpayModel = [RequestManager sharedManager].modelTTPay;
    __block BOOL isToutiaoSDK = [RequestManager sharedManager].isToutiaoSDK;
    //发送第三方支付结果查询请求
    [[RequestManager sharedManager] ht_getchkorderWithParam:nil
                                                    success:^(NSURLResponse * _Nonnull response, id  _Nullable responseDict) {
                                                        KLLog(@"++++++++++++++++++第三方支付成功++++++++++++++");
                                                        if(isToutiaoSDK){
                                                            [TTTracker purchaseEventWithContentType:ttpayModel.contentName
                                                                                        contentName:ttpayModel.contentName
                                                                                          contentID:ttpayModel.contentName
                                                                                      contentNumber:1
                                                                                     paymentChannel:@"三方支付"
                                                                                           currency:@"CNY"
                                                                                    currency_amount:ttpayModel.currency.longLongValue
                                                                                          isSuccess:YES];
                                                        }
                                                        
                                                        HTPOSTNOTIFICATION(kHTGUniteSDKHTMaiSuccessNotification);
                                                    } failure:^(NSURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                        KLLog(@"++++++++++++++++++第三方支付失败++++++++++++++");
                                                        if(isToutiaoSDK){
                                                            [TTTracker purchaseEventWithContentType:ttpayModel.contentName
                                                                                        contentName:ttpayModel.contentName
                                                                                          contentID:ttpayModel.contentName
                                                                                      contentNumber:1
                                                                                     paymentChannel:@"三方支付"
                                                                                           currency:@"CNY"
                                                                                    currency_amount:ttpayModel.currency.longLongValue
                                                                                          isSuccess:NO];
                                                        }

                                                        HTPOSTNOTIFICATION(kHTGUniteSDKHTMaiFailureNotification);
                                                    }];
    
    [self closeWindow];
    
}

- (void)closeWindow
{
    
    //移除监听事件
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
    //关闭页面
    [self close:nil];
    
}


@end
