//
//  LDHDCell.h
//  XTBG
//
//  Created by vchao on 15/1/11.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDHDCell : UITableViewCell{
    IBOutlet UILabel *contentLabel;
    IBOutlet UILabel *ldUserLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet NSLayoutConstraint *contentHeightConstraint;
}

- (void)initWithDictionary:(NSDictionary *)cellDictionary;

@end
