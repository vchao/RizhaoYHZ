//
//  ZXSendFileViewController.m
//  XTBG
//
//  Created by vchao on 15/9/25.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import "ZXSendFileViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "NSObject+SBJson.h"
#import "SendFileCell.h"
#import "ZXLiuchengViewController.h"
#import "ZXFileDetailViewController.h"

@interface ZXSendFileViewController ()

@end

@implementation ZXSendFileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    fileTableView.dataSource = self;
    fileTableView.delegate = self;
    searchBar.delegate = self;
    
    doArray = [[NSArray alloc] init];
    listArray = [[NSArray alloc] init];
    searchArray = [[NSMutableArray alloc] init];
    //    [self getDoList];
    
    openInfo = [[NSMutableDictionary alloc] init];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getDoList];
    [self getAllList];
}

- (IBAction)tapReviceMail:(id)sender{
    NSInteger selectedIndex = [segmentedControl selectedSegmentIndex];
    [searchArray removeAllObjects];
    [fileTableView reloadData];
    if (selectedIndex == 0) {//发文待办
        searchBar.text = @"";
        searchArray = [[NSMutableArray alloc] initWithArray:doArray];
        [fileTableView reloadData];
    }else{//发文查询
        searchBar.text = @"";
        if ([listArray count] == 0) {
            [self getAllList];
        }else{
            searchArray = [[NSMutableArray alloc] initWithArray:listArray];
            [fileTableView reloadData];
        }
    }
}

- (void)getDoList{
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger uid = [userDefaults integerForKey:USER_ID];
    
    NSString *URLString = [NSString stringWithFormat:@"%@/json2/fawen.php?act=dolist&uid=%ld",
                           API_DOMAIN,uid];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (result.length > 20) {
            NSLog(@"%@",[responseObject JSONValue]);
            NSMutableDictionary *resultDict = [responseObject JSONValue];
            doArray = [resultDict objectForKey:@"value"];
            if (doArray && [doArray count] > 0) {
                NSInteger selectedIndex = [segmentedControl selectedSegmentIndex];
                if (selectedIndex == 0) {//收件箱
                    searchArray = [[NSMutableArray alloc] initWithArray:doArray];
                    [fileTableView reloadData];
                }
            }
        }else{
            searchArray = [[NSMutableArray alloc] init];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)getAllList{
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger uid = [userDefaults integerForKey:USER_ID];
    
    NSString *URLString = [NSString stringWithFormat:@"%@/json2/fawen.php?act=list&uid=%ld",
                           API_DOMAIN,uid];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (result.length > 20) {
            NSLog(@"%@",[responseObject JSONValue]);
            NSMutableDictionary *resultDict = [responseObject JSONValue];
            listArray = [resultDict objectForKey:@"value"];
            NSInteger selectedIndex = [segmentedControl selectedSegmentIndex];
            if (selectedIndex == 1) {
                searchArray = [[NSMutableArray alloc] initWithArray:listArray];
                [fileTableView reloadData];
            }
        }else{
            searchArray = [[NSMutableArray alloc] init];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSInteger selectedIndex = [segmentedControl selectedSegmentIndex];
    if (selectedIndex == 0) {
        if (searchText.length>0 && [doArray count] > 0) {
            [searchArray removeAllObjects];
            for (int i=0; i<[doArray count]; i++) {
                NSDictionary *info = [doArray objectAtIndex:i];
                NSString *cont = [info objectForKey:@"title"];
                if ([cont rangeOfString:searchText].length > 0) {
                    [searchArray addObject:info];
                }
            }
            [fileTableView reloadData];
        }else if ([doArray count] > 0) {
            searchArray = [[NSMutableArray alloc] initWithArray:doArray];
            [fileTableView reloadData];
        }
    }else{
        if (searchText.length>0 && [listArray count] > 0) {
            [searchArray removeAllObjects];
            for (int i=0; i<[listArray count]; i++) {
                NSDictionary *info = [listArray objectAtIndex:i];
                NSString *cont = [info objectForKey:@"title"];
                if ([cont rangeOfString:searchText].length > 0) {
                    [searchArray addObject:info];
                }
            }
            [fileTableView reloadData];
        }else if ([listArray count] > 0) {
            searchArray = [[NSMutableArray alloc] initWithArray:listArray];
            [fileTableView reloadData];
        }
    }
    //关键字改变
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return searchArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"workFileCell";
    SendFileCell *cell = (SendFileCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SendFileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *info = [searchArray objectAtIndex:indexPath.row];
    [cell initWithDictionary:info];
    [cell.liuchengBtn addTarget:self action:@selector(showLiucheng:) forControlEvents:UIControlEventTouchUpInside];
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
    
    openInfo = searchArray[indexPath.row];
    [self performSegueWithIdentifier:@"pushToFileDetail" sender:@"tapPishi"];
}

- (void)showLiucheng:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSInteger tagID = btn.tag;
    liuchengID = [NSString stringWithFormat:@"%ld",tagID];
    [self performSegueWithIdentifier:@"pushToFileLC" sender:@"tapLiucheng"];
}

#pragma mark - 导航

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *viewController = segue.destinationViewController;
    if ([sender isEqualToString:@"tapPishi"]) {
        if ([viewController respondsToSelector:@selector(setInfoDictionary:)]) {
            [viewController setValue:openInfo forKey:@"infoDictionary"];
        }
    } else if ([sender isEqualToString:@"tapLiucheng"]) {
        if ([viewController respondsToSelector:@selector(setLcID:)]) {
            [viewController setValue:liuchengID forKey:@"lcID"];
        }
        if ([viewController respondsToSelector:@selector(setLcType:)]) {
            [viewController setValue:@"fawen" forKey:@"lcType"];
        }
    }
}

@end
