//
//  HTGUniteSDK.h


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kHTGUniteSDKInitDidFinishedNotification    @"kHTGUniteSDKInitDidFinishedNotification"  //初始化成功
#define kHTGUniteSDKInitFinishedFailNotification   @"kHTGUniteSDKInitFinishedFailNotification"  //初始化失败
#define kHTGUniteSDKLogoutNotification             @"kHTGUniteSDKLogoutNotification"  //注销
#define kHTGUniteSDKLoginNotification              @"kHTGUniteSDKLoginNotification"  //登录
#define kHTGUniteSDKHTMaiSuccessNotification       @"kHTGUniteSDKHTMaiSuccessNotification"  //支付成功
#define kHTGUniteSDKHTMaiFailureNotification       @"kHTGUniteSDKHTMaiFailureNotification"  //支付失败

@interface HTGUniteSDK : NSObject

/**
 *   @brief 获取HTGUniteSDK实例
 */
+ (HTGUniteSDK *)sharedInstance;

/**
 *  @brief  平台初始化方法
 *
 *  @param  appId 游戏在接入联运分配的appId
 *  @param  showLoginAfterLogout 游戏在执行注销操作之后
 ‘1’SDK 里面在注销之后自动显示登录界面  ‘0’不显示 由CP 接入方自己决定在收到 通知名为 kHTGUniteSDKLogoutNotification 的回调之后
 是否调用- (void)HTGUniteLogin  函数显示登录界面
 *  @param  GAKey 游戏在接入联运分配的GAKey
 *  @param  ADKEY 游戏在接入联运分配的ADKEY
 *  @param  DEKEY 游戏在接入联运分配的DEKEY
 *  @param  TTAppID 游戏在接入头条SDK申请分配的TTAppID
 *  @param  TTChannel 游戏在接入头条SDK的渠道名称，建议正式版App Store 内测版local_test 灰度版用发布的渠道名，如pp
 *  @param  TTAppName 游戏在接入头条SDK申请分配的TTAppName
 *  @param  isToutiaoSDK     是否接入头条SDK  yes 开启，no 关闭 ；这个值为no时，TTAppID、TTChannel、TTAppName 传 @“” 即可
 *  @param  showLog     是否开启Log输出    YES 开启; NO 关闭.  默认关闭
 */
- (void)initWithAppId:(NSString *)appId
 showLoginAfterLogout:(NSString *)showLoginAfterLogout
                GAKey:(NSString *)GAKey
                ADKEY:(NSString *)ADKEY
                DEKEY:(NSString *)DEKEY
              TTAppID:(NSString *)TTAppID
            TTChannel:(NSString *)TTChannel
            TTAppName:(NSString *)TTAppName
         isToutiaoSDK:(BOOL)isToutiaoSDK
              showLog:(BOOL)showLog;
/**
 *  @brief HTGUniteSDK 登录界面入口
 *
 */
- (void)HTGUniteLogin;

/**
 *  @brief HTGUniteSDK 用户界面入口
 *
 */
- (void)HTGUniteUserCenter;

/**
 *  @brief HTGUniteSDK 注销, 即退出登录
 *
 */
- (void)HTGUniteLogout;

/**
 *  @brief 获取本次登录的token,token即sessionid
 */
- (NSString*)HTGUniteToken;

/**
 *  @brief 获取登录的openuid, 用于标记一个用户
 */
- (NSString*)HTGUniteUID;

/**
 *  @brief 当前登录用户名
 */
- (NSString *)HTGUniteUserName;

/**
    @brief 效果点事件提交接口
    @param pointId 自定义事件 *必须字段 且 pointId > 100
    @param eventDic 自定义事件内容 请按照{key:value, key:value...} 格式上传
 */
- (void) submitEvent:(NSString *)pointId
            eventDic:(NSDictionary *)eventDic;

/**
 角色提交
 提交的时机为: 每次登录 或者每次退出 或者是 角色等级升级的时候 三个时段都调用那是最好的 . 至少满足角色等级升级的时候调用
 @param serverid 服务器编号
 @param serverName 服务器名称
 @param roleid 角色ID
 @param rolename 角色名称
 @param rolelevel 角色等级
 @param roletime 角色创建时间 秒时间戳
 @param success 'YES'成功
 @param failure 'NO'失败

 */

- (void)submitRoleInfoWithServerid:(NSString *)serverid
                        serverName:(NSString *)serverName
                            roleid:(NSString *)roleid
                          roleName:(NSString *)rolename
                         rolelevel:(NSString *)rolelevel
                          roleTime:(NSString *)roletime
                           success:(void(^)(NSURLResponse * _Nonnull response, id _Nullable responseDict))success
                           failure:(void(^)(NSURLResponse * _Nullable response, NSError * _Nonnull error))failure;

/**
 支付接口 该接口首先获取支付渠道，然后支付并进入web支付页面
 @param CharId 角色ID
 @param serverId 服务器ID
 @param cporderid 游戏商订单ID
 @param productname 商品名
 @param paymentid 内购ID
 @param money 商品金额
 @param callbackInfo 不是必要参数 默认为：callBack
 */
- (void)HTGSDKServiceWithCharId:(NSString *)CharId
                       serverId:(NSString *)serverId
                      cporderid:(NSString *)cporderid
                    productname:(NSString *)productname
                      paymentid:(NSString *)paymentid
                          money:(NSString *)money
                   callbackInfo:(NSString *)callbackInfo;


- (void)showLogin;
- (void)showUsercenter;
- (void)showUserpay;
- (void)showAnnouncement;


@end

