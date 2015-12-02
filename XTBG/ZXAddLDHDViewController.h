//
//  ZXAddLDHDViewController.h
//  XTBG
//
//  Created by vchao on 15/1/17.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface ZXAddLDHDViewController : UIViewController <UIActionSheetDelegate>{
    IBOutlet UITextField *timeField;
    IBOutlet UITextField *nameField;
    IBOutlet UITextView  *contentView;
    IBOutlet UIButton    *submitBtn;
    
    UIDatePicker *datePicker;
}

@end
