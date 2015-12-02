//
//  TopScrollView.m
//  test4101
//
//  Created by silicon on 14-4-10.
//  Copyright (c) 2014年 silicon. All rights reserved.
//

#import "TopScrollView.h"
#import "ButtomScrollView.h"
#import "AppDelegate.h"

@implementation TopScrollView
@synthesize titleArray;
@synthesize userSelectedButtonTag;
@synthesize scrollViewSelectedID;
@synthesize buttonOrignXArray;
@synthesize buttonWithArray;

+ (TopScrollView *)getInstance{
    static TopScrollView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithFrame:CGRectMake(0, 64, _MainScreen_Width, 44)];
    });
    return instance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        userSelectedButtonTag = 100;
        scrollViewSelectedID = 100;
        
        self.buttonOrignXArray = [[NSMutableArray alloc] init];
        self.buttonWithArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)initWithTitleButtons{
    
    float xPos = 5.0f;
    for(int i = 0; i < [self.titleArray count]; i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = [self.titleArray objectAtIndex:i];
        [button setTag:i + 100];
        if(i == 0){
            button.selected = YES;
        }
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
        
        int buttonWidth = [title sizeWithFont:button.titleLabel.font
                            constrainedToSize:CGSizeMake(150, 30)
                                lineBreakMode:NSLineBreakByClipping].width;
    
        button.frame = CGRectMake(xPos, 9, buttonWidth + BUTTONGAP, 30);
        [buttonOrignXArray addObject:@(xPos)];
        //按钮的X坐标
        xPos += buttonWidth + BUTTONGAP;
        //按钮的宽度
        [self.buttonWithArray addObject:@(button.frame.size.width)];
        [self addSubview:button];
    }
    //视图的位移
    self.contentSize = CGSizeMake(xPos, 44);
    shadowImage = [[UIImageView alloc] initWithFrame:CGRectMake(BUTTONGAP, 0,
                                                                [[self.buttonWithArray objectAtIndex:0] floatValue],
                                                                44)];
    [shadowImage setImage:[UIImage imageNamed:@"red_line_and_shadow"]];
    [self addSubview:shadowImage];
}

- (void)selectNameButton:(UIButton *)sender{
    [self adjustScrollViewContentX:sender];
    
    //如果跟换按钮
    if(sender.tag != userSelectedButtonTag){
        UIButton *mybutton = (UIButton *)[self viewWithTag:userSelectedButtonTag];
        mybutton.selected = NO;
        userSelectedButtonTag = sender.tag;
    }
    //按钮选中状态
    if(!sender.selected){
        sender.selected = YES;
        [UIView animateWithDuration:0.25 animations:^{
            [shadowImage setFrame:CGRectMake(sender.frame.origin.x,
                                             0,
                                             [[self.buttonWithArray objectAtIndex:sender.tag - 100] floatValue],
                                             44)];
        } completion:^(BOOL finished) {
            if(finished){
                //页面出现
                [[ButtomScrollView getInstance] setContentOffset:CGPointMake((sender.tag - 100) * _MainScreen_Width, 0) animated:YES];
                //滑动选择页面
                scrollViewSelectedID = sender.tag;
            }
        }];
    }
}

//调整滚动按钮显示
- (void)adjustScrollViewContentX:(UIButton *)sender{
    float originX = [[self.buttonOrignXArray objectAtIndex:(sender.tag - 100)] floatValue];
    float width = [[self.buttonWithArray objectAtIndex:(sender.tag - 100)] floatValue];

    if((sender.frame.origin.x - self.contentOffset.x) > (_MainScreen_Width - (BUTTONGAP + width))){
        [self setContentOffset:CGPointMake(originX - (_MainScreen_Width - width), 0) animated:YES];
    }
    
    if((sender.frame.origin.x - self.contentOffset.x) < 5){
        [self setContentOffset:CGPointMake(originX, 0) animated:YES];
    }
}

- (void)setButttonUnSelect{
    UIButton *button = (UIButton *)[self viewWithTag:scrollViewSelectedID];
    button.selected = NO;
}

- (void)setButtonSelect{
    //选中滑动的按钮
    UIButton *button = (UIButton *)[self viewWithTag:scrollViewSelectedID];
    [UIView animateWithDuration:0.25 animations:^{
        [shadowImage setFrame:CGRectMake(button.frame.origin.x, 0,
                                         [[self.buttonWithArray objectAtIndex:button.tag - 100] floatValue],
                                         44)];
    } completion:^(BOOL finished) {
        if(finished){
            if(!button){
                button.selected = YES;
                userSelectedButtonTag = button.tag;
            }
        }
    }];
}

- (void)setScrollViewContentOffset{
    float originX = [[self.buttonOrignXArray objectAtIndex:(scrollViewSelectedID - 100)] floatValue];
    float width = [[self.buttonWithArray objectAtIndex:(scrollViewSelectedID - 100)] floatValue];
    
    if((originX - self.contentOffset.x) > (_MainScreen_Width - (BUTTONGAP + width))){
//        [self setContentOffset:CGPointMake(originX- 30, 0) animated:YES];
        [self setContentOffset:CGPointMake(originX- (_MainScreen_Width - width), 0) animated:YES];
    }
    
    if(originX - self.contentOffset.x < 5){
        [self setContentOffset:CGPointMake(originX, 0) animated:YES];
    }
}

@end



















