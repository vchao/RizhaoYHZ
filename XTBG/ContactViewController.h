//
//  ContactViewController.h
//  XTBG
//
//  Created by vchao on 14/11/17.
//  Copyright (c) 2014年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsGroupCell.h"
#import "ContactsTableViewCell.h"

@interface ContactViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataList;
    
}
@property (assign)BOOL isOpen;
@property (nonatomic,retain)NSIndexPath *selectIndex;

@property (nonatomic,retain)IBOutlet UITableView *contactsTableView;

@end
