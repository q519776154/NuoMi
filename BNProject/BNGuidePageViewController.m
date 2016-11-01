//
//  BNGuidePageViewController.m
//  BNProject
//
//  Created by qianfeng on 16/9/20.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "BNGuidePageViewController.h"
#import "BNConstConfig.h"
#import "BNBaseTabbarController.h"
#import "NSUserDefaultsConfig.h"
@interface BNGuidePageViewController ()

@end

@implementation BNGuidePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubViews];
}

- (void)initSubViews
{
    int num = 3;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.contentSize = CGSizeMake(num * kScreenWidth, kScreenHeight);
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    
    for (int i = 0; i < num; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%@%d",[self guideImageName],i + 1];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        imageView.image = [UIImage imageNamed:imageName];
        [scrollView addSubview:imageView];
        
        if (i == num - 1) {
            imageView.userInteractionEnabled = YES;
            UIImage *image = [UIImage imageNamed:@"guide_enter_98x28_"];
            CGSize size = image.size;
            UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
            enterButton.frame = CGRectMake(self.view.frame.size.width / 2 - size.width / 2, self.view.frame.size.height - 90, size.width, size.height);
            [enterButton setImage:image forState:UIControlStateNormal];
            [enterButton addTarget:self action:@selector(enterMainPage) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:enterButton];
        }
    }
}

- (NSString *)guideImageName
{
    NSString *image = nil;
    
    if (kScreenWidth == 320) {
        image = [NSString stringWithFormat:@"guide_%d_%d_",(int)kScreenWidth * 2,(int)kScreenHeight * 2];
    }
    else if (kScreenWidth == 375)
    {
        image = @"guide_750_1334_";
    }else
    {
        image = @"guide_1080_1920_";
    }
    return image;
}
- (void)enterMainPage
{
    [[NSUserDefaults standardUserDefaults] setValue:@"openApplication" forKey:kFirstOpenKey];
    
    if (_guidePageViewControllerDidEnterMainPageCallback) {
        _guidePageViewControllerDidEnterMainPageCallback();
    }
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
