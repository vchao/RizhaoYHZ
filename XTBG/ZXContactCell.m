//
//  ZXContactCell.m
//  XTBG
//
//  Created by vchao on 15/1/18.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import "ZXContactCell.h"

@implementation ZXContactCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //名字
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(32, 8, 200, 25)];
        _nameLabel.backgroundColor  = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameLabel];
        
        _selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_MainScreen_Width-40, 11, 18, 18)];
        [self.contentView addSubview:_selectImageView];
        
        //分割线
        UIView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(32, 39, _MainScreen_Width-32, 1)];
        [lineView setBackgroundColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:lineView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

@end
