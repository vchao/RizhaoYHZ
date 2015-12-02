//
//  ARSleepBaseMenu.h
//  AnyRadio
//
//  Created by 任维超 on 14-8-21.
//  Copyright (c) 2014年 AnyRadio.CN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARSleepActionView.h"

#define BaseMenuBackgroundColor(style)  (style == SleepActionViewStyleLight ? [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0] : [UIColor colorWithWhite:0.2 alpha:1.0])
#define BaseMenuTextColor(style)        (style == SleepActionViewStyleLight ? [UIColor darkGrayColor] : [UIColor lightTextColor])
#define BaseMenuActionTextColor(style)  ([UIColor darkGrayColor])

@interface SLButton : UIButton
@end

@interface ARSleepBaseMenu : UIView{
    ARSleepActionViewStyle _style;
}

// if rounded top left/right corner, default is YES.
@property (nonatomic, assign) BOOL roundedCorner;

@property (nonatomic, assign) ARSleepActionViewStyle style;

@end
