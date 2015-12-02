//
//  ThirdViewController.m
//  XTBG
//
//  Created by vchao on 14/11/19.
//  Copyright (c) 2014年 rzzx. All rights reserved.
//

#import "ThirdViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "NSObject+SBJson.h"
#import "ZXMailCell.h"
#import "ZXMailDetailViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mailTableView.dataSource = self;
    mailTableView.delegate = self;
    searchBar.delegate = self;
    
    shouArray = [[NSArray alloc] init];
    faArray = [[NSArray alloc] init];
    searchArray = [[NSMutableArray alloc] init];
    [self getMailList];
    
    openInfo = [[NSMutableDictionary alloc] init];
}

- (IBAction)tapReviceMail:(id)sender{
    NSInteger selectedIndex = [segmentedControl selectedSegmentIndex];
    [searchArray removeAllObjects];
    [mailTableView reloadData];
    if (selectedIndex == 0) {//收件箱
        searchBar.text = @"";
        searchArray = [[NSMutableArray alloc] initWithArray:shouArray];
        [mailTableView reloadData];
    }else{//发件箱
        searchBar.text = @"";
        if ([faArray count] == 0) {
            [self getFaMailList];
        }else{
            searchArray = [[NSMutableArray alloc] initWithArray:faArray];
            [mailTableView reloadData];
        }
    }
}

- (IBAction)tapSendMail:(id)sender{
    [self performSegueWithIdentifier:@"pushToSendMail" sender:@"tapSend"];
}

- (void)getMailList{
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger uid = [userDefaults integerForKey:USER_ID];
    
    NSString *URLString = [NSString stringWithFormat:@"%@/json2/maillist.php?act=shou&uid=%ld",
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
            shouArray = [resultDict objectForKey:@"mailinfo"];
            if (shouArray && [shouArray count] > 0) {
                NSInteger selectedIndex = [segmentedControl selectedSegmentIndex];
                if (selectedIndex == 0) {//收件箱
                    searchArray = [[NSMutableArray alloc] initWithArray:shouArray];
                    [mailTableView reloadData];
                }else{//发件箱
                        
                }
            }
        }else{
            searchArray = [[NSMutableArray alloc] init];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)getFaMailList{
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger uid = [userDefaults integerForKey:USER_ID];
    
    NSString *URLString = [NSString stringWithFormat:@"%@/json2/maillist.php?act=fa&uid=%ld",
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
            faArray = [resultDict objectForKey:@"mailinfo"];
            NSInteger selectedIndex = [segmentedControl selectedSegmentIndex];
            if (selectedIndex == 1) {
                searchArray = [[NSMutableArray alloc] initWithArray:faArray];
                [mailTableView reloadData];
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
        if (searchText.length>0 && [shouArray count] > 0) {
            [searchArray removeAllObjects];
            for (int i=0; i<[shouArray count]; i++) {
                NSDictionary *info = [shouArray objectAtIndex:i];
                NSString *cont = [info objectForKey:@"title"];
                if ([cont rangeOfString:searchText].length > 0) {
                    [searchArray addObject:info];
                }
            }
            [mailTableView reloadData];
        }else if ([shouArray count] > 0) {
            searchArray = [[NSMutableArray alloc] initWithArray:shouArray];
            [mailTableView reloadData];
        }
    }else{
        if (searchText.length>0 && [faArray count] > 0) {
            [searchArray removeAllObjects];
            for (int i=0; i<[faArray count]; i++) {
                NSDictionary *info = [faArray objectAtIndex:i];
                NSString *cont = [info objectForKey:@"title"];
                if ([cont rangeOfString:searchText].length > 0) {
                    [searchArray addObject:info];
                }
            }
            [mailTableView reloadData];
        }else if ([faArray count] > 0) {
            searchArray = [[NSMutableArray alloc] initWithArray:faArray];
            [mailTableView reloadData];
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
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"mailCell";
    ZXMailCell *cell = (ZXMailCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ZXMailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    NSInteger selectedIndex = [segmentedControl selectedSegmentIndex];
    if (selectedIndex == 0) {
        [openInfo setObject:@"1" forKey:@"can_replay"];
    }else{
        [openInfo setObject:@"0" forKey:@"can_replay"];
    }
    [self performSegueWithIdentifier:@"pushToMailDetail" sender:@"tapCell"];
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
    } else if ([sender isEqualToString:@"tapSend"]) {
    
    }
}

@end
