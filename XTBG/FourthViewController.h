//
//  FourthViewController.h
//  XTBG
//
//  Created by vchao on 15/1/17.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXTzggCell.h"

@interface FourthViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
    IBOutlet UITableView *tzTableView;
    IBOutlet UISearchBar *searchBar;
    
    NSArray *tzArray;
    NSMutableArray *searchArray;
    
    NSDictionary *openInfo;
}

@end
