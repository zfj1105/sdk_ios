//
//  NSMutableDictionary+Addition.h
//  CBWallet4iPhone
//
//  Created by zhangxiaodong on 15-1-24.
//  Copyright (c) 2015年 chinabank payments. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Addition)

- (void)addObjectIfNotBlank:(id)obj forKey:(id<NSCopying>)key;

@end
