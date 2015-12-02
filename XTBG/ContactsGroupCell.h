//
//  ContactsGroupCell.h
//  XTBG
//
//  Created by vchao on 14/11/17.
//  Copyright (c) 2014年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ContactsGroupCell : UITableViewCell{
    __weak IBOutlet NSLayoutConstraint *arrowLeftConstraint;
    __weak IBOutlet NSLayoutConstraint *titleWidthConstraint;
}

@property (nonatomic,retain)IBOutlet UILabel *titleLabel;
@property (nonatomic,retain)IBOutlet UILabel *countLabel;
@property (nonatomic,retain)IBOutlet UIImageView *arrowImageView;

- (void)changeArrowWithUp:(BOOL)up;
- (void)changeLayout;

@end
