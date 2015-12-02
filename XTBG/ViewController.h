//
//  ViewController.h
//  XTBG
//
//  Created by vchao on 14/11/11.
//  Copyright (c) 2014年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface ViewController : UIViewController{
    __weak IBOutlet UIImageView *inputBgView;
    __weak IBOutlet UITextField *usernameField;
    __weak IBOutlet UITextField *passField;
    __weak IBOutlet UIButton *remPassBtn;
    __weak IBOutlet UIButton *loginBtn;
    __weak IBOutlet NSLayoutConstraint *loginLeftConstraint;
    __weak IBOutlet NSLayoutConstraint *logoLeftConstraint;
}

@end

