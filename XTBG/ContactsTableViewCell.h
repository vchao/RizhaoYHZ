//
//  ContactsTableViewCell.h
//  XTBG
//
//  Created by vchao on 14/11/17.
//  Copyright (c) 2014年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsTableViewCell : UITableViewCell

@property (nonatomic,retain)IBOutlet UILabel *titleLabel;
@property (nonatomic,retain)IBOutlet UILabel *mobileLabel;
@property (nonatomic,retain)IBOutlet UILabel *officeTelLabel;
@property (nonatomic,retain)IBOutlet UIButton *msgBtn;
@property (nonatomic,retain)IBOutlet UIButton *callBtn;

@end
