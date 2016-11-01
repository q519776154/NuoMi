//
//  BNMyViewController.m
//  BNProject
//
//  Created by qianfeng on 16/9/20.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "BNMyViewController.h"
#import "BNMyCardViewController.h"
@interface BNMyViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,weak) UITableView *myTableView;

@property (nonatomic,strong) NSArray *dataSourceArray;


@end

@implementation BNMyViewController

- (UITableView *)myTableView
{
    if (!_myTableView) {
        UITableView *tb = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        tb.delegate = self;
        tb.dataSource =self;
        tb.rowHeight = 70;
        [self.view addSubview:tb];
        
        [tb registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _myTableView = tb;
    }
    return _myTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataSourceArray = @[@"我的名片"];
    self.myTableView.tableFooterView = [[UIView alloc] init];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.imageView.image = [UIImage imageNamed:@"baidu_wallet_bsc"];
    cell.textLabel.text = _dataSourceArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNMyCardViewController *cardCtrl = [[BNMyCardViewController alloc] init];
   

    [self.navigationController pushViewController:cardCtrl animated:YES];
}

@end











