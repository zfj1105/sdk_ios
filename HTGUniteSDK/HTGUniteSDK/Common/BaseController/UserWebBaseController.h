//
//  UserWebBaseController.h
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/25.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "UserCenterBaseController.h"

@interface UserWebBaseController : UserCenterBaseController

@property (nonatomic, strong) NSString  *titleText;

@property (nonatomic, strong) NSString  *requestUrlString;

@property (nonatomic, assign) BOOL  isShowBackButton;




@end
