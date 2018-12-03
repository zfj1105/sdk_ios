//
//  DBManager.m
//  iRead
//
//  Created by zhangfujun on 11-11-2.
//  Copyright 2011 chinabank. All rights reserved.
//

#import "DBManager.h"

#import "FMDatabase.h"

@interface DBManager ()

@property (nonatomic, strong) NSString    *   dbPath;//数据库路径

@property (nonatomic, strong)  NSFileManager *fileManager;//文件管理器

@property (nonatomic, strong)  FMDatabase *db; //数据库管理对象


@end

@implementation DBManager

static DBManager *instance;

+ (DBManager *)sharedDBManager
{
    static dispatch_once_t onceToken;
    static id instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[DBManager alloc] init];
    });
    
    return instance;
}

- (id)init {
    
    self = [super init];
    if (self)
    {
        //创建数据库文件和sqlite数据库、创建表
        BOOL fileExists = [self.fileManager fileExistsAtPath:self.dbPath];
        if (!fileExists) {
            self.db = [FMDatabase databaseWithPath:self.dbPath];
            [self createTable];
        }
    }
    
    return self;
}

// 建表
- (void)createTable {
    KLLog(@"%s", __func__);
    
    //第一次创建表之后 self.db  为空
    if ([self.db open]) {
        NSString *sql = @"CREATE TABLE IF NOT EXISTS 'user' ('username' VARCHAR(30) PRIMARY KEY NOT NULL , 'password' VARCHAR(30),'isCodeLogin' VARCHAR(30),'dateline' VARCHAR(30) ,'iapCount' VARCHAR(30) default '0','thisDate' VARCHAR(30),'phoneNum' VARCHAR(30), 'sessionid' VARCHAR(30), 'ischeck' VARCHAR(30), 'isidcard' VARCHAR(30), 'isshiming' VARCHAR(30), 'uid' VARCHAR(30), 'remark' VARCHAR(30), 'isnew' VARCHAR(30))";
        BOOL res = [self.db executeUpdate:sql];
        if (!res) {
            KLLog(@"error when creating db table");
        } else {
            KLLog(@"success create db table");
        }
        [self.db close];
    } else {
        KLLog(@"error when open db");
    }
}

// 插入数据
- (BOOL)insertDataWithUserInfo:(UserInfo *)user {
    KLLog(@"%s", __func__);
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        
        NSString *sql = @"insert into user (username, password,isCodeLogin,dateline,iapCount,phoneNum,sessionid, ischeck,isidcard,isshiming,uid,remark,isnew) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
        
        BOOL res = [db executeUpdate:sql, user.username, user.password,user.isCodeLogin,user.dateline,user.iapCount,user.phoneNum,user.sessionid,user.ischeck, user.isidcard,user.isshiming,user.uid,user.remark,user.isnew];
        if (!res) {
            KLLog(@"error to insert data");
        } else {
            KLLog(@"success to insert data");
        }
        [db close];
        return res;
    }else{
        return NO;
    }
}

// 更新数据
- (BOOL)updateDataWithUserInfo:(UserInfo *)user {
    KLLog(@"%s", __func__);
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *sql = @"UPDATE user SET password = ?  WHERE  username = ?";
        BOOL res = [db executeUpdate:sql, user.password, user.username];
        if (!res) {
            KLLog(@"error to UPDATE data");
        } else {
            KLLog(@"success to UPDATE data");
        }
        [db close];
        return res;
    }
    return NO;
}

// 更新数据时间戳
- (BOOL)updateDatelineWithUserInfo:(UserInfo *)user {
    KLLog(@"%s", __func__);
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *sql = @"UPDATE user SET dateline = ?  WHERE  username = ?";
        BOOL res = [db executeUpdate:sql, user.dateline, user.username];
        if (!res) {
            KLLog(@"error to UPDATE data");
        } else {
            KLLog(@"success to UPDATE data");
        }
        [db close];
        return res;
    }
    return NO;
}

// 更新用户内购次数
- (BOOL)updateIapCountWithUserInfo:(UserInfo *)user{
    KLLog(@"%s", __func__);
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *sql = @"UPDATE user SET iapCount = ?  WHERE  username = ?";
        BOOL res = [db executeUpdate:sql, user.iapCount, user.username];
        if (!res) {
            KLLog(@"error to UPDATE data");
        } else {
            KLLog(@"success to UPDATE data");
        }
        [db close];
        return res;
    }
    return NO;
}

// 删除数据
- (BOOL)deleteDataWithUserInfo:(UserInfo *)user {
    KLLog(@"%s", __func__);
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *sql = @"delete from user where username = ?";
        BOOL res = [db executeUpdate:sql, user.username];
        if (!res) {
            KLLog(@"error to delete db data");
        } else {
            KLLog(@"success to delete db data");
        }
        [db close];
        return res;
    }
    return NO;
}

// 查询数据返回表中所有的
- (NSArray *)queryDataUserNames
{
    KLLog(@"%s", __func__);
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *sql = @"select * from user ORDER BY dateline DESC";
        FMResultSet *rs = [db executeQuery:sql];
        NSMutableArray  *resArray = [NSMutableArray array];
        while ([rs next]) {
            KLLog(@"success to query db data");
            UserInfo *user = [UserInfo new];
            NSString *name = [rs stringForColumn:@"username"];
            NSString *pass = [rs stringForColumn:@"password"];
            NSString *phoneNum = [rs stringForColumn:@"phoneNum"];
            NSString *sessionid = [rs stringForColumn:@"sessionid"];
            NSString *isCodeLogin = [rs stringForColumn:@"isCodeLogin"];
            NSString *IapCount = [rs stringForColumn:@"iapCount"];
            user.username = name;
            user.password = pass;
            user.sessionid = sessionid;
            user.phoneNum = phoneNum;
            user.isCodeLogin = isCodeLogin;
            user.iapCount = IapCount;
            [resArray addObject:user];
        }
        [db close];
        return resArray;
    }
    return nil;
}

// 查询数据返回表中某个用户内购次数
- (UserInfo *)queryDataUserIapCountWithUserName:(NSString *)username
{
    KLLog(@"%s", __func__);
    UserInfo *user = [UserInfo new];
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *sql = @"select * from user where username = ?";
        FMResultSet *rs = [db executeQuery:sql,username];
        while ([rs next]) {
            KLLog(@"success to query db data");
            NSString *name = [rs stringForColumn:@"username"];
            NSString *pass = [rs stringForColumn:@"password"];
            NSString *phoneNum = [rs stringForColumn:@"phoneNum"];
            NSString *sessionid = [rs stringForColumn:@"sessionid"];
            NSString *isCodeLogin = [rs stringForColumn:@"isCodeLogin"];
            NSString *IapCount = [rs stringForColumn:@"iapCount"];
            user.username = name;
            user.password = pass;
            user.sessionid = sessionid;
            user.phoneNum = phoneNum;
            user.isCodeLogin = isCodeLogin;
            user.iapCount = IapCount;
        }
        [db close];
        return user;
    }
    return nil;
}


- (void)updateLocalDateAndUserIapCount
{
    ModelLogin *loginModel = [RequestManager sharedManager].loginModel;
    UserInfo *user = [[DBManager sharedDBManager] queryDataUserIapCountWithUserName:loginModel.username];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *thisDateLocal = [ud objectForKey:THISDATE_KEY];
    NSString *thisDate = [HTUtil getCurrentTime];
    if (!IS_EXIST_STR(thisDateLocal) || ![thisDate isEqualToString:thisDateLocal]) {
        //更新本地数据库内购次数
        UserInfo *updateUser = [UserInfo new];
        updateUser.iapCount = @"0";
        updateUser.username = user.username;
        [[DBManager sharedDBManager] updateIapCountWithUserInfo:updateUser];
        
        [ud setObject:thisDate forKey:THISDATE_KEY];
        [ud synchronize];
    }
}

#pragma mark - lazy

- (NSString *)dbPath
{
    if (!_dbPath) {
        
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        _dbPath = [doc stringByAppendingPathComponent:@"htsdk.sqlite"];
        
        KLLog(@"%@",_dbPath);
        
    }
    return _dbPath;
}

- (NSFileManager *)fileManager
{
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

@end
