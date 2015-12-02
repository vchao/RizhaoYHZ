//
//  ZXMailDetailViewController.h
//  XTBG
//
//  Created by vchao on 15/1/18.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXMailDetailViewController : UIViewController <UIWebViewDelegate>{
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *senderLabel;
    IBOutlet UILabel *revicerLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UIWebView *contentWeb;
    
    IBOutlet UIButton *replayBtn;
    IBOutlet UIButton *zhuanfaBtn;
    IBOutlet UIButton *zhuanfaBtn2;
    
    IBOutlet NSLayoutConstraint *zhuanfaWidthConstraint;
    IBOutlet NSLayoutConstraint *zhuanfaLeftConstraint;
    
    NSDictionary *infoDictionary;
    
    BOOL isLoaded;
    
    NSMutableDictionary *detailDict;
}

@property (nonatomic, copy) NSDictionary *infoDictionary;

@end
