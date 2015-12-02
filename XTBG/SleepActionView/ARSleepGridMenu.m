//
//  ARSleepGridMenu.m
//  AnyRadio
//
//  Created by 任维超 on 14-8-21.
//  Copyright (c) 2014年 AnyRadio.CN. All rights reserved.
//

#import "ARSleepGridMenu.h"
#import <QuartzCore/QuartzCore.h>

#define kMAX_CONTENT_SCROLLVIEW_HEIGHT _MainScreen_Height

@interface ARSleepGridMenu (){
    NSTimer  *sleepTimer;
    NSInteger setTimeInteger;
    BOOL isSleepTimeEnable;
}
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSArray *itemTitles;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) void (^actionHandle)(NSInteger);
@end

@implementation ARSleepGridMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BaseMenuBackgroundColor(self.style);
        
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _MainScreen_Width*0.8, _MainScreen_Height)];
        [bgView setImage:SY_IMAGE(@"pic_menubg")];
        [self addSubview:bgView];
        
        _itemTitles = [NSArray array];
        _items = [NSArray array];
        
        _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _contentScrollView.contentSize = _contentScrollView.bounds.size;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = YES;
        _contentScrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentScrollView];
        
        UIImageView *ghImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 32, 19, 20)];
        [ghImageView setImage:SY_IMAGE(@"pic_guohui")];
        [_contentScrollView addSubview:ghImageView];
        
        UILabel *ptLabel = [[UILabel alloc] initWithFrame:CGRectMake(43, 33, 200, 20)];
        ptLabel.font = [UIFont systemFontOfSize:18.f];
        ptLabel.text = @"引航站协同办公平台";
        ptLabel.textColor = [UIColor whiteColor];
        [_contentScrollView addSubview:ptLabel];
        
        UILabel *xtLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 72, 200, 18)];
        xtLabel.font = [UIFont systemFontOfSize:14];
        xtLabel.text = @"系统设置";
        xtLabel.textColor = [UIColor whiteColor];
        [_contentScrollView addSubview:xtLabel];
        
        UILabel *bqLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, _MainScreen_Height-49, _MainScreen_Width*0.8-16, 16)];
        bqLabel.font = [UIFont systemFontOfSize:12];
        bqLabel.text = @"版权所有：日照至信信息科技有限公司";
        bqLabel.textAlignment = NSTextAlignmentCenter;
        bqLabel.textColor = [UIColor whiteColor];
        [_contentScrollView addSubview:bqLabel];
        
        UILabel *crLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, _MainScreen_Height-29, _MainScreen_Width*0.8-16, 16)];
        crLabel.font = [UIFont systemFontOfSize:12];
        crLabel.text = @"Copyright 2011-2015 All Rights Reserved";
        crLabel.textColor = [UIColor whiteColor];
        crLabel.textAlignment = NSTextAlignmentCenter;
        [_contentScrollView addSubview:crLabel];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles itemIcons:(NSArray *)itemIcons
{
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        NSInteger count = itemTitles.count;
        _itemTitles = [itemTitles subarrayWithRange:NSMakeRange(0, count)];
        [self setupWithItemTitles:_itemTitles itemIcons:itemIcons];
    }
    return self;
}

- (void)setupWithItemTitles:(NSArray *)titles itemIcons:(NSArray *)icons{
    NSMutableArray *items = [NSMutableArray array];
    
    for (int i = 0; i < titles.count; i++) {
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 100 + i*44 +14, 18, 18)];
        [iconView setImage:SY_IMAGE(icons[i])];
        [_contentScrollView addSubview:iconView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 100 + i*44, _MainScreen_Width*0.8, 44)];
        titleLabel.font = [UIFont systemFontOfSize:15.f];
        titleLabel.text = titles[i];
        titleLabel.textColor = [UIColor whiteColor];
        [_contentScrollView addSubview:titleLabel];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 100 + i*44, _MainScreen_Width*0.8, 44);
        button.tag = i;
        [button addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:15.f];
        button.titleLabel.textAlignment = NSTextAlignmentLeft;
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button setTitle:@"" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [items addObject:button];
        [_contentScrollView addSubview:button];
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100 + i*44 +42, _MainScreen_Width*0.8, 2)];
        [lineView setImage:SY_IMAGE(@"pic_line3")];
        [_contentScrollView addSubview:lineView];
    }
    _items = [NSArray arrayWithArray:items];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentScrollView.frame = (CGRect){CGPointMake(0, 42), self.contentScrollView.bounds.size};
    self.contentScrollView.frame = CGRectMake(0, 0, _MainScreen_Width*0.8, _MainScreen_Height);
    self.contentScrollView.contentSize = CGSizeMake(_MainScreen_Width*0.8, _MainScreen_Height);
    
    self.bounds = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, self.contentScrollView.bounds.size.height)};
}

#pragma mark -

- (void)triggerSelectedAction:(void (^)(NSInteger))actionHandle
{
    self.actionHandle = actionHandle;
}

#pragma mark -

- (void)tapAction:(id)sender
{
    if (self.actionHandle) {
            double delayInSeconds = 0.15;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.actionHandle([(UIButton *)sender tag] + 1);
            });
    }
}

@end
