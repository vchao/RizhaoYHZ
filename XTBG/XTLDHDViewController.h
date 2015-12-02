//
//  XTLDHDViewController.h
//  XTBG
//
//  Created by vchao on 15/1/11.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTLDHDViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *hdTableView;
    NSArray *hdArray;
}

@end
