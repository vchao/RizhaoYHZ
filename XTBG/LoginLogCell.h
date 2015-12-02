//
//  LoginLogCell.h
//  XTBG
//
//  Created by vchao on 15/1/28.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginLogCell : UITableViewCell {
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *ipLabel;
    __weak IBOutlet UILabel *loginTimeLabel;
    __weak IBOutlet UILabel *logoutTimeLabel;
    __weak IBOutlet UILabel *onlineTimeLabel;
    __weak IBOutlet UILabel *introLabel;
}

- (void)initWithDictionary:(NSDictionary *)cellDictionary ;

@end
