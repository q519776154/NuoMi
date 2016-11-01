//
//  BNHotCityCell.h
//  BNProject
//
//  Created by qianfeng on 16/9/21.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
//内边距
#define kInsertSpace 10
//item直接的距离
#define kItemSpace 20
//item高度
#define kItemHeight 40
//列数
#define kNumberOfColumn 3
typedef void(^HotCityCellDidSelectCityCallback)(NSInteger index);

@interface BNHotCityCell : UITableViewCell
/**
 *  热门城市
 */
@property (nonatomic, strong) NSArray *hotCities;

@property (nonatomic, copy)HotCityCellDidSelectCityCallback hotCityCellDidSelectCityCallback;

- (void)setHotCityCellDidSelectCityCallback:(HotCityCellDidSelectCityCallback)callback;


@end
