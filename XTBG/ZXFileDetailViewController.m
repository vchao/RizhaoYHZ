//
//  ZXFileDetailViewController.m
//  XTBG
//
//  Created by vchao on 15/9/25.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import "ZXFileDetailViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "NSObject+SBJson.h"

@interface ZXFileDetailViewController ()

@end

@implementation ZXFileDetailViewController

@synthesize infoDictionary;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isLoaded = NO;
    
    if([[infoDictionary allKeys] containsObject:@"tag"])
    {
        qianfaBtn.hidden = NO;
        tableButtonConstraint.constant = -44.0;
        NSInteger tag = [[infoDictionary objectForKey:@"tag"] integerValue];
        switch (tag) {
            case 0:
                [qianfaBtn setTitle:@"核稿" forState:UIControlStateNormal];
                break;
            case 1:
                [qianfaBtn setTitle:@"分发" forState:UIControlStateNormal];
                break;
            case 2:
                [qianfaBtn setTitle:@"审核" forState:UIControlStateNormal];
                break;
            case 3:
                [qianfaBtn setTitle:@"会签" forState:UIControlStateNormal];
                break;
            case 4:
                [qianfaBtn setTitle:@"签发" forState:UIControlStateNormal];
                break;
            case 5:
                [qianfaBtn setTitle:@"校对" forState:UIControlStateNormal];
                break;
            case 6:
                [qianfaBtn setTitle:@"印发" forState:UIControlStateNormal];
                break;
            case 9:
                [qianfaBtn setTitle:@"办结" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }else{
        qianfaBtn.hidden = YES;
        tableButtonConstraint.constant = 0.0;
    }
    
    [self getInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshInfo:(id)sender{
    [self getInfo];
}

- (IBAction)qianfaAction:(id)sender{
    if([[infoDictionary allKeys] containsObject:@"tag"])
    {
        [self performSegueWithIdentifier:@"pushToQianfa" sender:@"tapQianfa"];
    }
}

#pragma mark - 导航

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *viewController = segue.destinationViewController;
    if ([sender isEqualToString:@"tapQianfa"]) {
        if ([viewController respondsToSelector:@selector(setInfoDictionary:)]) {
            [viewController setValue:infoDictionary forKey:@"infoDictionary"];
        }
    }
}

- (void)getInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger uid = [userDefaults integerForKey:USER_ID];
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *URLString = [NSString stringWithFormat:@"%@/json2/fawen.php?act=show&uid=%ld&id=%@",
                           API_DOMAIN,uid,[infoDictionary objectForKey:@"id"]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",[responseObject JSONValue]);
        contentDict = [responseObject JSONValue];
        [infoTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}

#pragma mark -
#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            return 10;
            break;
        }
        case 1:{
            NSArray *value1 = [contentDict objectForKey:@"value1"];
            if (!value1) {
                return 1;
            }
            return value1.count ? value1.count : 1;
            break;
        }
        case 2:{
            NSArray *value2 = [contentDict objectForKey:@"value2"];
            if (!value2) {
                return 1;
            }
            return value2.count ? value2.count : 1;
            break;
        }
        case 3:{
            NSArray *value3 = [contentDict objectForKey:@"value3"];
            if (!value3) {
                return 1;
            }
            return value3.count ? value3.count : 1;
            break;
        }
        case 4:{
            NSArray *value4 = [contentDict objectForKey:@"value4"];
            if (!value4) {
                return 1;
            }
            return value4.count > 0 ? value4.count : 1;
            break;
        }
        default:
            return 0;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath section] > 0){
        return 80.0;
    }
    if (indexPath.row == 9) {
        NSArray *valueArray = [contentDict objectForKey:@"value"];
        NSDictionary *dict = [valueArray objectAtIndex:0];
        NSString *newName = [dict objectForKey:@"NewName"];
        NSArray *newNameArray = [newName componentsSeparatedByString:@"|"];
        if (newNameArray.count == 1) {
            return 55;
        }else{
            return 35*newNameArray.count+10;
        }
    }
    return 45.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell-%li-%li", (long)[indexPath section], (long)[indexPath row]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UIColor *fontColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    NSUInteger row = (NSUInteger) [indexPath row];
    NSUInteger section = (NSUInteger) [indexPath section];
    switch (section) {
        case 0:
            switch (row) {
                case 0:
                {
                    NSArray *valueArray = [contentDict objectForKey:@"value"];
                    NSDictionary *dict = [valueArray objectAtIndex:0];
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 80, 35)];
                    label.textColor = [UIColor grayColor];
                    label.textAlignment = NSTextAlignmentRight;
                    label.font = [UIFont systemFontOfSize:15];
                    label.text = @"文件标题:";
                    [cell.contentView addSubview:label];
                    
                    UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(96, 5, self.view.frame.size.width-104, 35)];
                    contentlabel.textColor = [UIColor blackColor];
                    contentlabel.font = [UIFont systemFontOfSize:15];
                    contentlabel.text = [dict objectForKey:@"title"];
                    [cell.contentView addSubview:contentlabel];
                    break;
                }
                case 1:
                {
                    NSArray *valueArray = [contentDict objectForKey:@"value"];
                    NSDictionary *dict = [valueArray objectAtIndex:0];
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 80, 35)];
                    label.textColor = [UIColor grayColor];
                    label.textAlignment = NSTextAlignmentRight;
                    label.font = [UIFont systemFontOfSize:15];
                    label.text = @"拟稿科室:";
                    [cell.contentView addSubview:label];
                    
                    UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(96, 5, self.view.frame.size.width-104, 35)];
                    contentlabel.textColor = [UIColor blackColor];
                    contentlabel.font = [UIFont systemFontOfSize:15];
                    contentlabel.text = [dict objectForKey:@"depart"];
                    [cell.contentView addSubview:contentlabel];
                    break;
                }
                case 2:{
                    NSArray *valueArray = [contentDict objectForKey:@"value"];
                    NSDictionary *dict = [valueArray objectAtIndex:0];
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 80, 35)];
                    label.textColor = [UIColor grayColor];
                    label.textAlignment = NSTextAlignmentRight;
                    label.font = [UIFont systemFontOfSize:15];
                    label.text = @"发文编号:";
                    [cell.contentView addSubview:label];
                    
                    UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(96, 5, self.view.frame.size.width-104, 35)];
                    contentlabel.textColor = [UIColor blackColor];
                    contentlabel.font = [UIFont systemFontOfSize:15];
                    contentlabel.text = [dict objectForKey:@"bianhao"];
                    [cell.contentView addSubview:contentlabel];
                    break;
                }
                case 3:
                {
                    NSArray *valueArray = [contentDict objectForKey:@"value"];
                    NSDictionary *dict = [valueArray objectAtIndex:0];
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 80, 35)];
                    label.textColor = [UIColor grayColor];
                    label.textAlignment = NSTextAlignmentRight;
                    label.font = [UIFont systemFontOfSize:15];
                    label.text = @"收文类别:";
                    [cell.contentView addSubview:label];
                    
                    UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(96, 5, self.view.frame.size.width-104, 35)];
                    contentlabel.textColor = [UIColor blackColor];
                    contentlabel.font = [UIFont systemFontOfSize:15];
                    contentlabel.text = [dict objectForKey:@"type"];
                    [cell.contentView addSubview:contentlabel];
                    break;
                }
                case 4:
                {
                    NSArray *valueArray = [contentDict objectForKey:@"value"];
                    NSDictionary *dict = [valueArray objectAtIndex:0];
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 80, 35)];
                    label.textColor = [UIColor grayColor];
                    label.textAlignment = NSTextAlignmentRight;
                    label.font = [UIFont systemFontOfSize:15];
                    label.text = @"发文时间:";
                    [cell.contentView addSubview:label];
                    
                    UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(96, 5, self.view.frame.size.width-104, 35)];
                    contentlabel.textColor = [UIColor blackColor];
                    contentlabel.font = [UIFont systemFontOfSize:15];
                    contentlabel.text = [dict objectForKey:@"addtime"];
                    [cell.contentView addSubview:contentlabel];
                    break;
                }
                case 5:
                {
                    NSArray *valueArray = [contentDict objectForKey:@"value"];
                    NSDictionary *dict = [valueArray objectAtIndex:0];
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 80, 35)];
                    label.textColor = [UIColor grayColor];
                    label.textAlignment = NSTextAlignmentRight;
                    label.font = [UIFont systemFontOfSize:15];
                    label.text = @"主题词:";
                    [cell.contentView addSubview:label];
                    
                    UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(96, 5, self.view.frame.size.width-104, 35)];
                    contentlabel.textColor = [UIColor blackColor];
                    contentlabel.font = [UIFont systemFontOfSize:15];
                    contentlabel.text = [dict objectForKey:@"zhutici"];
                    [cell.contentView addSubview:contentlabel];
                    break;
                }
                case 6:
                {
                    NSArray *valueArray = [contentDict objectForKey:@"value"];
                    NSDictionary *dict = [valueArray objectAtIndex:0];
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 80, 35)];
                    label.textColor = [UIColor grayColor];
                    label.textAlignment = NSTextAlignmentRight;
                    label.font = [UIFont systemFontOfSize:15];
                    label.text = @"主送:";
                    [cell.contentView addSubview:label];
                    
                    UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(96, 5, self.view.frame.size.width-104, 35)];
                    contentlabel.textColor = [UIColor blackColor];
                    contentlabel.font = [UIFont systemFontOfSize:15];
                    contentlabel.text = [dict objectForKey:@"zhusong"];
                    [cell.contentView addSubview:contentlabel];
                    break;
                }
                case 7:
                {
                    NSArray *valueArray = [contentDict objectForKey:@"value"];
                    NSDictionary *dict = [valueArray objectAtIndex:0];
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 80, 35)];
                    label.textColor = [UIColor grayColor];
                    label.textAlignment = NSTextAlignmentRight;
                    label.font = [UIFont systemFontOfSize:15];
                    label.text = @"抄送:";
                    [cell.contentView addSubview:label];
                    
                    UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(96, 5, self.view.frame.size.width-104, 35)];
                    contentlabel.textColor = [UIColor blackColor];
                    contentlabel.font = [UIFont systemFontOfSize:15];
                    contentlabel.text = [dict objectForKey:@"chaosong"];
                    [cell.contentView addSubview:contentlabel];
                    break;
                }
                case 8:
                {
                    NSArray *valueArray = [contentDict objectForKey:@"value"];
                    NSDictionary *dict = [valueArray objectAtIndex:0];
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 80, 35)];
                    label.textColor = [UIColor grayColor];
                    label.textAlignment = NSTextAlignmentRight;
                    label.font = [UIFont systemFontOfSize:15];
                    label.text = @"份数:";
                    [cell.contentView addSubview:label];
                    
                    UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(96, 5, self.view.frame.size.width-104, 35)];
                    contentlabel.textColor = [UIColor blackColor];
                    contentlabel.font = [UIFont systemFontOfSize:15];
                    contentlabel.text = [dict objectForKey:@"fenshu"];
                    [cell.contentView addSubview:contentlabel];
                    break;
                }
                case 9:
                {
                    NSArray *valueArray = [contentDict objectForKey:@"value"];
                    NSDictionary *dict = [valueArray objectAtIndex:0];
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 80, 35)];
                    label.textColor = [UIColor grayColor];
                    label.textAlignment = NSTextAlignmentRight;
                    label.font = [UIFont systemFontOfSize:15];
                    label.text = @"附件:";
                    [cell.contentView addSubview:label];
                    
                    NSString *newName = [dict objectForKey:@"NewName"];
                    NSString *oldName = [dict objectForKey:@"OldName"];
                    NSArray *newNameArray = [newName componentsSeparatedByString:@"|"];
                    NSArray *oldNameArray = [oldName componentsSeparatedByString:@"|"];
                    
                    CGFloat webHeight = 45;
                    if (newNameArray.count > 1) {
                        webHeight = 25*newNameArray.count;
                    }
                    
                    UIWebView *fjWebView = [[UIWebView alloc] initWithFrame:CGRectMake(96, 5, self.view.frame.size.width-104, webHeight)];
                    fjWebView.delegate = self;
                    [cell.contentView addSubview:fjWebView];
                    
                    isLoaded = NO;
                    
                    NSString *fjHtmlStr = @"";
                    for (int i=0; i < newNameArray.count; i++) {
                        if (i > 0) {
                            fjHtmlStr = [NSString stringWithFormat:@"%@<br />",fjHtmlStr];
                        }
                        fjHtmlStr = [NSString stringWithFormat:@"%@<a href=\"%@%@\">%@</a>", fjHtmlStr,API_DOMAIN,newNameArray[i],oldNameArray[i]];
                    }
                    [fjWebView loadHTMLString:fjHtmlStr baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
                    break;
                }
                default:
                    break;
            }
            break;
            
        case 1:{
            NSArray *valueArray = [contentDict objectForKey:@"value1"];
            if (row < valueArray.count) {
                NSDictionary *dict = [valueArray objectAtIndex:row];
                
                UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 4, self.view.frame.size.width-16, 35)];
                contentlabel.textColor = [UIColor blackColor];
                contentlabel.font = [UIFont systemFontOfSize:15];
                contentlabel.numberOfLines = 2;
                contentlabel.text = [dict objectForKey:@"content"];
                [cell.contentView addSubview:contentlabel];
                
                UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 43, self.view.frame.size.width-108, 19)];
                namelabel.textColor = [UIColor blackColor];
                namelabel.font = [UIFont systemFontOfSize:15];
                namelabel.textAlignment = NSTextAlignmentRight;
                namelabel.text = [dict objectForKey:@"adduser"];
                [cell.contentView addSubview:namelabel];
                
                UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 62, self.view.frame.size.width-108, 18)];
                timelabel.textColor = [UIColor grayColor];
                timelabel.font = [UIFont systemFontOfSize:14];
                timelabel.textAlignment = NSTextAlignmentRight;
                timelabel.text = [dict objectForKey:@"addtime"];
                [cell.contentView addSubview:timelabel];
            }
            break;
        }
        case 2:{
            NSArray *valueArray = [contentDict objectForKey:@"value2"];
            if (row < valueArray.count) {
                NSDictionary *dict = [valueArray objectAtIndex:row];
                
                UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 4, self.view.frame.size.width-16, 35)];
                contentlabel.textColor = [UIColor blackColor];
                contentlabel.font = [UIFont systemFontOfSize:15];
                contentlabel.numberOfLines = 2;
                contentlabel.text = [dict objectForKey:@"content"];
                [cell.contentView addSubview:contentlabel];
                
                UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 43, self.view.frame.size.width-108, 19)];
                namelabel.textColor = [UIColor blackColor];
                namelabel.font = [UIFont systemFontOfSize:15];
                namelabel.textAlignment = NSTextAlignmentRight;
                namelabel.text = [dict objectForKey:@"adduser"];
                [cell.contentView addSubview:namelabel];
                
                UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 62, self.view.frame.size.width-108, 18)];
                timelabel.textColor = [UIColor grayColor];
                timelabel.font = [UIFont systemFontOfSize:14];
                timelabel.textAlignment = NSTextAlignmentRight;
                timelabel.text = [dict objectForKey:@"addtime"];
                [cell.contentView addSubview:timelabel];
            }
            break;
        }
        case 3:{
            NSArray *valueArray = [contentDict objectForKey:@"value3"];
            if (row < valueArray.count) {
                NSDictionary *dict = [valueArray objectAtIndex:row];
                
                UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 4, self.view.frame.size.width-16, 35)];
                contentlabel.textColor = [UIColor blackColor];
                contentlabel.font = [UIFont systemFontOfSize:15];
                contentlabel.numberOfLines = 2;
                contentlabel.text = [dict objectForKey:@"content"];
                [cell.contentView addSubview:contentlabel];
                
                UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 43, self.view.frame.size.width-108, 19)];
                namelabel.textColor = [UIColor blackColor];
                namelabel.font = [UIFont systemFontOfSize:15];
                namelabel.textAlignment = NSTextAlignmentRight;
                namelabel.text = [dict objectForKey:@"adduser"];
                [cell.contentView addSubview:namelabel];
                
                UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 62, self.view.frame.size.width-108, 18)];
                timelabel.textColor = [UIColor grayColor];
                timelabel.font = [UIFont systemFontOfSize:14];
                timelabel.textAlignment = NSTextAlignmentRight;
                timelabel.text = [dict objectForKey:@"addtime"];
                [cell.contentView addSubview:timelabel];
            }
            break;
        }
        case 4:{
            NSArray *valueArray = [contentDict objectForKey:@"value4"];
            if (row < valueArray.count) {
                NSDictionary *dict = [valueArray objectAtIndex:row];
                
                UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 4, self.view.frame.size.width-16, 35)];
                contentlabel.textColor = [UIColor blackColor];
                contentlabel.font = [UIFont systemFontOfSize:15];
                contentlabel.numberOfLines = 2;
                contentlabel.text = [dict objectForKey:@"content"];
                [cell.contentView addSubview:contentlabel];
                
                UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 43, self.view.frame.size.width-108, 19)];
                namelabel.textColor = [UIColor blackColor];
                namelabel.font = [UIFont systemFontOfSize:15];
                namelabel.textAlignment = NSTextAlignmentRight;
                namelabel.text = [dict objectForKey:@"adduser"];
                [cell.contentView addSubview:namelabel];
                
                UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 62, self.view.frame.size.width-108, 18)];
                timelabel.textColor = [UIColor grayColor];
                timelabel.font = [UIFont systemFontOfSize:14];
                timelabel.textAlignment = NSTextAlignmentRight;
                timelabel.text = [dict objectForKey:@"addtime"];
                [cell.contentView addSubview:timelabel];
            }
            break;
        }
        default:
            break;
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section > 0) {
        return 20;
    }else{
        return 12;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(8, 0, 100, 20)];
    if (section > 0) {
        switch (section) {
            case 1:{
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 100, 20)];
                label.text = @"拟办意见";
                label.textColor = [UIColor grayColor];
                label.font = [UIFont systemFontOfSize:15];
                [view addSubview:label];
                break;
            }
            case 2:{
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 100, 20)];
                label.text = @"领导批示";
                label.textColor = [UIColor grayColor];
                label.font = [UIFont systemFontOfSize:15];
                [view addSubview:label];
                break;
            }
            case 3:{
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 100, 20)];
                label.text = @"阅文签字";
                label.textColor = [UIColor grayColor];
                label.font = [UIFont systemFontOfSize:15];
                [view addSubview:label];
                break;
            }
            case 4:{
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 100, 20)];
                label.text = @"办理情况";
                label.textColor = [UIColor grayColor];
                label.font = [UIFont systemFontOfSize:15];
                [view addSubview:label];
                break;
            }
            default:
                break;
        }
    }
    return view;
}

- (BOOL)webView:(UIWebView *)_webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (!isLoaded) {
        isLoaded = YES;
        return YES;
    }
    [[UIApplication sharedApplication] openURL:[request URL]];
    return NO;
}

@end
