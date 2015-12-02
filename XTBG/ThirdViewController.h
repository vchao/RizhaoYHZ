//
//  ThirdViewController.h
//  XTBG
//
//  Created by vchao on 14/11/19.
//  Copyright (c) 2014年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
    IBOutlet UITableView *mailTableView;
    IBOutlet UISegmentedControl *segmentedControl;
    IBOutlet UISearchBar *searchBar;
    
    NSArray *shouArray;
    NSArray *faArray;
    NSMutableArray *searchArray;
    
    NSMutableDictionary *openInfo;
}

@end
