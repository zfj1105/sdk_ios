//
//  ModelShare.h
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/27.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "HTBaseModel.h"

@interface ModelShare : HTBaseModel

DEFINE_MODEL_FOR_HEADER

@property (nonatomic, strong) NSString *url;  //!<  分享链接

@property (nonatomic, strong) NSString *intro;   //!<    分享描述

@end
