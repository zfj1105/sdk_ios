//
//  UserRealnamecontroller.h
//  HTGUniteSDK
//
//  Created by zfj2602 on 2018/4/16.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "UserCenterBaseController.h"

@interface UserRealnamecontroller : UserCenterBaseController

@property (nonatomic, strong) UILabel     *realnameState;                   //!<  认证状态

@property (nonatomic, strong) UIButton    *nextButton;                      //!<  下一步按钮

@property (nonatomic, strong) UIButton    *reRealnameButton;                //!<  重新认证按钮

@end
