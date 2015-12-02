//
//  MenuListViewController.h
//  XTBG
//
//  Created by vchao on 15/1/10.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRevealControllerProperty.h"

@interface MenuListViewController : UIViewController<IRevealControllerProperty, UITableViewDataSource, UITableViewDelegate>

#pragma mark - property



#pragma mark - method


#pragma mark - outlets
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;

@end
