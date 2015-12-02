//
//  LDHDCell.m
//  XTBG
//
//  Created by vchao on 15/1/11.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import "LDHDCell.h"

@implementation LDHDCell

- (void)initWithDictionary:(NSDictionary *)cellDictionary {
    NSString *cont = [cellDictionary objectForKey:@"cont"];
    cont = [cont stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    contentLabel.text = cont;
    ldUserLabel.text = [cellDictionary objectForKey:@"name"];
    timeLabel.text = [cellDictionary objectForKey:@"time"];
    
    CGSize constraint = CGSizeMake(_MainScreen_Width-26, 200);
    CGSize size = [cont sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping];
    contentHeightConstraint.constant = size.height;
}

@end
