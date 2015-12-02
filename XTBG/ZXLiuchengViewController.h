//
//  ZXLiuchengViewController.h
//  XTBG
//
//  Created by vchao on 15/1/30.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXLiuchengViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    __weak IBOutlet UITableView *lcTableView;
    
    NSArray *lcArray;
    NSString *lcID;
    NSString *lcType;
}

@property (nonatomic, copy) NSString *lcID;
@property (nonatomic, copy) NSString *lcType;

@end
