//
//  HandleLogCell.h
//  XTBG
//
//  Created by vchao on 15/1/28.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@interface HandleLogCell : UITableViewCell {
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *ipLabel;
    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UIWebView *contentWeb;
}

- (void)initWithDictionary:(NSDictionary *)cellDictionary ;

@end
