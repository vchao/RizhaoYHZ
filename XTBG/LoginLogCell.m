//
//  LoginLogCell.m
//  XTBG
//
//  Created by vchao on 15/1/28.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import "LoginLogCell.h"

@implementation LoginLogCell

- (void)initWithDictionary:(NSDictionary *)cellDictionary {
    NSString *cont = [cellDictionary objectForKey:@"uid"];
    nameLabel.text = cont;
    
    ipLabel.text = [cellDictionary objectForKey:@"login_ip"];
    
    loginTimeLabel.text = [cellDictionary objectForKey:@"in_time"];
    
    logoutTimeLabel.text = [cellDictionary objectForKey:@"out_time"];
    
    onlineTimeLabel.text = [cellDictionary objectForKey:@"long"];
//    NSString *beizhu = [cellDictionary objectForKey:@"beizhu"];
//    if (beizhu) {
    introLabel.text = @"";
//    }
}

@end
