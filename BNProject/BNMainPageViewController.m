//
//  BNMainPageViewController.m
//  BNProject
//
//  Created by qianfeng on 16/9/20.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "BNMainPageViewController.h"
#import "BNLocationManager.h"
#import "BNLeftBarButton.h"
#import "BNConfig.h"
#import "BNCityListViewController.h"
#import "BNCity.h"
#import "BNQRCodeViewController.h"
@interface BNMainPageViewController ()

@property (nonatomic,weak) BNLeftBarButton *leftBarButton;

@end

@implementation BNMainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[BNLocationManager sharedLocationManager] startLocationService:^(CLPlacemark *placemark){
        NSString *city = placemark.locality;
        [_leftBarButton setTitle:city forState:UIControlStateNormal];
        //2.请求网络数据
    }];
    [self initLeftBarButtonWithTitle:@"深圳"];
    [self initSearchBar];
    [self initRightButtonBarItem];
}
#pragma mark - 初始化initLeftBarButtonWithTitle
- (void)initLeftBarButtonWithTitle:(NSString *)title
{
    BNLeftBarButton *button = [BNLeftBarButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 0, 30);
    [button setTitleColor:kAppTintColor forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"home_arrow_down_red"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cityListViewController) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    _leftBarButton = button;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
#pragma mark - 初始化initSearchBar
- (void)initSearchBar
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 180, 30)];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, titleView.frame.size.width, 30)];
    searchBar.layer.borderWidth = 0.5;
    searchBar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //去掉默认图片
    searchBar.backgroundImage = [[UIImage alloc]init];
    searchBar.layer.cornerRadius = 5;
    searchBar.placeholder = @"请输入内容";
    [titleView addSubview:searchBar];
    self.navigationItem.titleView = titleView;
    
    

}
- (void)initRightButtonBarItem
{
   //购物车按钮
    UIButton *shopCar = [UIButton buttonWithType:UIButtonTypeCustom];
    shopCar.frame = CGRectMake(0, 0, 30, 30);
    [shopCar setImage:[UIImage imageNamed:@"icon_nav_cart_normal"] forState:UIControlStateNormal];
    [shopCar setImage:[UIImage imageNamed:@"icon_nav_cart_press"] forState:UIControlStateHighlighted];
    
    //二维码按钮
    UIButton *qrButton = [UIButton buttonWithType:UIButtonTypeCustom];
    qrButton.frame = CGRectMake(0, 0, 30, 30);
    [qrButton setImage:[UIImage imageNamed:@"icon_nav_saoyisao_normal"] forState:UIControlStateNormal];
    [qrButton setImage:[UIImage imageNamed:@"icon_nav_saoyisao_pressed"] forState:UIControlStateHighlighted];
    UIBarButtonItem *qrItem = [[UIBarButtonItem alloc] initWithCustomView:qrButton];
    UIBarButtonItem *shopCarItem = [[UIBarButtonItem alloc] initWithCustomView:shopCar];
    self.navigationItem.rightBarButtonItems = @[qrItem,shopCarItem];
    
    
}
#pragma mark - 进入二维码扫描界面
- (void)qrCodeViewController
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"拍摄功能不能用" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    BNQRCodeViewController *qrCtrl = [[BNQRCodeViewController alloc] init];
    [self.navigationController pushViewController:qrCtrl animated:YES];
}

#pragma mark - 进入城市选择界面
- (void)cityListViewController
{
    BNCityListViewController *cityListCtrl = [[BNCityListViewController alloc]init];
    [cityListCtrl setCityListViewControllerDidSelectCityCallback:^(BNCity *city) {
        [self.leftBarButton setTitle:city.name forState:UIControlStateNormal];
    }];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cityListCtrl];
    [self presentViewController:nav animated:YES completion:nil];
    
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
