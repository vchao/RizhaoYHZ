//
//  ZXSendFileViewController.h
//  XTBG
//
//  Created by vchao on 15/9/25.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXSendFileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
    IBOutlet UITableView *fileTableView;
    IBOutlet UISegmentedControl *segmentedControl;
    IBOutlet UISearchBar *searchBar;
    
    NSArray *doArray;
    NSArray *listArray;
    NSMutableArray *searchArray;
    
    NSMutableDictionary *openInfo;
    NSString *liuchengID;
}

@end
