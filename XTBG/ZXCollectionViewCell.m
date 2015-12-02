//
//  ZXCollectionViewCell.m
//  XTBG
//
//  Created by vchao on 14/11/13.
//  Copyright (c) 2014年 rzzx. All rights reserved.
//

#import "ZXCollectionViewCell.h"

@implementation ZXCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initWithDictionary:(NSDictionary *)cellDictionary count:(NSInteger)count{
    logoImageView.image = [UIImage imageNamed:[cellDictionary objectForKey:@"logo"]];
    titleLabel.text = [cellDictionary objectForKey:@"title"];
    countLabel.layer.cornerRadius = 8;
    countLabel.layer.masksToBounds = YES;
    if (count > 0) {
        countLabel.hidden = NO;
        countLabel.text = [NSString stringWithFormat:@"%ld",count];
    }else{
        countLabel.hidden = YES;
    }
}

@end
