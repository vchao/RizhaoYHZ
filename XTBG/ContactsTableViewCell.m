//
//  ContactsTableViewCell.m
//  XTBG
//
//  Created by vchao on 14/11/17.
//  Copyright (c) 2014年 rzzx. All rights reserved.
//

#import "ContactsTableViewCell.h"

@implementation ContactsTableViewCell
@synthesize titleLabel;
- (void)dealloc
{
    self.titleLabel = nil;
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

@end
