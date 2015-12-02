//
//  ARSleepBaseMenu.m
//  AnyRadio
//
//  Created by 任维超 on 14-8-21.
//  Copyright (c) 2014年 AnyRadio.CN. All rights reserved.
//

#import "ARSleepBaseMenu.h"

@implementation SLButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.backgroundColor = [UIColor lightGrayColor];
    }else{
        double delayInSeconds = 0.2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.backgroundColor = [UIColor clearColor];
        });
    }
}

@end

@implementation ARSleepBaseMenu
@synthesize style = _style;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _style = SleepActionViewStyleLight;
    }
    return self;
}

@end
