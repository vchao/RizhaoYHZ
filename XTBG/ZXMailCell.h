//
//  ZXMailCell.h
//  XTBG
//
//  Created by vchao on 15/1/18.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXMailCell : UITableViewCell {
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *senderLabel;
    IBOutlet UILabel *timeLabel;
}

- (void)initWithDictionary:(NSDictionary *)cellDictionary;

@end
