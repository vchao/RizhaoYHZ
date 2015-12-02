//
//  ZXSecondViewController.h
//  XTBG
//
//  Created by vchao on 15/1/29.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXSecondViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
    IBOutlet UITableView *workTableView;
    IBOutlet UISegmentedControl *segmentedControl;
    IBOutlet UISearchBar *searchBar;
    
    NSArray *doArray;
    NSArray *listArray;
    NSMutableArray *searchArray;
    
    NSMutableDictionary *openInfo;
    NSString *liuchengID;
}

@end
