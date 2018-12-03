//
//  DBManager.h
//  iRead
//
//  Created by zhangfujun on 11-11-2.
//  Copyright 2014 chinabank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;

//#define SG_DBManager    [DBManager sharedDBManager]



@interface DBManager : NSObject


+ (DBManager *)sharedDBManager;


//建表
- (void)createTable;

// 插入数据
- (BOOL)insertDataWithUserInfo:(UserInfo *)user;

// 查询数据返回表中所有的username
- (NSArray *)queryDataUserNames;

// 查询数据返回表中某个用户内购次数
- (UserInfo *)queryDataUserIapCountWithUserName:(NSString *)username;


// 更新数据时间戳
- (BOOL)updateDatelineWithUserInfo:(UserInfo *)user;

// 更新用户内购次数
- (BOOL)updateIapCountWithUserInfo:(UserInfo *)user;

// 更新数据
- (BOOL)updateDataWithUserInfo:(UserInfo *)user;

// 删除数据
- (BOOL)deleteDataWithUserInfo:(UserInfo *)user;

- (void)updateLocalDateAndUserIapCount;


@end
