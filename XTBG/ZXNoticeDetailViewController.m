//
//  ZXNoticeDetailViewController.m
//  XTBG
//
//  Created by vchao on 15/1/17.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import "ZXNoticeDetailViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "NSObject+SBJson.h"

@implementation ZXNoticeDetailViewController

@synthesize infoDictionary;


- (void)viewDidLoad{
    [super viewDidLoad];
    [self getDetails];
}

- (void)getDetails{
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger uid = [userDefaults integerForKey:USER_ID];
    
    NSString *URLString = [NSString stringWithFormat:@"%@/json2/tongzhi.php?act=show&uid=%ld&id=%@",
                           API_DOMAIN,uid,[infoDictionary objectForKey:@"id"]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",[responseObject JSONValue]);
        NSMutableDictionary *resultDict = [responseObject JSONValue];
        NSDictionary *dict = [resultDict objectForKey:@"info"];
//        if ([array count] > 0) {
//            NSDictionary *dict = [array objectAtIndex:0];
        
            NSString *title = [dict objectForKey:@"title"];
            NSString *content = [dict objectForKey:@"content"];
            NSString *addtime = [dict objectForKey:@"addtime"];
            
            titleLabel.text = title;
            
            CGSize constraint = CGSizeMake(_MainScreen_Width-26, 200);
            CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping];
            titleHeightConstraint.constant = size.height;
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSInteger t = [addtime integerValue];
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:t];
            timeLabel.text = [formatter stringFromDate:confromTimesp];
            
            [contentWeb loadHTMLString:content baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
//        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)refreshDetail:(id)sender{
    [self getDetails];
}

@end
