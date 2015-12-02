//
//  ZXAddLDHDViewController.m
//  XTBG
//
//  Created by vchao on 15/1/17.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import "ZXAddLDHDViewController.h"
#import "SVProgressHUD.h"
#import "NSObject+SBJson.h"

@implementation ZXAddLDHDViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    contentView.layer.cornerRadius = 4;
    contentView.layer.masksToBounds = YES;
    contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    contentView.layer.borderWidth = 0.5f;
    
    UIImage *loginBg = SY_IMAGE(@"pic_btn_normal");
    UIEdgeInsets logininsets = UIEdgeInsetsMake(3, 3, 3, 3);
    loginBg = [loginBg resizableImageWithCapInsets:logininsets];
    [submitBtn setBackgroundImage:loginBg forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[SY_IMAGE(@"pic_btn_pressed") resizableImageWithCapInsets:logininsets] forState:UIControlStateHighlighted];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    nameField.text = [userDefaults objectForKey:USER_LDHD];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    timeField.text = currentDateStr;
}

- (IBAction)tapSubmitButton:(id)sender {
    if (nameField.text.length > 0) {
        if (contentView.text.length > 0) {
            [SVProgressHUD showWithStatus:@"提交中..."];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSInteger uid = [userDefaults integerForKey:USER_ID];
            NSString *sort = [userDefaults objectForKey:USER_LDHD_SORT];
            
            NSString *URLString = [NSString stringWithFormat:@"%@/json2/ldhd.php?act=add&uid=%ld",
                                   API_DOMAIN,uid];
            NSDictionary *parameters = @{@"name": nameField.text,
                                         @"sort": sort,
                                         @"cont": contentView.text,
                                         @"time": timeField.text};
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [SVProgressHUD dismiss];
                NSLog(@"%@",[responseObject JSONValue]);
                NSDictionary *resultDict = [responseObject JSONValue];
                if ([[resultDict objectForKey:@"state"] isEqualToString:@"ok"]) {
                    [SVProgressHUD showErrorWithStatus:@"提交成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [SVProgressHUD showErrorWithStatus:@"提交失败"];
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:@"请输入活动内容"];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入领导姓名"];
    }
}

- (IBAction)tapTimeSelect:(id)sender{
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake( 12, 0,
                                                               _MainScreen_Width-12, 120)];
    NSDate *defaultDate = [[NSDate alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setDate:defaultDate animated:YES];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f){
        [self alertWithPicer:datePicker];
    }else{
        NSString *title = [NSString stringWithFormat:@"定时睡眠\n\n\n\n\n\n\n\n\n\n\n\n"];
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                                 delegate:self
                                                        cancelButtonTitle:@"取  消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"确  定", nil];
        [actionSheet showInView:self.view]; //参数view
        
        [actionSheet addSubview:datePicker];
    }
}

-(void)alertWithPicer:(UIDatePicker *)picker
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"\n\n\n\n\n\n\n\n\n\n\n\n"//改变UIAlertController高度
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    alert.view.backgroundColor = [UIColor whiteColor];
    CGRect pickerFrame = CGRectMake(12, 40, _MainScreen_Width-24, 216);
    picker.frame = pickerFrame;
    
    [alert.view addSubview:picker];
    
    UIToolbar *toolView = [[UIToolbar alloc] initWithFrame:CGRectMake(32, 0, alert.view.frame.size.width-80, 40)];
    toolView.backgroundColor = [UIColor clearColor];
    toolView.barStyle = UIBarStyleDefault;
    
    UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, alert.view.frame.size.width-104, 40)];
    tLabel.backgroundColor = [UIColor clearColor];
    tLabel.font = [UIFont systemFontOfSize:18];
    tLabel.textColor = [UIColor blackColor];
    tLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString *title = [NSString stringWithFormat:@"时间选择"];
    tLabel.text = title;
    UIBarButtonItem *bbtTitle = [[UIBarButtonItem alloc] initWithCustomView:tLabel];
    toolView.items = [NSArray arrayWithObjects:bbtTitle, nil];
    toolView.backgroundColor = [UIColor clearColor];
    
    [alert.view addSubview:toolView];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSDate *select = [datePicker date];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:select];
        timeField.text = currentDateStr;
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:otherAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{//确定
            NSDate *select = [datePicker date];
            //实例化一个NSDateFormatter对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            //用[NSDate date]可以获取系统当前时间
            NSString *currentDateStr = [dateFormatter stringFromDate:select];
            timeField.text = currentDateStr;
            break;
        }
            
        default:
            break;
    }
}

@end
