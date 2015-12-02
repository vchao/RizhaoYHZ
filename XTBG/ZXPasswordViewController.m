//
//  ZXPasswordViewController.m
//  XTBG
//
//  Created by vchao on 15/1/28.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import "ZXPasswordViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "NSObject+SBJson.h"

@implementation ZXPasswordViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIImage *loginBg = SY_IMAGE(@"pic_btn_normal_gray");
    UIEdgeInsets logininsets = UIEdgeInsetsMake(5, 5, 5, 5);
    loginBg = [loginBg resizableImageWithCapInsets:logininsets];
    [submitBtn setBackgroundImage:loginBg forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[SY_IMAGE(@"pic_btn_pressed_gray") resizableImageWithCapInsets:logininsets] forState:UIControlStateHighlighted];
}

- (IBAction)tapSubmitBtn:(id)sender{
    if (oldPassField.text.length>0) {
        if (newPassField.text.length > 0) {
            if ([newPassField.text isEqualToString:qrPassField.text]) {
                [SVProgressHUD showWithStatus:@"提交中..."];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSInteger uid = [userDefaults integerForKey:USER_ID];
                
                NSString *URLString = [NSString stringWithFormat:@"%@/json2/pwdreset.php?act=do&uid=%ld",
                                       API_DOMAIN,uid];
                
                NSDictionary *parameters =@{@"newpwd":newPassField.text};
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                    NSLog(@"%@",[responseObject JSONValue]);
                    [self.navigationController popViewControllerAnimated:YES];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    [SVProgressHUD showSuccessWithStatus:@"修改失败"];
                }];
            }else{
                [SVProgressHUD showErrorWithStatus:@"新密码不一致"];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"请输入新密码"];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入原密码"];
    }
}

@end
