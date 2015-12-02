//
//  ARSleepGridMenu.h
//  AnyRadio
//
//  Created by 任维超 on 14-8-21.
//  Copyright (c) 2014年 AnyRadio.CN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARSleepBaseMenu.h"

@interface ARSleepGridMenu : ARSleepBaseMenu

- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles itemIcons:(NSArray *)itemIcons;

- (void)triggerSelectedAction:(void(^)(NSInteger))actionHandle;

@end
