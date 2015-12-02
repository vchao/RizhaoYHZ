//
//  AppDelegate.m
//  XTBG
//
//  Created by vchao on 14/11/11.
//  Copyright (c) 2014年 rzzx. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuListViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //未登录
//    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
//    self.window.rootViewController=[storyBoard instantiateInitialViewController];
    //已登陆
//    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    self.window.rootViewController=[storyBoard instantiateInitialViewController];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], UITextAttributeTextColor,
                                                          nil]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)gotoMainWindow
{
    //登录成功，进入主视图
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // 获取菜单页面.
//    MenuListViewController* menuVc = [storyBoard instantiateViewControllerWithIdentifier:@"MenuListViewController"];
//    NSLog(@"instantiateViewControllerWithIdentifier: %@", menuVc);
//    if (nil==menuVc) return;
//    
//    // 模态弹出侧开菜单控制器.
//    if (YES) {
//        //UIColor *bgColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
//        UIColor *bgColor = [UIColor whiteColor];
//        GHRevealViewController* revealController = [[GHRevealViewController alloc] initWithNibName:nil bundle:nil];
//        revealController.view.backgroundColor = bgColor;
//        
//        // 绑定.
//        menuVc.revealController = revealController;
//        revealController.sidebarViewController = menuVc;
//        
////        // show.
//        revealController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;	// 淡入淡出.
////        [self presentModalViewController:revealController animated:YES];
//    }
    self.window.rootViewController=[storyBoard instantiateInitialViewController];
}

@end
