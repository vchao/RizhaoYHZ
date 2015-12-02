//
//  ButtomScrollView.m
//  test4101
//
//  Created by silicon on 14-4-10.
//  Copyright (c) 2014年 silicon. All rights reserved.
//

#import "ButtomScrollView.h"
#import "TopScrollView.h"
#import "AppDelegate.h"

@implementation ButtomScrollView
@synthesize viewNameArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
        self.backgroundColor = [UIColor lightGrayColor];
        self.pagingEnabled = YES;
        self.userInteractionEnabled = YES;
        self.bounces = NO;
    
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        userContentOffsetX = 0;
    }
    return self;
}

+ (ButtomScrollView *)getInstance{
    static ButtomScrollView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithFrame:CGRectMake(0, 108, _MainScreen_Width, _MainScreen_Height-108-49)];
    });
    return instance;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    userContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(userContentOffsetX < scrollView.contentOffset.x){
        isLeftScroll = YES;
    }else{
        isLeftScroll = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self adjustTopScrollViewButton:scrollView];
    [self loadData];
}

//调整按钮显示
- (void)adjustTopScrollViewButton:(UIScrollView *)scrollView{
    [[TopScrollView getInstance] setButttonUnSelect];
    [TopScrollView getInstance].scrollViewSelectedID = (scrollView.contentOffset.x/_MainScreen_Width) + 100;
    [[TopScrollView getInstance] setButtonSelect];
    [[TopScrollView getInstance] setScrollViewContentOffset];
}

- (void)initWithViews{
    for(int i = 0; i < [viewNameArray count]; i++){
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, _MainScreen_Height-108-49)];
        tableView.tag = (200+i);
        [self addSubview:tableView];
    }
    
    self.contentSize = CGSizeMake(_MainScreen_Width*[viewNameArray count], self.frame.size.height - 44);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self loadData];
}

- (void)loadData{
    CGFloat pageWidth = self.frame.size.width;
    int page = floor((self.contentOffset.x - pageWidth/viewNameArray.count)/pageWidth) + 1;
    UILabel *label = (UILabel *)[self viewWithTag:page + 200];
    label.text = [NSString stringWithFormat:@"%@", [viewNameArray objectAtIndex:page]];
}





@end
