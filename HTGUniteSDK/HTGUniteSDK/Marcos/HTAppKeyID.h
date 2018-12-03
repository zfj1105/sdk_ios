//
//  HTAppKeyID.h
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/18.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#ifndef HTAppKeyID_h
#define HTAppKeyID_h



#define HTUniteSDKVersion            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]   // SDK版本

#define HTPRODUCTID                  [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultProductID_KEY]   //产品ID

#define HTCOOPID                     @"1"   //渠道ID

#define HTCPCHANNELNAME              @"htdata"   //cp渠道ID

#define HTGCPSSCHEME                 @"htgcps://"//佣金提现App scheme


#endif /* HTAppKeyID_h */
