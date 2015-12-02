//
//  IRevealControllerProperty.h
//  XTBG
//
//  Created by vchao on 15/1/10.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GHRevealViewController.h"

/// 具有revealController(侧开菜单控制器)属性的接口.
@protocol IRevealControllerProperty <NSObject>

#pragma mark - property
@required

/// 侧开菜单控制器.
@property (nonatomic,weak) GHRevealViewController* revealController;



#pragma mark - method

@end