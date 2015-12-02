//
//  ZXWorkDetailViewController.h
//  XTBG
//
//  Created by vchao on 15/9/13.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXWorkDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate> {
    __weak IBOutlet UITableView *infoTableView;
    
    NSDictionary *infoDictionary;
    NSDictionary *contentDict;
    
    BOOL isLoaded;
}

@property (nonatomic, copy) NSDictionary *infoDictionary;

@end
