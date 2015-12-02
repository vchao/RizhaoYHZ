//
//  LiuchengCell.m
//  XTBG
//
//  Created by vchao on 15/1/30.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import "LiuchengCell.h"

@implementation LiuchengCell

- (void)initWithDictionary:(NSDictionary *)cellDictionary {
    NSString *cont = [cellDictionary objectForKey:@"showorder"];
    stepLabel.text = cont;
    
    spUserLabel.text = [cellDictionary objectForKey:@"title"];
    
}

@end
