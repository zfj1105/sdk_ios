//
//  RequestConstDefine.h
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/18.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#ifndef RequestConstDefine_h
#define RequestConstDefine_h



//生产地址
#define KAPI_HEAD                             @"https://api.zfj2602.com/sdkapi.php"
#define KAPI_STATISTICS                       @"https://sdk.zfj2602.com/api/htapi.php"

//测试地址
//#define KAPI_HEAD                             @"http://api_dev.zfj2602.com/sdkapi.php"
//#define KAPI_STATISTICS                       @"http://sdk_dev.zfj2602.com/api/htapi.php"



#define APPID_KEY                             @"productId"

#define HTSDKUSERNAME                         @"username"

#define HTSDKPASSWORD                         @"password"

#define HTSDKBDINDTYPE                        @"bindtype"

#define HTSDKTYPE                             @"type"

#define HTSDKPHONE                            @"phone"

#define HTSDKSESSIONID                        @"sessionid"

#define HTSDKPHONECODE                        @"code"

//统计事件key
#define HTSDKEVENTTYPE                        @"eventType"

#define HTSDKUID                              @"uid"
#define HTSDKPRODUCTNAME                      @"productName"
#define HTSDKAMOUNT                           @"amount"
#define HTSDKCHARID                           @"charId"
#define HTSDKORDERID                          @"orderId"
#define HTSDKADVERTISINGID                    @"advertisingId"
#define HTSDKDYNAMICCHANNELNAME               @"dynamicChannelName"
#define HTSDKDCPCHANNELNAME                   @"cpChannelName"


/**
 *  接口标识
 */

#define HTPARAMKEY                    @"params"
#define HTAC                          @"ac"

#define HTAC_GETLOGINKEY              @"htg_getloginkey"                                        //!< 初始化接口 通用

#define HTAC_QUICKLOGIN               @"htg_quicklogin"                                          //!< 快速登录

#define HTAC_LOGIN                    @"htg_login"                                                    //!< 用户登录

#define HTAC_TOURISTLOGIN             @"htg_touristlogin"                                      //!< 游客登录--实为游客账号申请--配合登录

#define HTAC_CHECKCODE                @"htg_checkcode"                                            //!< 短信验证码登录 发送验证码
#define HTAC_CHECKCODE                @"htg_checkcode"                                            //!< 重置密码(已绑定 机号)、忘记密码-发送验证码
#define HTAC_CHECKCODE                @"htg_checkcode"                                            //!< 手机号注册发送验证码
#define HTAC_CHECKCODE                @"htg_checkcode"                                            //!< 手机号绑定-发送验证码
#define HTAC_CHECKCODE                @"htg_checkcode"                                            //!< 手机号解绑 发送验证码

#define HTAC_PHONELOGIN               @"htg_phonelogin"                                          //!< 短信验证码登录 登录

#define HTAC_USERNAMEREGISTER         @"htg_reg"                                           //!< 用户名注册

#define HTAC_RESET                    @"htg_reset"                                                    //!< 重置密码(已绑定 机号账号)

#define HTAC_PHONEREG                 @"htg_phonereg"                                              //!< 手机号注册

#define HTAC_IDCARD                   @"htg_idcard"                                                  //!< 实名认证
#define HTAC_IDCARD                   @"htg_idcard"                                                  //!< 重新实名认证

#define HTAC_LOGOUT                   @"htg_logout"                                                  //!< 退出登录

#define HTAC_BINDACCOUNT              @"htg_bindaccount"                                        //!< 手机号绑定
#define HTAC_BINDACCOUNT              @"htg_bindaccount"                                         //!< 手机号解绑

#define HTAC_CHANGEPASSWORD           @"htg_changepassword"                                   //!< 修改密码

#define HTAC_GETUSERINFO              @"htg_getuserinfo"                                         //!< 获取用户身份认证信息

#define HTAC_ROLEINFO                 @"htg_roleinfo"                                         //!< 角色提交

#define HTAC_getshareinfo             @"htg_getshareinfo"                                         //!< 佣金分享

#define HTAC_PAY                      @"htg_pay"                                         //!< 支付URL拼接

#define HTAC_CHKORDER                 @"htg_chkorder"                                         //!< 支付查询

#define HTAC_getcommissioninfo        @"htg_getcommissioninfo"                                         //!< 佣金结算


/***H5页面地址*****/

//游戏礼包
#define H5_PACK             @"http://api.zfj2602.com/sdkapi.php?ac=pack&appid=1&sessionid=bde9IX0+giGMyJg1qx8l1DGRpQs3wmPf3RfGkWnvVgX4sR7LqOJdwVkDxgQ1LuXFRg7H0ftx8jfNTyJTA+U7F1o"

//游戏社区
#define H5_BARURL           @"http://api.zfj2602.com/sdkapi.php?ac=barurl&appid=1"

//充值查询
#define H5_PAYLOG           @"http://api.zfj2602.com/sdkapi.php?ac=paylog&appid=1&sessionid=f9f7+sX6Q1KW7mLVusxCdVwJvTU90A2dZRjyN0oxnXHRU3jBJAF8krJLFBFvPyHdD9O1czHSOSxNfC7DLdS9XTM"

//更多游戏
#define H5_MOREAPP          @"https://api.zfj2602.com/sdkapi.php?ac=moreapp&sessionid=%@"

//协议
#define H5_CONTACT          @"https://api.zfj2602.com/sdkapi.php?ac=contact&op=agreement"

//佣金活动
#define H5_HTG_ACTIVITY     [NSString stringWithFormat:@"%@%@",KAPI_HEAD,@"?ac=htg_activity"]

//客服
#define H5_HTG_FAQ          [NSString stringWithFormat:@"%@%@",KAPI_HEAD,@"?ac=htg_faq"]


//佣金提现
#define H5_HTG_WITHDRAW     [NSString stringWithFormat:@"%@%@",KAPI_HEAD,@"?ac=htg_withdraw"]


#endif /* RequestConstDefine_h */

