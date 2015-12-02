//
//  FourthViewController.m
//  XTBG
//
//  Created by vchao on 15/1/17.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import "FourthViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "NSObject+SBJson.h"
#import "ZXNoticeDetailViewController.h"

@implementation FourthViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    tzTableView.dataSource = self;
    tzTableView.delegate = self;
    searchBar.delegate = self;
    
    tzArray = [[NSArray alloc] init];
    searchArray = [[NSMutableArray alloc] init];
    [self getTZGGList];
    
    openInfo = [[NSDictionary alloc] init];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)getTZGGList{
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger uid = [userDefaults integerForKey:USER_ID];
    
    NSString *URLString = [NSString stringWithFormat:@"%@/json2/tongzhi.php?act=list&uid=%ld",
                           API_DOMAIN,uid];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",[responseObject JSONValue]);
        NSMutableDictionary *resultDict = [responseObject JSONValue];
        tzArray = [resultDict objectForKey:@"info"];
        searchArray = [[NSMutableArray alloc] initWithArray:tzArray];
        [tzTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //关键字改变
    if (searchText.length>0 && [tzArray count] > 0) {
        [searchArray removeAllObjects];
        for (int i=0; i<[tzArray count]; i++) {
            NSDictionary *info = [tzArray objectAtIndex:i];
            NSString *cont = [info objectForKey:@"title"];
            if ([cont rangeOfString:searchText].length > 0) {
                [searchArray addObject:info];
            }
        }
        [tzTableView reloadData];
    }else if ([tzArray count] > 0) {
        searchArray = [[NSMutableArray alloc] initWithArray:tzArray];
        [tzTableView reloadData];
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return searchArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"tzggCell";
    ZXTzggCell *cell = (ZXTzggCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ZXTzggCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *info = [searchArray objectAtIndex:indexPath.row];
    [cell initWithDictionary:info];
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    openInfo = [searchArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"pushToTZDetail" sender:@"tapCell"];
}

#pragma mark - 导航

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *viewController = segue.destinationViewController;
    if ([sender isEqualToString:@"tapCell"]) {
        if ([viewController respondsToSelector:@selector(setInfoDictionary:)]) {
            [viewController setValue:openInfo forKey:@"infoDictionary"];
        }
    }
}

@end
