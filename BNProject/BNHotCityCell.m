//
//  BNHotCityCell.m
//  BNProject
//
//  Created by qianfeng on 16/9/21.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "BNHotCityCell.h"
#import "BNConfig.h"
#import "UIImage+Resize.h"
#import "BNCity.h"


@implementation BNHotCityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kRGB(230, 230, 230);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setHotCities:(NSArray *)hotCities
{
    _hotCities = hotCities;
    for (UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
    CGFloat width = (kScreenWidth - 2 * kInsertSpace - (kNumberOfColumn - 1)*kItemSpace)/kNumberOfColumn;
    for (int i = 0; i < hotCities.count; i++) {
        BNCity *city = hotCities[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kInsertSpace + (i%kNumberOfColumn)*(width+kItemSpace), kInsertSpace+(i/3)*(kItemHeight+kItemSpace), width, kItemHeight);
        btn.tag = i + 1;
        
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[[UIImage imageNamed:@"check_gray"] resizableImage] forState:UIControlStateNormal];
        [btn setTitle:city.name forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
    }
}
- (void)buttonClick:(UIButton *)button
{
    if (_hotCityCellDidSelectCityCallback) {
        NSInteger index = button.tag - 1;
        _hotCityCellDidSelectCityCallback(index);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
