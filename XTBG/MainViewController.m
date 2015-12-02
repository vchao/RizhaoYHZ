//
//  MainViewController.m
//  XTBG
//
//  Created by vchao on 14/11/12.
//  Copyright (c) 2014年 rzzx. All rights reserved.
//

#import "MainViewController.h"
#import "ZXCollectionViewCell.h"
#import "ARSleepActionView.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "NSObject+SBJson.h"

@implementation MainViewController

@synthesize revealController;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[self OriginImage:[UIImage imageNamed:@"首页背景"] scaleToSize:CGSizeMake(_MainScreen_Width, _MainScreen_Height-49)]];
    
    homeArray = [[NSMutableArray alloc] init];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *ldHD = [userDefaults objectForKey:USER_LDHD];
    
    NSMutableArray *section1 = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    [dict1 setObject:@"待办事项" forKey:@"logo"];
    [dict1 setObject:@"来文办理" forKey:@"title"];
    [section1 addObject:dict1];
    
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] init];
    [dict2 setObject:@"发文管理" forKey:@"logo"];
    [dict2 setObject:@"发文管理" forKey:@"title"];
    [section1 addObject:dict2];
    
    NSMutableDictionary *dict3 = [[NSMutableDictionary alloc] init];
    [dict3 setObject:@"邮件管理" forKey:@"logo"];
    [dict3 setObject:@"邮件管理" forKey:@"title"];
    [section1 addObject:dict3];
    
    NSMutableDictionary *dict4 = [[NSMutableDictionary alloc] init];
    [dict4 setObject:@"通知公告" forKey:@"logo"];
    [dict4 setObject:@"通知公告" forKey:@"title"];
    [section1 addObject:dict4];
    [homeArray addObject:section1];
    
    NSMutableArray *section2 = [[NSMutableArray alloc] init];
    if (ldHD && ldHD.length > 0){
        isLDUser = YES;
        NSMutableDictionary *dict5 = [[NSMutableDictionary alloc] init];
        [dict5 setObject:@"领导活动" forKey:@"logo"];
        [dict5 setObject:@"领导活动" forKey:@"title"];
        [section2 addObject:dict5];
    }else{
        isLDUser = NO;
    }
    
    NSMutableDictionary *dict6 = [[NSMutableDictionary alloc] init];
    [dict6 setObject:@"个人办公" forKey:@"logo"];
    [dict6 setObject:@"个人办公" forKey:@"title"];
    [section2 addObject:dict6];
    
    NSMutableDictionary *dict7 = [[NSMutableDictionary alloc] init];
    [dict7 setObject:@"通讯录" forKey:@"logo"];
    [dict7 setObject:@"通讯录" forKey:@"title"];
    [section2 addObject:dict7];
    
    NSMutableDictionary *dict8 = [[NSMutableDictionary alloc] init];
    [dict8 setObject:@"密码重置" forKey:@"logo"];
    [dict8 setObject:@"修改密码" forKey:@"title"];
    [section2 addObject:dict8];
    
    [homeArray addObject:section2];
    
//    collectionViewWidthConstraint.constant = _MainScreen_Width-16;
//    collectionViewHeightConstraint.constant = _MainScreen_Height-92-49;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
    flowLayout.minimumLineSpacing = 8.0;//行间距(最小值)
    flowLayout.minimumInteritemSpacing = 4.0;//item间距(最小值)
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 6, 0, 6);//设置section的边距
    if (iPhone5 || iPhone4) {
        [flowLayout setItemSize:CGSizeMake(70, 90)];//设置cell的尺寸
    }else if (iPhone6) {
        [flowLayout setItemSize:CGSizeMake(82, 102)];//设置cell的尺寸
    }else if (iPhone6plus) {
        if (_MainScreen_Width == 375.f){//放大模式
            [flowLayout setItemSize:CGSizeMake(82, 102)];//设置cell的尺寸
        }else{
            [flowLayout setItemSize:CGSizeMake(91, 111)];//设置cell的尺寸
        }
    }else{
        [flowLayout setItemSize:CGSizeMake(70, 90)];//设置cell的尺寸
    }
    homeCollectionView.collectionViewLayout = flowLayout;
    
    homeCollectionView.dataSource = self;
    homeCollectionView.delegate = self;
    [homeCollectionView reloadData];
    
    NSString *nickName = [userDefaults objectForKey:USER_REAL_NAME];
    nicknameLabel.text = [NSString stringWithFormat:@"%@,欢迎您!",nickName];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getDBCount];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)getDBCount{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger uid = [userDefaults integerForKey:USER_ID];
    
    NSString *URLString = [NSString stringWithFormat:@"%@/json2/total.php?act=total&uid=%ld",
                           API_DOMAIN,uid];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",[responseObject JSONValue]);
        NSMutableDictionary *resultDict = [responseObject JSONValue];
        unEmail = [[resultDict objectForKey:@"email"] integerValue];
        unNotice = [[resultDict objectForKey:@"notice"] integerValue];
        unWork = [[resultDict objectForKey:@"work"] integerValue];
        [homeCollectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - 显示收集视图

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger count = 0;
    if (homeArray) {
        count = [homeArray count];
    }
    return count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (homeArray && [homeArray count] > 0) {
        NSArray *array = [homeArray objectAtIndex:section];
        if (array) {
            count = [array count];
        }
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"viewCell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor];
//    return cell;
    UICollectionViewCell *cell = nil;
    if (homeArray && [homeArray count] > 0) {
        NSArray *array = [homeArray objectAtIndex:indexPath.section];
        if (array && [array count] > 0) {
            NSDictionary *dictionary = [array objectAtIndex:indexPath.row];
                static NSString *kCollectionViewCellID = @"viewCell";
                ZXCollectionViewCell *viewCell = (ZXCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellID forIndexPath:indexPath];
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    [viewCell initWithDictionary:dictionary count:unWork];
                } else if (indexPath.row == 1) {
                    [viewCell initWithDictionary:dictionary count:unNotice];
                } else if (indexPath.row == 2) {
                    [viewCell initWithDictionary:dictionary count:unEmail];
                } else {
                    [viewCell initWithDictionary:dictionary count:0];
                }
            }else{
                [viewCell initWithDictionary:dictionary count:0];
            }
            [viewCell setNeedsDisplay];
            cell = viewCell;
        }
    }
    [cell setNeedsDisplay];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    DLog(@"%@", indexPath);
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.tabBarController.selectedIndex = 1;
        } else if (indexPath.row == 1) {
            // 发文管理
            self.tabBarController.selectedIndex = 2;
        } else if (indexPath.row == 2) {
//            self.tabBarController.selectedIndex = 2;
            [self performSegueWithIdentifier:@"pushToYJGL" sender:@"tapCell"];
        } else if (indexPath.row == 3) {
            // 通知公告
            self.tabBarController.selectedIndex = 3;
        }
    } else if (indexPath.section == 1){
        if (isLDUser) {
            if (indexPath.row == 0) {
                //领导活动
                [self performSegueWithIdentifier:@"pushToLDHD" sender:@"tapCell"];
            } else if (indexPath.row == 1) {
                //个人办公
                [self performSegueWithIdentifier:@"pushToSendMsg" sender:@"tapCell"];
            } else if (indexPath.row == 2) {
                //通讯录
                self.tabBarController.selectedIndex = 4;
            } else if (indexPath.row == 3) {
                //修改密码
                [self performSegueWithIdentifier:@"pushToPassword" sender:@"tapCell"];
            }
        }else{
            if (indexPath.row == 0) {
                //个人办公
                [self performSegueWithIdentifier:@"pushToSendMsg" sender:@"tapCell"];
            } else if (indexPath.row == 1) {
                //通讯录
                self.tabBarController.selectedIndex = 4;
            } else if (indexPath.row == 2) {
                //修改密码
                [self performSegueWithIdentifier:@"pushToPassword" sender:@"tapCell"];
            }
        }
    }
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

-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

/// 拉开左侧:点击.
- (IBAction)sideLeftButton_selector:(id)sender {
    [ARSleepActionView showSleepMenu:nil info:nil viewController:self];
}

@end
