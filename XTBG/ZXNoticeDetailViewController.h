//
//  ZXNoticeDetailViewController.h
//  XTBG
//
//  Created by vchao on 15/1/17.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXNoticeDetailViewController : UIViewController {
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UIWebView *contentWeb;
    
    IBOutlet NSLayoutConstraint *titleHeightConstraint;
    
    NSDictionary *infoDictionary;
}

@property (nonatomic, copy) NSDictionary *infoDictionary;

@end
