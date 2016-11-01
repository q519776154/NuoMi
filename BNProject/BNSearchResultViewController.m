//
//  BNSearchResultViewController.m
//  BNProject
//
//  Created by qianfeng on 16/9/21.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "BNSearchResultViewController.h"
#import "BNCity.h"
@interface BNSearchResultViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) UITableView *resultTableView;

@end

@implementation BNSearchResultViewController

- (UITableView *)resultTableView
{
    if (!_resultTableView) {
        UITableView *tb = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        tb.delegate = self;
        tb.dataSource =self;
        
        [self.view addSubview:tb];
        [tb registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _resultTableView = tb;
    }
    return _resultTableView;
}

-(void)setSearchResultArray:(NSArray *)searchResultArray
{
    _searchResultArray =searchResultArray;
    [self.resultTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //把滚动视图的边缘调整关掉
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchResultArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    BNCity *city = _searchResultArray[indexPath.row];
    cell.textLabel.text = city.name;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_searchResultViewControllerDidSelectCityCallback) {
        [self dismissViewControllerAnimated:NO completion:nil];
        _searchResultViewControllerDidSelectCityCallback(indexPath.row);
    }
}

@end
