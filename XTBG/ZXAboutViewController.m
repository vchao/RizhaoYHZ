//
//  ZXAboutViewController.m
//  XTBG
//
//  Created by vchao on 15/1/11.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import "ZXAboutViewController.h"
#import "SVProgressHUD.h"

@implementation ZXAboutViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    aboutWebView.delegate = self; //代理方法 = VC类
    aboutWebView.backgroundColor = [UIColor clearColor];
//    [aboutWebView setScalesPageToFit:YES];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.rizhao.cn/app/gsjj.php"] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    [aboutWebView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [SVProgressHUD showWithStatus:@"加载中"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
}

@end
