//
//  ZXSendMailViewController.h
//  XTBG
//
//  Created by vchao on 15/1/24.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXSendMailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIWebViewDelegate> {
    IBOutlet UITextField *revicerField;
    IBOutlet UIButton    *selectRevBtn;
    IBOutlet UITextField *titleField;
    IBOutlet UITextView  *contentView;
    IBOutlet UITextField *fileField;
    IBOutlet UIButton    *selectFileBtn;
    IBOutlet UIButton    *sendMsgBtn;
    IBOutlet UIButton    *sendBtn;
    IBOutlet UIButton    *delFileBtn;
    UIWebView *fjWebView;
    
    UITableView *personTableView;
    
    BOOL sendMsg;
    
    NSMutableDictionary *dic;//存对应的数据
    NSMutableArray *selectedArr;//二级列表是否展开状态
    NSMutableArray *titleDataArray;
    NSArray *dataArray;//数据源，显示每个cell的数据
    NSMutableArray *grouparr0;
    NSMutableArray *grouparr1;
    NSMutableArray *grouparr2;
    NSMutableArray *grouparr3;
    
    NSMutableArray *selectedArray;
    
    NSString *uploadFileName;
    
    NSDictionary *infoDictionary;
    
    NSString *zfFileId;
    
    BOOL isLoaded;
    IBOutlet NSLayoutConstraint *fjTopConstraint;
}

@property (nonatomic, copy) NSDictionary *infoDictionary;

@end
