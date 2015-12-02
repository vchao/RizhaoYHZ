//
//  SendFileCell.m
//  XTBG
//
//  Created by vchao on 15/9/25.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import "SendFileCell.h"

@implementation SendFileCell

@synthesize liuchengBtn;

- (void)initWithDictionary:(NSDictionary *)cellDictionary {
    NSString *cont = [cellDictionary objectForKey:@"title"];
    cont = [cont stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    contentLabel.text = cont;
    
    userLabel.text = [cellDictionary objectForKey:@"adduser"];
    
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    NSInteger t = [[cellDictionary objectForKey:@"addtime"] integerValue];
//    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:t];
    timeLabel.text = [cellDictionary objectForKey:@"fwtime"];
    
    UIImage *loginBg = SY_IMAGE(@"pic_btn_normal_gray");
    UIEdgeInsets logininsets = UIEdgeInsetsMake(5, 5, 5, 5);
    loginBg = [loginBg resizableImageWithCapInsets:logininsets];
    [liuchengBtn setBackgroundImage:loginBg forState:UIControlStateNormal];
    [liuchengBtn setBackgroundImage:[SY_IMAGE(@"pic_btn_pressed_gray") resizableImageWithCapInsets:logininsets] forState:UIControlStateHighlighted];
    liuchengBtn.tag = [[cellDictionary objectForKey:@"id"] integerValue];
}

@end
