//
//  ModelGetLoginKey.m
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/20.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "ModelGetLoginKey.h"

@implementation ModelGetLoginKey

DEFINE_MODEL_FOR_CLASS(ModelGetLoginKey)


- (id)init {
    
    self = [super init];
    
    if (self) {
        
        //可以做初始化缓存模型操作
        //数组和字典的初始化工作
    }
    
    return self;
}

- (BOOL)loadModelInfoModelWithDic:(NSDictionary *)dic
{
    if (!IS_DICTIONARY_CLASS(dic)) {
        return NO;
    }
    
    self.closelogin = dic[@"closelogin"];
    self.closepay = dic[@"closepay"];
    self.closereg = dic[@"closereg"];
    self.code = dic[@"code"];
    self.gonggaostatus = dic[@"gonggaostatus"];
    self.gonggaourl = dic[@"gonggaourl"];
    self.isbandingphone = dic[@"isbandingphone"];
    self.iscommission = dic[@"iscommission"];
    self.isiap = dic[@"isiap"];
    self.isopenshiming = dic[@"isopenshiming"];
    
    self.isreview = dic[@"isreview"];
    self.kefu = dic[@"kefu"];
    self.manage = dic[@"manage"];
    self.moreapp = dic[@"moreapp"];
    self.msg = dic[@"msg"];
    self.isshare = dic[@"isshare"];
    self.pack = dic[@"pack"];
    self.paylog = dic[@"paylog"];
    self.phoneregister = dic[@"phoneregister"];
    self.shimingrenzheng = dic[@"shimingrenzheng"];
    self.level = dic[@"level"];
    self.count = dic[@"count"];
    
    self.goToAutoLogin = @"1";//初始化为自动登录

    return YES;
}

- (BOOL)resetNull
{
    self.closelogin = nil;
    self.closepay = nil;
    self.closereg = nil;
    self.code = nil;
    self.gonggaostatus = nil;
    self.gonggaourl = nil;
    self.isbandingphone = nil;
    self.iscommission = nil;
    self.isiap = nil;
    self.isopenshiming = nil;
    
    self.isreview = nil;
    self.kefu = nil;
    self.manage = nil;
    self.moreapp = nil;
    self.msg = nil;
    self.isshare = nil;
    self.pack = nil;
    self.paylog = nil;
    self.phoneregister = nil;
    self.shimingrenzheng = nil;
    
    self.level = nil;
    self.count = nil;

    
    return YES;
}


@end
