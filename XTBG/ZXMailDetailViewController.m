//
//  ZXMailDetailViewController.m
//  XTBG
//
//  Created by vchao on 15/1/18.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import "ZXMailDetailViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "NSObject+SBJson.h"

@implementation ZXMailDetailViewController

@synthesize infoDictionary;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    isLoaded = NO;
    
    UIImage *loginBg = SY_IMAGE(@"pic_btn_normal_gray");
    UIEdgeInsets logininsets = UIEdgeInsetsMake(5, 5, 5, 5);
    loginBg = [loginBg resizableImageWithCapInsets:logininsets];
    [replayBtn setBackgroundImage:loginBg forState:UIControlStateNormal];
    [replayBtn setBackgroundImage:[SY_IMAGE(@"pic_btn_pressed_gray") resizableImageWithCapInsets:logininsets] forState:UIControlStateHighlighted];
    [zhuanfaBtn setBackgroundImage:[SY_IMAGE(@"pic_btn_normal_gray") resizableImageWithCapInsets:logininsets] forState:UIControlStateNormal];
    [zhuanfaBtn setBackgroundImage:[SY_IMAGE(@"pic_btn_pressed_gray") resizableImageWithCapInsets:logininsets] forState:UIControlStateHighlighted];
    [zhuanfaBtn2 setBackgroundImage:[SY_IMAGE(@"pic_btn_normal_gray") resizableImageWithCapInsets:logininsets] forState:UIControlStateNormal];
    [zhuanfaBtn2 setBackgroundImage:[SY_IMAGE(@"pic_btn_pressed_gray") resizableImageWithCapInsets:logininsets] forState:UIControlStateHighlighted];
    if ([[infoDictionary objectForKey:@"can_replay"] isEqualToString:@"1"]) {
        replayBtn.hidden = NO;
        zhuanfaBtn.hidden = NO;
        zhuanfaBtn2.hidden = YES;
    }else{
        replayBtn.hidden = YES;
        zhuanfaBtn.hidden = YES;
        zhuanfaBtn2.hidden = NO;
    }
    
    contentWeb.delegate = self;
    
    detailDict = [NSMutableDictionary dictionaryWithDictionary:infoDictionary];
    [self getDetails];
}

- (void)getDetails{
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger uid = [userDefaults integerForKey:USER_ID];
    
    NSString *URLString = [NSString stringWithFormat:@"%@/json2/maillist.php?act=show&uid=%ld&id=%@",
                           API_DOMAIN,uid,[infoDictionary objectForKey:@"id"]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",[responseObject JSONValue]);
        NSMutableDictionary *resultDict = [responseObject JSONValue];
        NSArray *array = [resultDict objectForKey:@"mailinfo"];
        if ([array count] > 0) {
            detailDict = [array objectAtIndex:0];
            
            NSString *title = [detailDict objectForKey:@"title"];
            NSString *content = [detailDict objectForKey:@"content"];
            NSString *addtime = [detailDict objectForKey:@"addtime"];
            NSString *adduser = [detailDict objectForKey:@"adduser"];
            NSString *revicer = [detailDict objectForKey:@"shoujianren"];
            NSString *filePath = [detailDict objectForKey:@"NewName"];
            NSString *fileName = [detailDict objectForKey:@"OldName"];
            
            titleLabel.text = title;
            senderLabel.text = adduser;
            revicerLabel.text = revicer;
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSInteger t = [addtime integerValue];
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:t];
            timeLabel.text = [formatter stringFromDate:confromTimesp];
            
            if (!fileName || fileName.length == 0) {
                NSArray *nameArray = [filePath componentsSeparatedByString:@"/"];
                fileName = nameArray[nameArray.count-1];
            }
            NSString *webStr = [NSString stringWithFormat:@"%@<br/><br/>附件:<a href=\"%@%@\">%@</a>",content, API_DOMAIN,filePath,fileName];
            [contentWeb loadHTMLString:webStr baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)refreshDetail:(id)sender{
    [self getDetails];
}

- (IBAction)replayMail:(id)sender {
    [self performSegueWithIdentifier:@"pushToSendMail" sender:@"tapReplay"];
}

- (IBAction)zhuanfaMail:(id)sender {
    [self performSegueWithIdentifier:@"pushToSendMail" sender:@"tapZhuanfa"];
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

#pragma mark - 导航

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *viewController = segue.destinationViewController;
    if ([sender isEqualToString:@"tapZhuanfa"]) {
        [detailDict setObject:@"0" forKey:@"replay"];
        if ([viewController respondsToSelector:@selector(setInfoDictionary:)]) {
            [viewController setValue:detailDict forKey:@"infoDictionary"];
        }
    } else if ([sender isEqualToString:@"tapReplay"]) {
        [detailDict setObject:@"1" forKey:@"replay"];
        if ([viewController respondsToSelector:@selector(setInfoDictionary:)]) {
            [viewController setValue:detailDict forKey:@"infoDictionary"];
        }
    }
}

@end
