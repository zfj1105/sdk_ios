//
//  ModelLogin.m
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/20.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "ModelLogin.h"

@implementation ModelLogin

DEFINE_MODEL_FOR_CLASS(ModelLogin)

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        //可以做初始化缓存模型操作
        
    }
    
    return self;
}

- (BOOL)loadModelInfoModelWithDic:(NSDictionary *)dic
{
    if (!IS_DICTIONARY_CLASS(dic)) {
        return NO;
    }
    
    self.code = kTransferToStringWithNumber(dic[@"code"]);
    self.ischeck = kTransferToStringWithNumber(dic[@"ischeck"]);
    self.isidcard = kTransferToStringWithNumber(dic[@"isidcard"]);
    self.isshiming = kTransferToStringWithNumber(dic[@"isshiming"]);
    self.msg = dic[@"msg"];
    self.remark = kTransferToStringWithNumber(dic[@"remark"]);
    self.sessionid = dic[@"sessionid"];
    self.uid = kTransferToStringWithNumber(dic[@"uid"]);
    self.username = dic[@"username"];
    self.userphone = dic[@"userphone"];
    self.isnew = kTransferToStringWithNumber(dic[@"isnew"]);
    self.password = dic[@"password"];

    return YES;
}

- (BOOL)resetNull
{
    self.code = nil;
    self.ischeck = nil;
    self.isidcard = nil;
    self.isshiming = nil;
    self.msg = nil;
    self.remark = nil;
    self.sessionid = nil;
    self.uid = nil;
    self.username = nil;
    self.userphone = nil;
    self.isnew = nil;
    self.password = nil;
    
    
    //本地标识，非server端返回json字段
    self.realname = nil;
    self.idcard = nil;
    
    self.commisionAmount = nil;
    return YES;
}

@end
