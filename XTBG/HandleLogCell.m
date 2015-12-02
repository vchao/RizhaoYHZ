//
//  HandleLogCell.m
//  XTBG
//
//  Created by vchao on 15/1/28.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import "HandleLogCell.h"

@implementation HandleLogCell

- (void)initWithDictionary:(NSDictionary *)cellDictionary {
    NSString *cont = [cellDictionary objectForKey:@"uid"];
    nameLabel.text = cont;
    
    ipLabel.text = [cellDictionary objectForKey:@"ip"];
    
    NSString *handle = [cellDictionary objectForKey:@"handle"];
    handle = [NSString stringWithFormat:@"%@%@%@",@"<span style=\"font-size:12px\">",handle,@"</span>"];
//    handle = [handle stringByReplacingOccurrencesOfString:@"<span " withString:@"<span style=\"font-size:12px\" "];
//    handle = [handle stringByReplacingOccurrencesOfString:@"</span>" withString:@"</font>"];
//    handle = [handle stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
//    contentLabel.text = handle;
    [contentWeb loadHTMLString:handle baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
    
    timeLabel.text = [cellDictionary objectForKey:@"addtime"];
}

@end
