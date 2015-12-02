//
//  ZXTzggCell.h
//  XTBG
//
//  Created by vchao on 15/1/17.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXTzggCell : UITableViewCell {
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *timeLabel;
}

- (void)initWithDictionary:(NSDictionary *)cellDictionary;

@end
