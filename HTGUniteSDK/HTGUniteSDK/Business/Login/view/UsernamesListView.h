//
//  UsernamesListView.h
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/24.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import <UIKit/UIKit.h>

//创建协议
@protocol UsernameListviewDelegate <NSObject>
- (void)actionDelete:(NSUInteger)index;
- (void)actionSelected:(NSUInteger)index;

@end

@interface UsernamesListView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *table;  //!< table

@property (nonatomic, strong) NSMutableArray *array;  //!< 缓存数组

@property (nonatomic, assign) id<UsernameListviewDelegate> delegate;



@end
