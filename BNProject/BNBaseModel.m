//
//  BNBaseModel.m
//  BNProject
//
//  Created by qianfeng on 16/9/21.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "BNBaseModel.h"

@implementation BNBaseModel

+ (id)modelWithDictionary:(NSDictionary *)dictionary
{
    BNBaseModel *model = [[self alloc] init];
    [model setValuesForKeysWithDictionary:dictionary];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
