//
//  MenuListViewController.m
//  XTBG
//
//  Created by vchao on 15/1/10.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import "MenuListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SideMenuUtil.h"
#import "MenuListCell.h"

#define kSidebarCellTextKey	@"CellText"
#define kSidebarCellImageKey	@"CellImage"

@interface MenuListViewController () {
    NSArray *_headers;	//!< 节头文本.
    NSArray *_cellInfos;	//!< 单元格信息.
    NSArray *_controllers;	//!< 导航控制器集.
}

@end

@implementation MenuListViewController

@synthesize revealController;

/// 构造函数.
- (id)init {
    // [UIStoryboard instantiateViewControllerWithIdentifier] 获取vc时, 似乎不会被调用构造函数.
    NSLog(@"init. By %@", self);
    self = [self initWithNibName:nil bundle:nil];
    return self;
}

/// 构造函数: 根据Nib名.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    // [UIStoryboard instantiateViewControllerWithIdentifier] 获取vc时, 似乎不会被调用构造函数.
    NSLog(@"initWithNibName: %@, %@ . By %@", nibNameOrNil, nibBundleOrNil, self);
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;	// 淡入淡出.
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"viewDidLoad. By %@", self);
    NSLog(@"revealController: %@. By %@", revealController, self);
    
    // 设置自身窗口尺寸
    self.view.frame = CGRectMake(0.0f, 0.0f, kGHRevealSidebarWidth, CGRectGetHeight(self.view.bounds));
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    // 绑定主页为内容视图（已废弃，仅用于调试）.
    if (YES) {
        UINavigationController* homeNC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
        NSLog(@"instantiateViewControllerWithIdentifier: %@", homeNC);
        [SideMenuUtil addNavigationGesture:homeNC revealController:revealController];
        //homeNC.revealController = revealController;
        [SideMenuUtil setRevealControllerProperty:homeNC revealController:revealController];
        revealController.contentViewController = homeNC;
    }
    //return;
    
    _headers = @[
                 [NSNull null]
                 ];
    _cellInfos = @[
                   @[
                       @{kSidebarCellImageKey: [UIImage imageNamed:@"登陆日志"], kSidebarCellTextKey: NSLocalizedString(@"登录日志", @"")},
                       @{kSidebarCellImageKey: [UIImage imageNamed:@"操作日志"], kSidebarCellTextKey: NSLocalizedString(@"操作日志", @"")},
                       @{kSidebarCellImageKey: [UIImage imageNamed:@"意见反馈"], kSidebarCellTextKey: NSLocalizedString(@"意见反馈", @"")},
                       @{kSidebarCellImageKey: [UIImage imageNamed:@"修改密码"], kSidebarCellTextKey: NSLocalizedString(@"修改密码", @"")},
                       @{kSidebarCellImageKey: [UIImage imageNamed:@"关于我们menu"], kSidebarCellTextKey: NSLocalizedString(@"退出登录", @"")}
                   ]];
    _controllers = @[
                     @[
                         @"dlrz",
                         @"czrz",
                         @"yjfk",
                         @"xgmm",
                         @"logout"
                         ]
                     ];
    
    // 添加手势.
    for (id obj1 in _controllers) {
        if (nil==obj1) continue;
        for (id obj2 in (NSArray *)obj1) {
            if (nil==obj2) continue;
            [SideMenuUtil setRevealControllerProperty:obj2 revealController:revealController];
            if ([obj2 isKindOfClass:UINavigationController.class]) {
                [SideMenuUtil addNavigationGesture:(UINavigationController*)obj2 revealController:revealController];
            }
        }
    }
    
    //revealController.contentViewController = _controllers[0][0];
    
    // ui.
    UIColor *bgColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
    self.view.backgroundColor = bgColor;
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.backgroundColor = [UIColor clearColor];
    [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    
}

- (void)viewDidUnload {
    [self setMenuTableView:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    // 设置自身窗口尺寸
    self.view.frame = CGRectMake(0.0f, 0.0f, kGHRevealSidebarWidth, CGRectGetHeight(self.view.bounds));
}


#pragma mark - property


#pragma mark - method

// 处理菜单项点击事件.
- (BOOL)onSelectRowAtIndexPath:(NSIndexPath *)indexPath hideSidebar:(BOOL)hideSidebar {
    BOOL rt = NO;
    do {
        if (nil==indexPath) break;
        
        // 获得当前项目.
        id controller = _controllers[indexPath.section][indexPath.row];
        if (nil!=controller) {
            // 命令.
            if ([controller isKindOfClass:NSString.class]) {
                NSString* cmd = controller;
                if ([cmd isEqualToString:@"logout"]) {
                    rt = YES;
                    break;
                }
            }
            
            // 页面跳转.
            if ([controller isKindOfClass:UIViewController.class]) {
                rt = YES;
                revealController.contentViewController = controller;
                if (hideSidebar) {
                    [revealController toggleSidebar:NO duration:kGHRevealSidebarDefaultAnimationDuration];
                }
            }
        }
    } while (0);
    return rt;
}

/// 选择某个菜单项.
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition {
    [_menuTableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
    if (scrollPosition == UITableViewScrollPositionNone) {
        [_menuTableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
    }
    [self onSelectRowAtIndexPath:indexPath hideSidebar:NO];
    NSLog(@"selectRowAtIndexPath: %@", revealController.contentViewController);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _headers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)_cellInfos[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuListCell";
    MenuListCell *cell = (MenuListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MenuListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *info = _cellInfos[indexPath.section][indexPath.row];
    cell.titleLabel.text = info[kSidebarCellTextKey];
    cell.logoImageView.image = info[kSidebarCellImageKey];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self onSelectRowAtIndexPath:indexPath hideSidebar:YES];
    NSLog(@"didSelectRowAtIndexPath: %@", revealController.contentViewController);
}

@end
