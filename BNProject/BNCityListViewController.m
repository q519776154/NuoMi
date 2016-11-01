//
//  BNCityListViewController.m
//  BNProject
//
//  Created by qianfeng on 16/9/21.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "BNCityListViewController.h"
#import "BNCity.h"
#import "BNConfig.h"
#import "BNSearchResultViewController.h"
#import "BNHotCityCell.h"

#define kNumberOfHotCity 9

@interface BNCityListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating>
{
    BNSearchResultViewController *_searchReasultViewCtrl;
}

@property (nonatomic,weak) UITableView *cityTtableView;

@property (nonatomic,strong) NSMutableArray *cities;

@property (nonatomic,strong) NSMutableArray *cityIndexArray;

@property (nonatomic,strong) UISearchController *searchController;

@property (nonatomic,strong) NSMutableArray *searchResultArray;

@property (nonatomic,strong) NSMutableArray *hotCities;

@end

@implementation BNCityListViewController

#pragma mark - 懒加载
- (NSMutableArray *)hotCities
{
    if (!_hotCities) {
        _hotCities = [NSMutableArray array];
    }
    return _hotCities;
}

- (NSMutableArray *)cityIndexArray
{
    if (!_cityIndexArray) {
        _cityIndexArray = [NSMutableArray arrayWithObject:@"热门"];
    }
    return _cityIndexArray;
}

- (NSMutableArray *)cities
{
    if (!_cities) {
        _cities = [NSMutableArray array];
    }
    return _cities;
}

- (UISearchController *)searchController
{
    if (!_searchController) {
        BNSearchResultViewController *searchResultViewCtrl = [[BNSearchResultViewController alloc]init];
        [searchResultViewCtrl setSearchResultViewControllerDidSelectCityCallback:^(NSInteger index) {
            BNCity *city = self.searchResultArray[index];
            [self didSelectCityBackToMainPageViewControllerWithCity:city];
        }];
        _searchReasultViewCtrl = searchResultViewCtrl;
        _searchController = [[UISearchController alloc]initWithSearchResultsController:searchResultViewCtrl];
        _searchController.searchBar.tintColor = kAppTintColor;
        _searchController.searchBar.placeholder = @"请输入内容";
        _searchController.searchResultsUpdater = self;
    }
    return _searchController;
}

- (UITableView *)cityTtableView
{
    if (!_cityTtableView) {
        UITableView *tb = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        tb.delegate = self;
        tb.dataSource = self;
        tb.sectionIndexColor = kAppTintColor;
        tb.sectionIndexBackgroundColor = [UIColor clearColor];
        [self.view addSubview:tb];
        
        tb.tableHeaderView = self.searchController.searchBar;
        [tb registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [tb registerClass:[BNHotCityCell class] forCellReuseIdentifier:@"BNHotCityCell"];
        _cityTtableView = tb;
    }
    return _cityTtableView;
}
#pragma mark - 隐藏当前控制器
- (void)dissmiss
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didSelectCityBackToMainPageViewControllerWithCity:(BNCity *)city
{
    if (_cityListViewControllerDidSelectCityCallback) {
        _cityListViewControllerDidSelectCityCallback(city);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"城市列表";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"sapi-nav-back-btn-bg"] style:UIBarButtonItemStylePlain target:self action:@selector(dissmiss)];
    //修改searchbar的cancel文字
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"取消"];
    [self readAllCityInformation];
}
#pragma mark - 把汉字转化为拼音
- (void)convertToPinyin:(NSArray *)array
{
    for (BNCity *city in array) {
        NSString *name = city.name;
        NSMutableString *mutableString = [name mutableCopy];
        CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformMandarinLatin, false);
        CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
    }
}
#pragma mark - 获取所有城市的信息
- (void)readAllCityInformation
{
    
    NSMutableArray *sortCityArray = [NSMutableArray array];
    //1.读取plist文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil];
    NSArray *allCity = [NSArray arrayWithContentsOfFile:path];
    [allCity enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        
        BNCity *city = [BNCity modelWithDictionary:dic];
        
        [sortCityArray addObject:city];
        if (idx < kNumberOfHotCity) {
            [self.hotCities addObject:city];
        }
    }];
    [self.cities addObject:self.hotCities];
    //3.按拼音进行排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"pinyin" ascending:YES];
    [sortCityArray sortUsingDescriptors:@[sort]];
    //4.分组
    [self setCityToGroupWithCityArray:sortCityArray];
    //5.刷新tableView
    [self.cityTtableView reloadData];
    
}
#pragma mark - 对城市列表进行分组
- (void)setCityToGroupWithCityArray:(NSMutableArray *)cityArray
{
    if (cityArray.count == 0) {
        return;
    }
    BNCity *city = cityArray.firstObject;
    NSString *firstWord = [city.pinyin substringToIndex:1];
    
    NSMutableArray *subArray = [NSMutableArray array];
    
    [self.cities addObject:subArray];
    [self.cityIndexArray addObject:[firstWord uppercaseString]];
    
    for (BNCity *city in cityArray) {
        NSString *startStr = [city.pinyin substringToIndex:1];
        if ([startStr isEqualToString:firstWord]) {
            [subArray addObject:city];
        }
        else{
            firstWord = [city.pinyin substringToIndex:1];
            subArray = [NSMutableArray array];
            [self.cities addObject:subArray];
            [subArray addObject:city];
            [self.cityIndexArray addObject:[firstWord uppercaseString]];
        }
    }
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cities.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    NSArray *subArray = self.cities[section];
    return subArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BNHotCityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNHotCityCell"];
        [cell setHotCityCellDidSelectCityCallback:^(NSInteger index) {
            BNCity *city = self.hotCities[index];
            [self didSelectCityBackToMainPageViewControllerWithCity:city];
        }];
        NSArray *hotcities = self.cities[indexPath.section];
        cell.hotCities = hotcities;
        return cell;
    }else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        NSArray *subArray = self.cities[indexPath.section];
        BNCity *city = subArray[indexPath.row];
        cell.textLabel.text = city.name;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSInteger numberOfRow = (self.hotCities.count % 3 == 0)?self.hotCities.count/3:(self.hotCities.count/3)+1;
        return 2*kInsertSpace + numberOfRow * kItemHeight + (numberOfRow - 1) *kItemSpace;
    }
    return 50;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"热门城市";
    }
    NSArray *subArray = self.cities[section];
    BNCity *city = subArray.firstObject;
    NSString *startString = [city.pinyin substringToIndex:1];
    return [startString uppercaseString];
}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.cityIndexArray;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 0) {
        NSArray *subArray = self.cities[indexPath.section];
        BNCity *city = subArray[indexPath.row];
        [self didSelectCityBackToMainPageViewControllerWithCity:city];
    }
}
#pragma mark - UISearchResultUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    _searchResultArray = [NSMutableArray array];
    NSString *searchText = searchController.searchBar.text;
    for (NSArray *subArray in self.cities) {
        for (BNCity *city in subArray) {
            if ([city.name rangeOfString:searchText].location != NSNotFound || [city.pinyin rangeOfString:searchText].location != NSNotFound ||[city.pinyin rangeOfString:[searchText lowercaseString]].location != NSNotFound) {
                [_searchResultArray addObject:city];
            }
        }
    }
    _searchReasultViewCtrl.searchResultArray = _searchResultArray;
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
