//
//  BNSearchResultViewController.h
//  BNProject
//
//  Created by qianfeng on 16/9/21.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SearchResultViewControllerDidSelectCityCallback)(NSInteger index);
@interface BNSearchResultViewController : UIViewController

@property (nonatomic,strong) NSArray *searchResultArray;

@property (nonatomic,copy) SearchResultViewControllerDidSelectCityCallback searchResultViewControllerDidSelectCityCallback;

- (void)setSearchResultViewControllerDidSelectCityCallback:(SearchResultViewControllerDidSelectCityCallback)searchResultViewControllerDidSelectCityCallback;

@end
