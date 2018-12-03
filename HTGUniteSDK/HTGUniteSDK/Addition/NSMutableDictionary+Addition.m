//
//  NSMutableDictionary+Addition.m
//  CBWallet4iPhone
//
//  Created by zhangxiaodong on 15-1-24.
//  Copyright (c) 2015年 chinabank payments. All rights reserved.
//

#import "NSMutableDictionary+Addition.h"

@implementation NSMutableDictionary (Addition)

- (void)addObjectIfNotBlank:(id)obj forKey:(id<NSCopying>)key
{
    if (obj == [NSNull null]) {
        return;
    }
    
    if (!obj) {
        return;
    }
    
    if ([obj isKindOfClass:[NSString class]] && [obj length] == 0) {
        return;
    }
    
    [self setObject:obj forKey:key];
}

@end
