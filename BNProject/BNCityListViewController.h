//
//  BNCityListViewController.h
//  BNProject
//
//  Created by qianfeng on 16/9/21.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNCity;

typedef void(^CityListViewControllerDidSelectCityCallback)(BNCity *city);

@interface BNCityListViewController : UIViewController

@property (nonatomic,copy) CityListViewControllerDidSelectCityCallback cityListViewControllerDidSelectCityCallback;

- (void) setCityListViewControllerDidSelectCityCallback:(CityListViewControllerDidSelectCityCallback)callback;

@end
