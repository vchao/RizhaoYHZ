//
//  TopScrollView.h
//  test4101
//
//  Created by silicon on 14-4-10.
//  Copyright (c) 2014年 silicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopScrollView : UIScrollView <UIScrollViewDelegate>{
    NSArray *titleArray;
    NSInteger userSelectedButtonTag;
    NSInteger scrollViewSelectedID;
    UIImageView *shadowImage;
}

@property (nonatomic, retain) NSArray *titleArray;

@property (nonatomic, retain) NSMutableArray *buttonWithArray;

@property (nonatomic, retain) NSMutableArray *buttonOrignXArray;

@property (assign) NSInteger scrollViewSelectedID;

@property (assign) NSInteger userSelectedButtonTag;


+ (TopScrollView *)getInstance;

//加载顶部标题
- (void)initWithTitleButtons;

- (void)setButttonUnSelect;

- (void)setButtonSelect;

- (void)setScrollViewContentOffset;

@end
