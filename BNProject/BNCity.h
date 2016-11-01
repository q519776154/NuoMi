//
//  BNCity.h
//  BNProject
//
//  Created by qianfeng on 16/9/21.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNBaseModel.h"
#import <CoreGraphics/CoreGraphics.h>

@interface BNCity : BNBaseModel

/**
 *  拼音
 */
@property (nonatomic, copy) NSString *pinyin;

/**
 *  纬度
 */
@property (nonatomic) CGFloat lat;

/**
 *  经度
 */
@property (nonatomic) CGFloat lng;

/**
 *  城市名字
 */
@property (nonatomic, copy) NSString *name;

/**
 *  城市id
 */
@property (nonatomic) NSInteger cityid;

@end
