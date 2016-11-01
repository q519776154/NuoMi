//
//  BNLeftBarButton.m
//  BNProject
//
//  Created by qianfeng on 16/9/21.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "BNLeftBarButton.h"
#import "NSString+Size.h"

#define kDefaultFontSize 13

#define kTitleMaxWidth 50

@implementation BNLeftBarButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize
{
    self.titleLabel.font = [UIFont systemFontOfSize:kDefaultFontSize];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSString *title = self.titleLabel.text;
    CGFloat width = [title sizeWithFontSize:kDefaultFontSize maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    int imageWidth = 10;
    int imageHeight = 7;
    
    if (width >= kTitleMaxWidth) {
        width = kTitleMaxWidth;
    }
    self.titleLabel.frame = CGRectMake(0, 0, width, self.frame.size.height);
    self.imageView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 2, self.frame.size.height/2, imageWidth, imageHeight);
    
    CGRect frame = self.frame;
    frame.size.width = CGRectGetMaxX(self.imageView.frame) + 5;
    self.frame = frame;
}

@end
