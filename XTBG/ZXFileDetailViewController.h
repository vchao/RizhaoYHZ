//
//  ZXFileDetailViewController.h
//  XTBG
//
//  Created by vchao on 15/9/25.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXFileDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate> {
    __weak IBOutlet UITableView *infoTableView;
    __weak IBOutlet UIButton    *qianfaBtn;
    
    __weak IBOutlet NSLayoutConstraint *tableButtonConstraint;
    
    NSDictionary *infoDictionary;
    NSDictionary *contentDict;
    
    BOOL isLoaded;
}

@property (nonatomic, copy) NSDictionary *infoDictionary;

@end
