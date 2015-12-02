//
//  SendFileCell.h
//  XTBG
//
//  Created by vchao on 15/9/25.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendFileCell : UITableViewCell {
    IBOutlet UILabel *contentLabel;
    IBOutlet UILabel *userLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UIButton *liuchengBtn;
}

@property (nonatomic, retain) UIButton *liuchengBtn;

- (void)initWithDictionary:(NSDictionary *)cellDictionary;

@end
