//
//  BNBaseTabbarController.m
//  BNProject
//
//  Created by qianfeng on 16/9/20.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "BNBaseTabbarController.h"

@interface BNBaseTabbarController ()

@end

@implementation BNBaseTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:255.0/255.0 green:85/255.0 blue:141.0/255.0 alpha:1.0]} forState:UIControlStateSelected];
    
    [self initChildrenController];
}

- (void)initChildrenController
{
    NSArray *ctrlNames = @[@"BNMainPageViewController",
                          @"BNNearViewController",
                          @"BNChooseViewController",
                          @"BNMyViewController"];
    
    NSArray *titles = @[@"首页",@"附近",@"精选",@"我的"];
    
    NSArray *normalImageNames = @[
                                  @"icon_tab_shouye_normal",
                                  @"icon_tab_fujin_normal",
                                  @"tab_icon_selection_normal",
                                  @"icon_tab_wode_normal"];
    NSArray *selectedImageNames = @[
                                @"icon_tab_shouye_highlight",
                                @"icon_tab_fujin_highlight",
                                @"tab_icon_selection_highlight",
                                @"icon_tab_wode_highlight"];
    
    [ctrlNames enumerateObjectsUsingBlock:^(NSString  *ctrlName, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *ctrl = [[NSClassFromString(ctrlName) alloc] init];
        ctrl.title = titles[idx];
        ctrl.tabBarItem.image = [UIImage imageNamed:normalImageNames[idx]];
        ctrl.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageNames[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
        
        [self addChildViewController:nav];
    }];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
