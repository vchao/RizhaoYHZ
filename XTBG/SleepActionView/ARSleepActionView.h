//
//  ARSleepActionView.h
//  AnyRadio
//
//  Created by 任维超 on 14-8-21.
//  Copyright (c) 2014年 AnyRadio.CN. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  弹出框样式
 */
typedef NS_ENUM(NSInteger, ARSleepActionViewStyle){
    SleepActionViewStyleLight = 0,     // 浅色背景，深色字体
    SleepActionViewStyleDark           // 深色背景，浅色字体
};

typedef void(^SGMenuActionHandler)(NSInteger index);

@interface ARSleepActionView : UIView

/**
 *  弹出框样式
 */
@property (nonatomic, assign) ARSleepActionViewStyle style;

/**
 *  获取单例
 */
+ (ARSleepActionView *)sleepActionView;

/**
 *	服务网格弹出层
 *
 *	@param 	title       标题
 *	@param 	itemTitles 	元素标题
 *	@param 	handler 	回调，元素index从 1 开始，0 为取消。
 */
+ (void)showGridMenuWithTitle:(NSString *)title
                   itemTitles:(NSArray *)itemTitles
                    itemIcons:(NSArray *)itemIcons
               selectedHandle:(SGMenuActionHandler)handler;

+ (void)showSleepMenu:(NSDictionary *)dictionary info:(NSDictionary *)infoDictionary viewController:(UIViewController *)vc;

@end
