//
//  UIDevice+Version.m
//  BNProject
//
//  Created by qianfeng on 16/9/20.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "UIDevice+Version.h"

@implementation UIDevice (Version)

+ (CGFloat)systemVersion
{
    return [UIDevice currentDevice].systemVersion.floatValue;
}

@end
