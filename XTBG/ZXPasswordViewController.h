//
//  ZXPasswordViewController.h
//  XTBG
//
//  Created by vchao on 15/1/28.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXPasswordViewController : UIViewController {
    __weak IBOutlet UITextField *oldPassField;
    __weak IBOutlet UITextField *newPassField;
    __weak IBOutlet UITextField *qrPassField;
    __weak IBOutlet UIButton    *submitBtn;
}

@end
