//
//  ZXSendMsgViewController.h
//  XTBG
//
//  Created by vchao on 15/1/18.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXSendMsgViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>{
    UITextView *msgTextView;
    UILabel    *textLabel;
    IBOutlet UITableView *contactsTableView;
    IBOutlet UIButton *sendBtn;
    IBOutlet UIButton *cancelBtn;
    
    NSMutableDictionary *dic;//存对应的数据
    NSMutableArray *selectedArr;//二级列表是否展开状态
    NSMutableArray *titleDataArray;
    NSArray *dataArray;//数据源，显示每个cell的数据
    NSMutableArray *grouparr0;
    NSMutableArray *grouparr1;
    NSMutableArray *grouparr2;
    NSMutableArray *grouparr3;
    
    NSMutableArray *selectedArray;
}

@end
