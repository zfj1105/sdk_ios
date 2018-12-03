//
//  ModelShare.m
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/27.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "ModelShare.h"

@implementation ModelShare

DEFINE_MODEL_FOR_CLASS(ModelShare)

- (BOOL)loadModelInfoModelWithDic:(NSDictionary *)dic
{
    if (!IS_DICTIONARY_CLASS(dic)) {
        return NO;
    }
    
    self.url = dic[@"url"];
    self.intro = dic[@"intro"];
    
    return YES;
}

- (BOOL)resetNull
{
    self.url = nil;
    self.url = nil;
    
    return YES;
}


@end
