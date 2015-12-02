//
//  LiuchengCell.h
//  XTBG
//
//  Created by vchao on 15/1/30.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiuchengCell : UITableViewCell {
    __weak IBOutlet UILabel *stepLabel;
    __weak IBOutlet UILabel *spUserLabel;
}

- (void)initWithDictionary:(NSDictionary *)cellDictionary;

@end
