//
//  ARSleepActionView.m
//  AnyRadio
//
//  Created by 任维超 on 14-8-21.
//  Copyright (c) 2014年 AnyRadio.CN. All rights reserved.
//

#import "ARSleepActionView.h"
#import "ARSleepBaseMenu.h"
#import "ARSleepGridMenu.h"
#import "AppDelegate.h"

@interface ARSleepActionView () <UIGestureRecognizerDelegate>{
    NSTimer *timer;
}
@property (nonatomic, strong) NSMutableArray *menus;
@property (nonatomic, strong) CAAnimation *showMenuAnimation;
@property (nonatomic, strong) CAAnimation *dismissMenuAnimation;
@property (nonatomic, strong) CAAnimation *dimingAnimation;
@property (nonatomic, strong) CAAnimation *lightingAnimation;
// 点击背景取消
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) ARSleepGridMenu *dismissMenu;
@end

@implementation ARSleepActionView

+ (ARSleepActionView *)sleepActionView
{
    static ARSleepActionView *actionView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect rect = [[UIScreen mainScreen] bounds];
        actionView = [[ARSleepActionView alloc] initWithFrame:rect];
    });
    
    return actionView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _menus = [NSMutableArray array];
        
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        _tapGesture.delegate = self;
        [self addGestureRecognizer:_tapGesture];
    }
    return self;
}

- (void)dealloc{
    [self removeGestureRecognizer:_tapGesture];
}

- (void)tapAction:(UITapGestureRecognizer *)tapGesture{
    CGPoint touchPoint = [tapGesture locationInView:self];
    ARSleepGridMenu *menu = self.menus.lastObject;
    if (!CGRectContainsPoint(menu.frame, touchPoint)) {
        [[ARSleepActionView sleepActionView] dismissMenu:menu Animated:YES];
        [self.menus removeObject:menu];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer isEqual:self.tapGesture]) {
        CGPoint p = [gestureRecognizer locationInView:self];
        ARSleepGridMenu *topMenu = self.menus.lastObject;
        if (CGRectContainsPoint(topMenu.frame, p)) {
            return NO;
        }
    }
    return YES;
}

#pragma mark -

- (void)setMenu:(UIView *)menu animation:(BOOL)animated{
    if (![self superview]) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self];
    }
    
    ARSleepBaseMenu *topMenu = (ARSleepBaseMenu *)menu;
    
    [self.menus makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.menus addObject:topMenu];
    
    topMenu.style = self.style;
    [self addSubview:topMenu];
    [topMenu layoutIfNeeded];
    topMenu.frame = (CGRect){CGPointMake(0, 0), topMenu.bounds.size};
    topMenu.frame = CGRectMake(0, 0, _MainScreen_Width*0.8, _MainScreen_Height);
    
    if (animated && self.menus.count == 1) {
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.4];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [self.layer addAnimation:self.dimingAnimation forKey:@"diming"];
        [topMenu.layer addAnimation:self.showMenuAnimation forKey:@"showMenu"];
        [CATransaction commit];
    }
}

- (void)dismissMenu:(ARSleepGridMenu *)menu Animated:(BOOL)animated
{
    if ([self superview]) {
        [self.menus removeObject:menu];
        if (animated && self.menus.count == 0) {
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.4];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            [CATransaction setCompletionBlock:^{
                [self removeFromSuperview];
                [menu removeFromSuperview];
            }];
            [self.layer addAnimation:self.lightingAnimation forKey:@"lighting"];
            [menu.layer addAnimation:self.dismissMenuAnimation forKey:@"dismissMenu"];
            [CATransaction commit];
        }else{
            [menu removeFromSuperview];
            
            ARSleepBaseMenu *topMenu = self.menus.lastObject;
            topMenu.style = self.style;
            [self addSubview:topMenu];
            [topMenu layoutIfNeeded];
            topMenu.frame = (CGRect){CGPointMake(0, self.bounds.size.height - topMenu.bounds.size.height), topMenu.bounds.size};
        }
    }
}

- (void)dismissMenuDelay:(ARSleepGridMenu *)menu Animated:(BOOL)animated
{
    if ([self superview]) {
            self.dismissMenu = menu;
            if (timer) {
                [timer invalidate];
                timer = nil;
            }
            timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(dismissMenu:) userInfo:nil repeats:NO];
    }
}

- (void)dismissMenu:(id)sender{
    [self.menus removeObject:self.dismissMenu];
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.3];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [CATransaction setCompletionBlock:^{
        [self removeFromSuperview];
        [self.dismissMenu removeFromSuperview];
    }];
    [self.layer addAnimation:self.lightingAnimation forKey:@"lighting"];
    [self.dismissMenu.layer addAnimation:self.dismissMenuAnimation forKey:@"dismissMenu"];
    [CATransaction commit];
}

#pragma mark -

- (CAAnimation *)dimingAnimation
{
    if (_dimingAnimation == nil) {
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        opacityAnimation.fromValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
        opacityAnimation.toValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.4] CGColor];
        [opacityAnimation setRemovedOnCompletion:NO];
        [opacityAnimation setFillMode:kCAFillModeBoth];
        _dimingAnimation = opacityAnimation;
    }
    return _dimingAnimation;
}

- (CAAnimation *)lightingAnimation
{
    if (_lightingAnimation == nil ) {
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        opacityAnimation.fromValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.4] CGColor];
        opacityAnimation.toValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
        [opacityAnimation setRemovedOnCompletion:NO];
        [opacityAnimation setFillMode:kCAFillModeBoth];
        _lightingAnimation = opacityAnimation;
    }
    return _lightingAnimation;
}

- (CAAnimation *)showMenuAnimation
{
    if (_showMenuAnimation == nil) {
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
        [positionAnimation setFromValue:[NSNumber numberWithFloat:-_MainScreen_Width]];
        [positionAnimation setToValue:[NSNumber numberWithFloat:0.0]];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation setFromValue:@0.0];
        [opacityAnimation setToValue:@1.0];
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        [group setAnimations:@[/*rotateAnimation,  scaleAnimation, opacityAnimation,*/ positionAnimation]];
        [group setRemovedOnCompletion:NO];
        [group setFillMode:kCAFillModeBoth];
        _showMenuAnimation = group;
    }
    return _showMenuAnimation;
}

- (CAAnimation *)dismissMenuAnimation
{
    if (_dismissMenuAnimation == nil) {
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
        [positionAnimation setFromValue:[NSNumber numberWithFloat:0.0]];
        [positionAnimation setToValue:[NSNumber numberWithFloat:-_MainScreen_Width]];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation setFromValue:@1.0];
        [opacityAnimation setToValue:@0.0];//透明度
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        [group setAnimations:@[/*rotateAnimation, scaleAnimation, opacityAnimation,*/ positionAnimation]];
        [group setRemovedOnCompletion:NO];
        [group setFillMode:kCAFillModeBoth];
        _dismissMenuAnimation = group;
    }
    return _dismissMenuAnimation;
}

+ (void)showGridMenuWithTitle:(NSString *)title
                   itemTitles:(NSArray *)itemTitles
                    itemIcons:(NSArray *)itemIcons
               selectedHandle:(SGMenuActionHandler)handler{
    ARSleepGridMenu *menu = [[ARSleepGridMenu alloc] initWithTitle:title
                                                        itemTitles:itemTitles
                                                         itemIcons:itemIcons];
    [menu triggerSelectedAction:^(NSInteger index){
        if (handler) {
            handler(index);
            [[ARSleepActionView sleepActionView] dismissMenu:menu Animated:YES];
        }else{//点击空白
            [[ARSleepActionView sleepActionView] dismissMenu:menu Animated:YES];
        }
    }];
    [[ARSleepActionView sleepActionView] setMenu:menu animation:YES];
}

+ (void)showSleepMenu:(NSDictionary *)dictionary info:(NSDictionary *)infoDictionary viewController:(UIViewController *)vc{
    NSArray *titles = @[@"登陆日志", @"操作日志", @"意见反馈", @"修改密码", @"退出登录" ];
    NSArray *icons = @[@"登陆日志", @"操作日志", @"意见反馈", @"修改密码", @"关于我们menu" ];
    [ARSleepActionView showGridMenuWithTitle:@"定时睡眠"
                                itemTitles:titles
                                 itemIcons:icons
                            selectedHandle:^(NSInteger index) {
                                switch (index) {
                                    case 1: {
                                        //登录日志
                                        [vc performSegueWithIdentifier:@"pushToLoginLog" sender:@"tapCell"];
                                        break;
                                    }
                                    case 2: {
                                        //操作日志
                                        [vc performSegueWithIdentifier:@"pushToHandleLog" sender:@"tapCell"];
                                        break;
                                    }
                                    case 3: {
                                        //意见反馈
                                        break;
                                    }
                                    case 4: {
                                        //修改密码
                                        [vc performSegueWithIdentifier:@"pushToPassword" sender:@"tapCell"];
                                        break;
                                    }
                                    case 5: {
                                        //关于我们
//                                        [vc performSegueWithIdentifier:@"pushToAbout" sender:@"tapCell"];
                                        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
                                        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                                        appDelegate.window.rootViewController = [storyBoard instantiateInitialViewController];
                                        break;
                                    }
//                                    case 6:{
//                                        //检查更新
//                                        NSNotificationCenter *noticeCenter = [NSNotificationCenter defaultCenter];
//                                        [noticeCenter postNotificationName:@"notificationCheckUpdate"
//                                                                    object:self
//                                                                  userInfo:nil];
//                                        break;
//                                    }
                                    default: {
                                        break;
                                    }
                                }
                            }];
}

#pragma mark - 导航

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *viewController = segue.destinationViewController;
    if ([sender isEqualToString:@"tapCell"]) {
        
    }
}

@end
