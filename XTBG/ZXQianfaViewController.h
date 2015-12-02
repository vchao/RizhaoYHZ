//
//  ZXQianfaViewController.h
//  XTBG
//
//  Created by vchao on 15/9/25.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXQianfaViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate> {
    __weak IBOutlet UITableView *infoTableView;
    
    NSDictionary *infoDictionary;
    NSDictionary *shenpiDoDict;
    
    NSArray      *qianfaLeaderArray;//签发领导
    NSArray      *huiqianLeaderArray;//会签领导array
    
    UIButton *yesBtn;
    UIButton *noBtn;
    UITextView *fkTextView;
    UILabel  *textLabel;
    
    UIButton *submitBtn;
    UIButton *cancelBtn;
    
    NSInteger tableRows;
    
    NSMutableArray *selectedQFArray;//选中的签发领导ID
    NSMutableArray *selectedHQArray;//选中的会签领导ID
}

@property (nonatomic, copy) NSDictionary *infoDictionary;

@end
