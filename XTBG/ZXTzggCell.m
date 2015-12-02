//
//  ZXTzggCell.m
//  XTBG
//
//  Created by vchao on 15/1/17.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import "ZXTzggCell.h"

@implementation ZXTzggCell

- (void)initWithDictionary:(NSDictionary *)cellDictionary {
    NSString *cont = [cellDictionary objectForKey:@"title"];
    cont = [cont stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    titleLabel.text = cont;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSInteger t = [[cellDictionary objectForKey:@"addtime"] integerValue];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:t];
    timeLabel.text = [formatter stringFromDate:confromTimesp];
}

@end
