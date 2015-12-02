//
//  ButtomScrollView.h
//  test4101
//
//  Created by silicon on 14-4-10.
//  Copyright (c) 2014年 silicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtomScrollView : UIScrollView<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *viewNameArray;
    CGFloat userContentOffsetX;
    BOOL isLeftScroll;
}

@property (nonatomic, retain) NSArray *viewNameArray;

+ (ButtomScrollView *)getInstance;

- (void)initWithViews;

- (void)loadData;


@end
