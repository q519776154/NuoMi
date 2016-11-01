//
//  BNGuidePageViewController.h
//  BNProject
//
//  Created by qianfeng on 16/9/20.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GuidePageViewControllerDidEnterMainPageCallback)(void);

@interface BNGuidePageViewController : UIViewController

@property (nonatomic, copy) GuidePageViewControllerDidEnterMainPageCallback guidePageViewControllerDidEnterMainPageCallback;

- (void)setGuidePageViewControllerDidEnterMainPageCallback:(GuidePageViewControllerDidEnterMainPageCallback)guidePageViewControllerDidEnterMainPageCallback;

@end
