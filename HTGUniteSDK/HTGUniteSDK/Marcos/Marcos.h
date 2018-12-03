//
//  Marcos.h
//  HTGUniteSDK
//
//  Created by zhangfujun on 2018/4/5.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#ifndef Marcos_h
#define Marcos_h

#import "UIImage+TBCityIconFont.h"
#import "TBCityIconInfo.h"
#import "TBCityIconFont.h"
#import "HTCustomLog.h"
#import "UIColor+Addition.h"


/////////////////////////////////////////////
//      客户端系统信息
/////////////////////////////////////////////
#define IOS7                    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)    //!< 系统版本
#define IOS8                    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)    //!< 系统版本
#define IOS9                    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9)    //!< 系统版本
#define IOS10                    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10)    //!< 系统版本
#define IPHONE_CLIENT_NAME      @"iPhone"                                                       //!< 系统名
#define IPHONE_CLIENT_VERSION   [UIDevice clientVersion]                                        //!< 客户端版本号
#define IPHONE_BUNDLE_DISPLAY_NAME     [UIDevice clientName]                                           //!< 客户端名称
#define IPHONE_UNIQUEIDENTIFIER [UIDevice uuid]                                                 //!< 唯一识别码
#define INTERFACE_VERSION       SG_RequestCenter.serverVersion                                  //!< 接口版本号
#define OSTYPE                  @"ios"
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//-------------------------------------------机型判断--------------------------------------------//
#define IS_IPhonePlus      fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)736 ) < DBL_EPSILON
#define IS_IPhone6Normal   fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)667 ) < DBL_EPSILON
#define IS_IPhone5         fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)568 ) < DBL_EPSILON
#define IS_IPhone4         fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)480 ) < DBL_EPSILON//SDK系统类型

//屏幕比例以iPhone6屏幕宽、高为基准
#define EnlargeSize          CGRectGetHeight([[UIScreen mainScreen] bounds]) / 667.0f

//导航控制器画布宽和高
#define NAVIGATIONCONTROLLERHWIDTH   320
#define NAVIGATIONCONTROLLERHEIGHT   300


//判断是否是  统计事件请求接口  入参是否进行加密请求  key值
#define ISSTATISTICSREQUEST  @"ISSTATISTICSREQUEST"   //'1'是  ‘0’不是

//全局可移动按钮背景图片
#define SUSPENSIONBUTTONIMAGE  @"4398logo"   //图片名字

//某些接口请求返回是否显示  请求成功或者失败信息提示   ‘0’不提示  ‘1’提示
#define ISSHOW_RESPONSE_TOASTMESSAGE  @"0"
#define ISSHOW_RESPONSE_TOASTMESSAGE_KEY  @"ISSHOW_RESPONSE_TOASTMESSAGE_KEY"   //某些接口请求返回是否显示  请求成功或者失败信息提示   ‘0’不提示  ‘1’提示

//是否统计过激活事件
#define ISINITILIZE_KEY  @"ISINITILIZE_KEY"

//今天的日期时间键值
#define THISDATE_KEY  @"THISDATE_KEY"

/////////////////////////////////////////////
// 关闭 selector may cause leak 警告
/////////////////////////////////////////////
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

//非调试状态，不展示log信息
#ifndef DEBUG
#define NSLog(...)
#endif


#pragma mark -Singleton define
/////////////////////////////////////////////
// 单例宏定义
/////////////////////////////////////////////

#define DEFINE_SINGLETON_FOR_HEADER(className) \
\
+ (className *)sharedManager;

#define DEFINE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)sharedManager { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
@synchronized(self){ \
shared##className = [[self alloc] init]; \
} \
}); \
return shared##className; \
}

//通知
#define HTPOSTNOTIFICATION(a)    [[NSNotificationCenter defaultCenter] postNotificationName:a object:nil]

#pragma mark -Model Factory
/////////////////////////////////////////////
// 模型工厂定义
/////////////////////////////////////////////

#define DEFINE_MODEL_FOR_HEADER \
\
+ (instancetype)model;

#define DEFINE_MODEL_FOR_CLASS(className) \
\
+ (instancetype)model \
{ \
__autoreleasing className *model = [[className alloc] init]; \
return model; \
}

#define WEAK_SELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define STRONG_SELF(strongSelf,weakSelf) __strong __typeof(weakSelf)strongSelf = weakSelf;

#define ISNIL(obj)               (nil == (obj) || [obj isEqual:[NSNull null]])

#define IS_DICTIONARY_CLASS(variable) ((!ISNIL(variable))&&([variable  isKindOfClass:[NSDictionary class]])&&([((NSDictionary *)variable) count]>0))

#define IS_ARRAY_CLASS(variable) ((!ISNIL(variable))&&([variable  isKindOfClass:[NSArray class]])&&([((NSArray *)variable) count]>0))

#define IS_EXIST_STR(str) ((nil != (str)) &&([(str) isKindOfClass:[NSString class]]) && (((NSString *)(str)).length > 0))


#define TRIM(str)   [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

#define STR_HAS_SUB_STR(str,subStr) ((nil != (str)) && (nil != (subStr)) && ([(str) rangeOfString:(subStr) options:NSCaseInsensitiveSearch].location != NSNotFound))



// FRAME
#define KSCREEN_WIDTH                         [[UIScreen mainScreen] bounds].size.width
#define KSCREEN_HEIGHT                        [[UIScreen mainScreen] bounds].size.height

// FONT
#define KSYSTEM_FONT_(a)                      [UIFont systemFontOfSize:a]
#define KSYSTEM_FONT_BOLD_(a)                 [UIFont boldSystemFontOfSize:a]
#define KICON_FONT_(a)                        [UIFont fontWithName:@"iconfont" size:a]

//NSNUMBER TO NSSTRING
#define kTransferToStringWithNumber(a)        [NSString stringWithFormat:@"%@", a]

// COLLOR
#define KCOLOR_WHITE                          [UIColor whiteColor]
#define KCUSTOMERTYPE_COLOR_TITLEVIEWLABEL    [UIColor  colorWithHex:@"#474647"]          //  标题文字颜色
#define kQuickLoginNormalTextColor            [UIColor  colorWithHex:@"#30B960"]
#define kQuickLoginCancelTextColor            [UIColor  colorWithHex:@"#979797"]          //取消按钮底色背景

//IMAGE
#define kIC_Img(name,size,color)              [UIImage iconWithInfo:TBCityIconInfoMake(name, size, color)]


// NSUserDefaults
#define SYSTEMINFO_SET_(value,key)            [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]
#define SYSTEMINFO_GET_(a)                    [[NSUserDefaults standardUserDefaults] objectForKey:a]

//KEY_CHAIN
#define KEY_USERINFO                          @"com.company.app.userinfo"
#define USER_FIRSTLOGIN                       @"userfirstLogin"

#define GA_AD_DE_CHANNELNAME                  @"htdata"


// CORNERRADIUS

#define KLLog(format, ...) {\
if ([HTCustomLog logEnable]) {\
NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];\
[dateFormatter setDateStyle:NSDateFormatterMediumStyle];\
[dateFormatter setTimeStyle:NSDateFormatterShortStyle];\
[dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"]; \
NSString *str = [dateFormatter stringFromDate:[NSDate date]];\
fprintf(stderr,"[HTSDKLog] %s (%s:%d)%s\t%s\n\n",[str UTF8String],[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__,__func__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);\
}\
}\

#define kService [NSBundle mainBundle].bundleIdentifier
//#define kAccount @"com.ht.sdk"
#define kAccount @"com.chuangyun.YYJ"

#define   KisFirstInstrument                     @"isFirstInstrument"
// 字符串加密
#define HTENCODE(str)           [HTRSA encode:str withKey:@"zfj2602"]
#define HTDECODE(str)           [HTRSA decode:str withKey:@"zfj2602"]

#endif /* Marcos_h */



