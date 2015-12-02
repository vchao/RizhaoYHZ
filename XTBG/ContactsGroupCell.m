//
//  ContactsGroupCell.m
//  XTBG
//
//  Created by vchao on 14/11/17.
//  Copyright (c) 2014年 rzzx. All rights reserved.
//

#import "ContactsGroupCell.h"

@implementation ContactsGroupCell

@synthesize titleLabel,arrowImageView;

- (void)dealloc
{
    self.titleLabel = nil;
    self.arrowImageView = nil;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)changeLayout{
    titleWidthConstraint.constant = _MainScreen_Width-40;
    arrowLeftConstraint.constant = _MainScreen_Width-38;
}

- (void)changeArrowWithUp:(BOOL)up
{
    if (up) {
        self.arrowImageView.image = [UIImage imageNamed:@"UpAccessory"];
    }else
    {
        self.arrowImageView.image = [UIImage imageNamed:@"DownAccessory"];
    }
}

@end
