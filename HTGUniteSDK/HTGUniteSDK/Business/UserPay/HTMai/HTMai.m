//
//  HTMai.m
//  HTSDK
//
//  Created by zfj2602 on 17/4/8.
//  Copyright © 2017年 zfj2602. All rights reserved.
//

#import "HTMai.h"
#import "HTSSKeychain.h"
//#import "HTLogin.h"
//#import "HTRSA.h"

#import "UserInfo.h"

//沙盒测试环境验证
#define SANDBOX @"https://sandbox.itunes.apple.com/verifyReceipt"
//正式环境验证
#define Store @"https://buy.itunes.apple.com/verifyReceipt"

@implementation HTMai

+ (HTMai *)shareHTMai
{
    static HTMai *htInstrucment = nil;
    static dispatch_once_t t;
    dispatch_once(&t, ^{
        htInstrucment = [[HTMai alloc] init];
    });
    return htInstrucment;
}

#pragma mark - 开始支付
- (void)startMaiProductId:(NSString*)productId andOrderID:(NSString *)orederID{
    
    [FTIndicator dismissProgress];
    
    self.pubKey = @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDH7d/SlqaUHOBSQU6TS+V/xGNfiJIHL/szM60z2yhJwbe1DFu1aaU8wtLsvB+qe6y4rGjRKpI3B2f/4DD8UUkTfxkGmmIK4q4EjV8/TLkk6w8FODfH/ynFZR5Ac9A/NTmNTCj+nX8Np547dvO9Rs9FfrX7c03rNR/Mn4RFxPh9kQIDAQAB\n-----END PUBLIC KEY-----";
    
    
    self.ipaDelegate = self;
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [FTIndicator showProgressWithMessage:@"购买中"];
//    });
    // 添加观察者
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    self.productID = productId;
    self.orderID = orederID;
    
    
    if ([SKPaymentQueue canMakePayments]) {
        KLLog(@"进入 app store 购买流程！");
        
        [self requestProducts:productId];
    } else {
        //不允许程序内付费购买;
        SYSTEMINFO_SET_( @"YES", KisFirstInstrument);

        [self.ipaDelegate sdkStoreNotAllowMai];
        [self postMaiFialNotification];
        
        
    }
}
#pragma mark - 请求商品信息
- (void)requestProducts:(NSString*)productId {
    
    KLLog(@"---------------请求对应的产品信息---------------");
  
    NSSet *productIds = [NSSet setWithObject:productId];
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIds];
    productsRequest.delegate = self;
    [productsRequest start];
}
#pragma mark    ---     AppStore 回调 请求商品信息回调
/*
 *  收到对应的产品信息
 */

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    KLLog(@"---------------收到产品的反馈信息---------------");
//    [FTIndicator showProgressWithMessage:@"购买中"];
    NSArray *products = response.products;
    SKProduct *product = [products count] > 0 ? [products objectAtIndex:0] : nil;
    if (product) {
        // 添加付款请求到队列
        for (SKProduct *pro in products) {
            KLLog(@"%@", [pro description]);
            KLLog(@"%@", [pro localizedTitle]);
            KLLog(@"%@", [pro localizedDescription]);
            KLLog(@"%@", [pro price]);
            KLLog(@"%@", [pro productIdentifier]);
            
            if([pro.productIdentifier isEqualToString:self.productID]){
                product = pro;
            }
        }
        KLLog(@"将商品放入交易队列");
        SKPayment *maiment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:maiment];
    }
    else
    {
        SYSTEMINFO_SET_( @"YES", KisFirstInstrument);

        //无法获取商品信息
        [self.ipaDelegate sdkStoreNoProductInfo];
        KLLog(@"无法获取商品信息");
        //创建一个给客户的支付失败消息对象
        [self postMaiFialNotification];
        
        
    }
}
#pragma mark - appstore回调 付款请求回调
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction {
    for(SKPaymentTransaction *tran in transaction){

        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                //购买中
                KLLog(@"购买中");
                [self.ipaDelegate sdkStoreMaing];
                break;
            case SKPaymentTransactionStateDeferred:
                //购买中 交易被推迟
                [self.ipaDelegate sdkStoreMaing];
                break;
            case SKPaymentTransactionStateFailed:
                //购买监听 交易失败
                
                KLLog(@"购买监听 交易失败");
                [self failedTransaction:tran];
                break;
            case SKPaymentTransactionStatePurchased:
                //购买监听 交易完成
                KLLog(@"购买监听 交易完成");
                
                [self completeTransaction:tran];
                break;
            case SKPaymentTransactionStateRestored:
                //购买监听 恢复成功
                [self restoreTransaction:tran];
                
                break;
            default:
                break;
        }
    }
}

#pragma mark - 获取票据信息
- (NSData*)receiptWithTransaction:(SKPaymentTransaction*)transaction {
    NSData *receipt = nil;
    if ([[NSBundle mainBundle] respondsToSelector:@selector(appStoreReceiptURL)]) {
        NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
        receipt = [NSData dataWithContentsOfURL:receiptUrl];
    } else {
        if ([transaction respondsToSelector:@selector(transactionReceipt)]) {
            //Works in iOS3 - iOS8, deprected since iOS7, actual deprecated (returns nil) since iOS9
            //            receipt = [transaction transactionReceipt];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[[NSBundle mainBundle] appStoreReceiptURL]];
            NSError *error = nil;
            receipt = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
            
            
        }
    }
    return receipt;
}
#pragma mark    ---     验证票据

/**
 正式接服务器
 */
- (void)checkReceipt:(SKPaymentTransaction *)transaction
{
    if (!transaction) {
        [FTIndicator dismissProgress];

        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE] title:kToastTips message:@"交易信息有误"];
    }

    // 获取票据
    NSData *receipt = [self receiptWithTransaction:transaction];
    if (!receipt){
        SYSTEMINFO_SET_( @"YES", KisFirstInstrument);
        [FTIndicator dismissProgress];
        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE] title:kToastTips message:@"购买凭据不存在"];
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        [self postMaiFialNotification];
        return;
        
    }
    NSString *product = transaction.payment.productIdentifier;
    KLLog(@"--product %@",product);
    //base64编码
    NSString *encodingReceipt = [receipt base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSString *urla = [NSString stringWithFormat:@"orderid=%@&receipt=%@&transaction_id=%@",self.orderID,encodingReceipt,transaction.transactionIdentifier];
    // 将票据存到本地
    [self saveReceiptToLocal:urla];    
    
    //拼接请求数据
    NSData *bodyData = [HTRSA encryptStringToData:urla publicKey:self.pubKey];
    //创建请求到服务器进行购买验证
    NSString *st = HTDECODE(@"GAAQ");
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@?ac=apple&op=%@",KAPI_HEAD, st]];
    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
    KLLog(@"--- URL %@",requestM);
    [requestM setHTTPBody:bodyData];
    [requestM setHTTPMethod:@"POST"];
    //创建连接并发送同步请求
    NSError *error=nil;
    
     NSData *responseData = [NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&error];

    KLLog(@"responseData %@",responseData);
    
    if (!responseData) {
//            if (error) {
        //        NSLog(@"-验证票据error-- %@",error);
        [FTIndicator dismissProgress];
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE] title:kToastTips message:@"网络异常,请检查网络"];
        
        KLLog(@"交易失败");
        KLLog(@"网络异常");
        SYSTEMINFO_SET_( @"YES", KisFirstInstrument);
        
        //再请求
        [self checkUnchekReceipt];
        return;
    }
    
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
    KLLog(@"返回的 dic %@",dic);
    
    if([dic[@"status"] isEqualToString:@"sucess"]){
        SYSTEMINFO_SET_( @"YES", KisFirstInstrument);
        
        //交易验证成功，做交易成功处理
        [self.ipaDelegate sdkStoreMaiComplete:YES];
        //从队列删除订单信息
        [self removeUrlParameters:urla];
        KLLog(@"交易验证成功");
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        
        //创建一个给客户的支付成功消息对象
        [self postMaiSuccessNotification];
    }
    if ([dic[@"status"] isEqualToString:@"fail"]) {
        SYSTEMINFO_SET_( @"YES", KisFirstInstrument);
        
        //交易验证失败，做交易失败处理
        [self.ipaDelegate sdkStoreMaiComplete:NO];
        //从队列删除订单信息
        [self removeUrlParameters:urla];
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        
        //创建一个给客户的支付失败消息对象
        [self postMaiFialNotification];
        KLLog(@"交易验证失败");
        
    }
}
/**
 沙盒测试
 */
- (void)checkTextReceipt:(SKPaymentTransaction *)transaction
{
    if (!transaction) {
    }
    // 获取票据
    NSData *receipt = [self receiptWithTransaction:transaction];
    if (!receipt){
        
        
    }
    NSString *product = transaction.payment.productIdentifier;
    KLLog(@"----proudct ID %@",product);
    //base64编码
    NSString *encodingReceipt = [receipt base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    //获取url参数
    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodingReceipt];
    
    
    // 将票据存到本地
    [self saveReceiptToLocal:bodyString];
    
    //拼接请求数据
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    //创建请求到苹果官方进行购买验证
    NSURL *url=[NSURL URLWithString:SANDBOX];
    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
    requestM.HTTPBody=bodyData;
    requestM.HTTPMethod=@"POST";
    //创建连接并发送同步请求
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&error];

    if (error) {
        //再请求
        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE] title:kToastTips message:@"网络异常,请检查网络"];

        KLLog(@"交易失败");
        KLLog(@"网络异常");
        [self checkUnchekReceipt];
        
        return;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    KLLog(@"%@",dic);
    if([dic[@"status"] isEqualToString:@"sucess"]){
        //交易验证成功，做交易成功处理
        
        [self.ipaDelegate sdkStoreMaiComplete:YES];
        //从队列删除订单信息
        [self removeUrlParameters:bodyString];
        KLLog(@"交易验证成功");
    }
    if ([dic[@"status"] isEqualToString:@"fail"]) {
        //交易验证失败，做交易失败处理
        [self.ipaDelegate sdkStoreMaiComplete:NO];
        //从队列删除订单信息
        [self removeUrlParameters:bodyString];
        KLLog(@"交易验证失败");
        
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE] title:kToastTips message:@"购买失败"];
        });

        
    }
    
}
#pragma mark    ---     存储票据到本地
- (void)saveReceiptToLocal:(NSString *)urlPara
{
    //获取当前应用沙盒的根目录
    NSString *homePath = NSHomeDirectory();
    //拼接路径
    NSString *docPath = [homePath stringByAppendingPathComponent:@"Documents"];
    
    //还要指定存储文件的文件名称,仍然使用字符串拼接
    NSString *filePath = [docPath stringByAppendingPathComponent:@"CYReceipt.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath])
    {
        NSMutableArray *plistArray = [NSMutableArray arrayWithContentsOfFile:filePath];
        
        // 判断数组里是否有name 这个字符串
        if ([plistArray containsObject:urlPara])
        {
            [plistArray removeObject:urlPara];
            [plistArray insertObject:urlPara atIndex:0];
            [plistArray writeToFile:filePath atomically:YES];
        }
        else
        {
            [plistArray insertObject:urlPara atIndex:0];
            [plistArray writeToFile:filePath atomically:YES];
        }
    }
    else
    {
        //新建一个数组
        NSMutableArray *array = [NSMutableArray arrayWithObjects:urlPara, nil];
        //将数组存储到文件中
        [array writeToFile:filePath atomically:YES];
    }
    
}
#pragma mark - 验证遗漏的票据
- (void)checkUnchekReceipt {
    //取出票据
    NSArray *urlParas = [self loadUrlParameters];
    if ((!urlParas) || (urlParas.count == 0)) {
        return;
    }
    for (NSString *urlPara in urlParas) {
        [self connectServerForUncheckReceipt:urlPara];
    }
}

#pragma mark    ---     取出遗漏的票据
- (NSArray *)loadUrlParameters
{
    //获取当前应用沙盒的根目录
    NSString *homePath = NSHomeDirectory();
    //拼接路径
    NSString *docPath = [homePath stringByAppendingPathComponent:@"Documents"];
    //还要指定存储文件的文件名称,仍然使用字符串拼接
    NSString *filePath = [docPath stringByAppendingPathComponent:@"CYReceipt.plist"];
    NSMutableArray *array= [NSMutableArray arrayWithContentsOfFile:filePath];
    KLLog(@"遗漏票据 的数组  %lu",(unsigned long)array.count);
    return array;
}

// 验证漏单的票据
- (void)connectServerForUncheckReceipt:(NSString*)urlPara {
    
    KLLog(@"--验证漏单的票据");
    NSData *bodyData = [HTRSA encryptStringToData:urlPara publicKey:self.pubKey];
    NSString *st1 = HTDECODE(@"GAAQ");
    //创建请求到苹果官方进行购买验证
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@?ac=apple&op=%@",KAPI_HEAD, st1]];
    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
    requestM.HTTPBody=bodyData;
    requestM.HTTPMethod=@"POST";
 
    NSOperationQueue *queue = [NSOperationQueue new];
    [NSURLConnection sendAsynchronousRequest:requestM queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            //再请求
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 30 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self connectServerForUncheckReceipt:urlPara];
            });
            KLLog(@"遗漏订单验证网络异常");
            return ;
        }
        if (response) {
            //从队列删除订单信息
            [self removeUrlParameters:urlPara];
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            KLLog(@"遗漏订单验证 return parameters %@",dic);
            
            if([dic[@"status"] isEqualToString:@"sucess"]){
                
                KLLog(@"遗漏订单交易验证成功");
                //创建一个给客户的支付成功消息对象
                [self postMaiSuccessNotification];
            }
            if ([dic[@"status"] isEqualToString:@"fail"]) {
                //创建一个给客户的支付失败消息对象
                [self postMaiFialNotification];
                KLLog(@"遗漏订单交易验证失败");
            }
        }
    }];
    
    
}


#pragma mark    ---     从队列中删除订单信息
- (void)removeUrlParameters:(NSString *)urlParas
{
    KLLog(@"从队列中删除订单信息");
    //获取当前应用沙盒的根目录
    NSString *homePath = NSHomeDirectory();
    //拼接路径
    NSString *docPath = [homePath stringByAppendingPathComponent:@"Documents"];
    //还要指定存储文件的文件名称,仍然使用字符串拼接
    NSString *filePath = [docPath stringByAppendingPathComponent:@"CYReceipt.plist"];
    NSMutableArray *plistArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    // 判断数组里是否有name 这个字符串
    [plistArray removeObject:urlParas];
    [plistArray writeToFile:filePath atomically:YES];
    
    
    
}
#pragma mark - 交易事务处理
// 交易成功
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    // 正式服务器测试
    [self checkReceipt:transaction];
    // 沙盒测试
    //    [self checkTextReceipt:transaction];
    [self finishTransaction:transaction wasSuccessful:YES];
}
// 交易失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE] title:kToastTips message:@"购买失败"];
    });

    KLLog(@"交易失败");
    KLLog(@"error %@",transaction.error);
   
    KLLog(@"error description %@", [transaction.error description]);
    
    SYSTEMINFO_SET_(@"YES", KisFirstInstrument);
    //创建一个给客户的支付失败消息对象
    [self postMaiFialNotification];
    
    [self finishTransaction:transaction wasSuccessful:NO];
}
// 交易恢复
- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    [self finishTransaction:transaction wasSuccessful:YES];
}
//结束交易事务
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful {
    [FTIndicator dismissProgress];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

#pragma mark    ---     iap处理过程中代理协议方法(自写)
/**
 不允许程序内付费购买
 */
- (void)sdkStoreNotAllowMai
{
    [FTIndicator dismissProgress];
    [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE] title:kToastTips message:@"未允许程序内购买"];

    
}


/**
 无法获取商品信息
 */
- (void)sdkStoreNoProductInfo
{
    [FTIndicator dismissProgress];
    [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE] title:kToastTips message:@"无法获取商品信息"];

    
}


/**
 购买商品中
 */
- (void)sdkStoreMaing
{
//    [FTIndicator showProgressWithMessage:@"购买中"];
    
}

/**
 交易是否失败
 */
- (void)sdkStoreMaiComplete:(BOOL)isComplete
{
    KLLog(@"交易是否失败");
    [FTIndicator dismissProgress];
    if (isComplete){
        // 交易成功

        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [FTIndicator showNotificationWithImage:[UIImage imagesNamedFromCustomBundle:SUSPENSIONBUTTONIMAGE] title:kToastTips message:@"购买成功"];
            KLLog(@"交易成功");
        });

        
        
        
    }
    
    
}

#pragma mark - 添加交易队列观察者
- (void)addStoreObserver {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

// MD5 加密
- (NSString *)stringToMD5:(NSString *)str
{
    
    //1.首先将字符串转换成UTF-8编码, 因为MD5加密是基于C语言的,所以要先把字符串转化成C语言的字符串
    const char *fooData = [str UTF8String];
    
    //2.然后创建一个字符串数组,接收MD5的值
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    //3.计算MD5的值, 这是官方封装好的加密方法:把我们输入的字符串转换成16进制的32位数,然后存储到result中
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);
    /**
     第一个参数:要加密的字符串
     第二个参数: 获取要加密字符串的长度
     第三个参数: 接收结果的数组
     */
    
    //4.创建一个字符串保存加密结果
    NSMutableString *saveResult = [NSMutableString string];
    
    //5.从result 数组中获取加密结果并放到 saveResult中
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02x", result[i]];
    }
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     KLLog("%02X", 0x888);  //888
     KLLog("%02X", 0x4); //04
     */
    return saveResult;
}

#pragma mark    ---     支付回调通知
- (void)postMaiFialNotification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //头条SDK支付
        ModelTTPay *ttpayModel = [RequestManager sharedManager].modelTTPay;
        BOOL isToutiaoSDK = [RequestManager sharedManager].isToutiaoSDK;
        
        if (isToutiaoSDK) {
            [TTTracker purchaseEventWithContentType:ttpayModel.contentName
                                        contentName:ttpayModel.contentName
                                          contentID:ttpayModel.contentName
                                      contentNumber:1
                                     paymentChannel:@"苹果内购"
                                           currency:@"CNY"
                                    currency_amount:ttpayModel.currency.longLongValue
                                          isSuccess:NO];
        }

        HTPOSTNOTIFICATION(kHTGUniteSDKHTMaiFailureNotification);
    });
}

- (void)postMaiSuccessNotification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        ModelLogin *loginModel = [RequestManager sharedManager].loginModel;
        UserInfo *user = [[DBManager sharedDBManager] queryDataUserIapCountWithUserName:loginModel.username];        
        //查询用户已经在内购档购内购的本地缓存
        NSString *userIapCount = user.iapCount;
        //更新本地数据库内购次数
        UserInfo *updateUser = [UserInfo new];
        updateUser.iapCount = [NSString stringWithFormat:@"%ld", (userIapCount.integerValue+1)];
        updateUser.username = user.username;
        [[DBManager sharedDBManager] updateIapCountWithUserInfo:updateUser];
        
        
        //头条SDK支付
        ModelTTPay *ttpayModel = [RequestManager sharedManager].modelTTPay;
        BOOL isToutiaoSDK = [RequestManager sharedManager].isToutiaoSDK;

        if (isToutiaoSDK) {
            [TTTracker purchaseEventWithContentType:ttpayModel.contentName
                                        contentName:ttpayModel.contentName
                                          contentID:ttpayModel.contentName
                                      contentNumber:1
                                     paymentChannel:@"苹果内购"
                                           currency:@"CNY"
                                    currency_amount:ttpayModel.currency.longLongValue
                                          isSuccess:YES];
        }

        
        HTPOSTNOTIFICATION(kHTGUniteSDKHTMaiSuccessNotification);
    });
}


- (void)dealloc
{
    [[SKPaymentQueue defaultQueue]removeTransactionObserver:self];
}

@end
