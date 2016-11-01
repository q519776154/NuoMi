//
//  BNCity.m
//  BNProject
//
//  Created by qianfeng on 16/9/21.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "BNCity.h"

@implementation BNCity

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.cityid = [value integerValue];
    }
}

@end
