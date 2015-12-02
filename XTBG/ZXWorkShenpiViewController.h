//
//  ZXWorkShenpiViewController.h
//  XTBG
//
//  Created by vchao on 15/1/31.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXWorkShenpiViewController : UIViewController{
    __weak IBOutlet UIScrollView *contentScrollView;
    
    UITextView *pishiView;
    UILabel    *pishiLabel;
    UILabel    *caozuoLabel;
    UIButton   *passBtn;
    UIButton   *unPassBtn;
    UILabel    *spUserLabel;
    UILabel    *userLabel;
    
    UIButton   *submitBtn;
    
    NSDictionary *infoDictionary;
    NSDictionary *contentDict;
}

@property (nonatomic, copy) NSDictionary *infoDictionary;

@end
