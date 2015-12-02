//
//  ZXHandleLogViewController.h
//  XTBG
//
//  Created by vchao on 15/1/28.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXHandleLogViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
    __weak IBOutlet UITableView *logTableView;
    __weak IBOutlet UISearchBar *searchBar;
    
    NSArray *logArray;
    NSMutableArray *searchArray;
}

@end
