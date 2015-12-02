//
//  ZXQianfaViewController.m
//  XTBG
//
//  Created by vchao on 15/9/25.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import "ZXQianfaViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "NSObject+SBJson.h"

@interface ZXQianfaViewController ()

@end

@implementation ZXQianfaViewController

@synthesize infoDictionary;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    shenpiDoDict = [[NSDictionary alloc] init];
    qianfaLeaderArray = [[NSArray alloc] init];
    huiqianLeaderArray = [[NSArray alloc] init];
    
    selectedQFArray = [[NSMutableArray alloc] init];
    selectedHQArray = [[NSMutableArray alloc] init];
    
    yesBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 11, 80, 24)];
    yesBtn.tag = 101;
    [yesBtn setImage:[UIImage imageNamed:@"单选未选"] forState:UIControlStateNormal];
    [yesBtn setImage:[UIImage imageNamed:@"单选选中"] forState:UIControlStateSelected];
    [yesBtn setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 80-21)];
    [yesBtn setTitleEdgeInsets:UIEdgeInsetsMake(3, -16, 3, 3)];
    [yesBtn setTitle:@"同意" forState:UIControlStateNormal];
    [yesBtn setTitle:@"同意" forState:UIControlStateSelected];
    [yesBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [yesBtn addTarget:self action:@selector(yesOrNoAction:) forControlEvents:UIControlEventTouchUpInside];
    
    noBtn = [[UIButton alloc] initWithFrame:CGRectMake(104, 11, 80, 24)];
    noBtn.tag = 102;
    [noBtn setImage:[UIImage imageNamed:@"单选未选"] forState:UIControlStateNormal];
    [noBtn setImage:[UIImage imageNamed:@"单选选中"] forState:UIControlStateSelected];
    [noBtn setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 80-21)];
    [noBtn setTitleEdgeInsets:UIEdgeInsetsMake(3, -16, 3, 3)];
    [noBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    [noBtn setTitle:@"拒绝" forState:UIControlStateSelected];
    [noBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [noBtn addTarget:self action:@selector(yesOrNoAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [yesBtn setSelected:YES];
    [noBtn setSelected:NO];
    
    fkTextView = [[UITextView alloc] initWithFrame:CGRectMake(12, 10, _MainScreen_Width-24, 160)];
    fkTextView.textColor          = [UIColor blackColor];//设置textview里面的字体颜色
    fkTextView.font               = [UIFont systemFontOfSize:14.f];
    fkTextView.backgroundColor    = UIColorFromRGB(0xF7F7F7);//背景色
    fkTextView.returnKeyType      = UIReturnKeyDefault;//返回键的类型
    fkTextView.keyboardType       = UIKeyboardTypeDefault;//键盘类型
    fkTextView.scrollEnabled      = YES;//是否可以拖动
    fkTextView.layer.cornerRadius = 4;
    fkTextView.layer.masksToBounds = YES;
    fkTextView.delegate = self;
    //[fkTextView setContentOffset:CGPointZero];
    //fkTextView.contentInset = UIEdgeInsetsMake(-60, 0, 0, 0);
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    textLabel.enabled = NO;//label必须设置为不可用
    textLabel.numberOfLines = 0;
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    textLabel.backgroundColor = [UIColor clearColor];
    CGSize maximumSize =CGSizeMake(_MainScreen_Width-24, 9999);
    NSString *dateString =@"请输入意见";
    UIFont *dateFont =[UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize dateStringSize =[dateString sizeWithFont:dateFont
                                  constrainedToSize:maximumSize
                                      lineBreakMode:textLabel.lineBreakMode];
    CGRect dateFrame =CGRectMake(17, 17, _MainScreen_Width-24, dateStringSize.height);
    textLabel.text = dateString;
    textLabel.font = dateFont;
    textLabel.frame = dateFrame;
    
    submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 7, (self.view.frame.size.width-36)/2, 38)];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    submitBtn.layer.cornerRadius = 4;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.layer.borderWidth = 1;
    submitBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(24+(self.view.frame.size.width-36)/2, 7, (self.view.frame.size.width-36)/2, 38)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    cancelBtn.layer.cornerRadius = 4;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if([[infoDictionary allKeys] containsObject:@"tag"])
    {
        NSInteger tag = [[infoDictionary objectForKey:@"tag"] integerValue];
        switch (tag) {
            case 0:
                //核稿
                self.title = @"核稿";
                tableRows = 3;
                break;
            case 1:
                //分发
                self.title = @"分发";
                tableRows = 3;
                break;
            case 2:
                //审核
                self.title = @"审核";
                tableRows = 3;
                break;
            case 3:
                //会签
                self.title = @"会签";
                tableRows = 4;
                [self getHQLeaderInfo];
                break;
            case 4:
                //签发
                self.title = @"签发";
                tableRows = 4;
                [self getQFLDInfo];
                break;
            case 5:
                //校对
                self.title = @"校对";
                tableRows = 3;
                break;
            case 6:
                //印发
                self.title = @"印发";
                tableRows = 3;
                break;
            case 9:
                //办结
                self.title = @"办结";
                tableRows = 1;
                break;
            default:
                break;
        }
    }
    
    [self getShenpiDoInfo];
}

- (void)cancelBtnAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitBtnAction:(UIButton *)sender{
    if (qianfaLeaderArray.count > 0 && selectedQFArray.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择签发领导"];
        return;
    }else if (huiqianLeaderArray.count > 0 && selectedHQArray.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择会签领导"];
        return;
    }else if (fkTextView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入意见"];
        return;
    }else{
        NSString *userID = [shenpiDoDict objectForKey:@"userid"];
        if (selectedQFArray.count > 0) {
            userID = @"";
            for (int i=0; i<selectedQFArray.count; i++) {
                if (i==0) {
                    userID = selectedQFArray[i];
                }else{
                    userID = [NSString stringWithFormat:@"%@|%@", userID, selectedQFArray[i]];
                }
            }
        }else if (selectedHQArray.count > 0) {
            userID = @"";
            for (int i=0; i<selectedHQArray.count; i++) {
                if (i==0) {
                    userID = selectedHQArray[i];
                }else{
                    userID = [NSString stringWithFormat:@"%@|%@", userID, selectedHQArray[i]];
                }
            }
        }
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSInteger uid = [userDefaults integerForKey:USER_ID];
        [SVProgressHUD showWithStatus:@"提交中..."];
        NSString *URLString = [NSString stringWithFormat:@"%@/json2/fawen.php?act=shenpido&uid=%ld&id=%@&do=do", API_DOMAIN,uid,[infoDictionary objectForKey:@"id"]];
        
        NSDictionary *parameters = @{@"status": yesBtn.isSelected?@"1":@"2",
                                     @"tag": [shenpiDoDict objectForKey:@"tag"],
                                     @"totag": [shenpiDoDict objectForKey:@"totag"],
                                     @"userid": userID,
                                     @"content": fkTextView.text};
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            NSDictionary *state = [responseObject JSONValue];
            if ([[state objectForKey:@"state"] isEqual:@"ok"]) {
                [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:@"提交失败"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [SVProgressHUD showErrorWithStatus:@"提交失败"];
        }];
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (fkTextView.text.length == 0) {
        textLabel.text = @"请输入意见";
    }else{
        textLabel.text = @"";
    }
}

- (void)yesOrNoAction:(UIButton *)sender{
    UIButton *btn = sender;
    if (btn.tag == 101) {
        [yesBtn setSelected:YES];
        [noBtn setSelected:NO];
    }else{
        [yesBtn setSelected:NO];
        [noBtn setSelected:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getShenpiDoInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger uid = [userDefaults integerForKey:USER_ID];
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *URLString = [NSString stringWithFormat:@"%@/json2/fawen.php?act=shenpido&uid=%ld&id=%@&do=show",
                           API_DOMAIN,uid,[infoDictionary objectForKey:@"id"]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",[responseObject JSONValue]);
        shenpiDoDict = [responseObject JSONValue];
        
        if ([[shenpiDoDict objectForKey:@"status"] integerValue] == 1) {
            tableRows = 1;
        }
        NSInteger tag = [[shenpiDoDict objectForKey:@"tag"] integerValue];
        switch (tag) {
            case 0:
                //核稿
                tableRows += 2;
                break;
            case 1:
                //分发
                tableRows += 2;
                break;
            case 2:
                //审核
                tableRows += 2;
                break;
            case 3:
                //会签
                tableRows += 3;
                break;
            case 4:
                //签发
                tableRows += 3;
                break;
            case 5:
                //校对
                tableRows += 2;
                break;
            case 6:
                //印发
                tableRows += 2;
                break;
            case 9:
                //办结
                tableRows = 1;
                break;
            default:
                break;
        }

        [infoTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}

//签发领导列表
- (void)getQFLDInfo{
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *URLString = [NSString stringWithFormat:@"%@/json2/fawen.php?act=group2",
                           API_DOMAIN];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        NSArray *array = [responseObject JSONValue];
        if (array.count > 1) {
            NSDictionary *dict = array[1];
            qianfaLeaderArray = [dict objectForKey:@"user"];
        }
        [infoTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}

//会签领导列表
- (void)getHQLeaderInfo{
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *URLString = [NSString stringWithFormat:@"%@/json2/fawen.php?act=group1",
                           API_DOMAIN];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        NSArray *array = [responseObject JSONValue];
        if (array.count > 1) {
            NSDictionary *dict = array[1];
            huiqianLeaderArray = [dict objectForKey:@"user"];
        }
        [infoTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}

#pragma mark -
#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableRows;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[shenpiDoDict objectForKey:@"status"] integerValue] == 1) {
        if (tableRows == 4) {
            if (indexPath.row == 2) {
                return 180;
            } else if (indexPath.row == 0) {
                if (qianfaLeaderArray.count > 0) {
                    return (qianfaLeaderArray.count/3+1)*45;
                }else{
                    return (huiqianLeaderArray.count/3+1)*45;
                }
            } else {
                return 45;
            }
        }else{
            if (indexPath.row == 1) {
                return 180;
            }else{
                return 45;
            }
        }
    }else{
        if (tableRows == 3) {
            if (indexPath.row == 1) {
                return 200;
            } else if (indexPath.row == 0) {
                if (qianfaLeaderArray.count > 0) {
                    return (qianfaLeaderArray.count/3+1)*45;
                }else{
                    return (huiqianLeaderArray.count/3+1)*45;
                }
            } else {
                return 45;
            }
        }else{
            if (indexPath.row == 0) {
                return 200;
            }else{
                return 45;
            }
        }
    }
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
    switch (row) {
        case 0:
        {
            if (tableRows == 1) { //只有一行时是已“完结”
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 80, 35)];
                label.textColor = [UIColor grayColor];
                label.textAlignment = NSTextAlignmentRight;
                label.font = [UIFont systemFontOfSize:15];
                label.text = @"已完结";
                [cell.contentView addSubview:label];
            }else{
                if (qianfaLeaderArray.count > 0) {
                    CGFloat btnX = 12;
                    CGFloat btnWidth = (self.view.frame.size.width-48)/3;
                    for (int i=0; i<qianfaLeaderArray.count; i++) {
                        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX*(i%3+1)+btnWidth*(i%3), 11+(i/3*45), btnWidth, 24)];
                        btn.tag = i;
                        [btn setImage:[UIImage imageNamed:@"pic_checkbox_normal3"] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:@"pic_checkbox_selected3"] forState:UIControlStateSelected];
                        [btn setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, btnWidth-21)];
                        [btn setTitleEdgeInsets:UIEdgeInsetsMake(3, -21, 3, 3)];
                        
                        NSDictionary *user = qianfaLeaderArray[i];
                        [btn setTitle:[user objectForKey:@"realname"] forState:UIControlStateNormal];
                        [btn setTitle:[user objectForKey:@"realname"] forState:UIControlStateSelected];
                        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                        [btn addTarget:self action:@selector(tapQFLeaderAction:) forControlEvents:UIControlEventTouchUpInside];
                        [cell.contentView addSubview:btn];
                    }
                }else if (huiqianLeaderArray.count > 0) {
                    CGFloat btnX = 12;
                    CGFloat btnWidth = (self.view.frame.size.width-48)/3;
                    for (int i=0; i<huiqianLeaderArray.count; i++) {
                        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX*(i%3+1)+btnWidth*(i%3), 11+(i/3*45), btnWidth, 24)];
                        btn.tag = i;
                        [btn setImage:[UIImage imageNamed:@"pic_checkbox_normal3"] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:@"pic_checkbox_selected3"] forState:UIControlStateSelected];
                        [btn setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, btnWidth-21)];
                        [btn setTitleEdgeInsets:UIEdgeInsetsMake(3, -21, 3, 3)];
                        
                        NSDictionary *user = huiqianLeaderArray[i];
                        [btn setTitle:[user objectForKey:@"realname"] forState:UIControlStateNormal];
                        [btn setTitle:[user objectForKey:@"realname"] forState:UIControlStateSelected];
                        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                        [btn addTarget:self action:@selector(tapHQLeaderAction:) forControlEvents:UIControlEventTouchUpInside];
                        [cell.contentView addSubview:btn];
                    }
                }else{
                    if ([[shenpiDoDict objectForKey:@"status"] integerValue] == 1) {//同意or拒绝
                        [cell.contentView addSubview:yesBtn];
                        [cell.contentView addSubview:noBtn];
                    }else{
                        //内容输入
                        [cell.contentView addSubview:fkTextView];
                        [cell.contentView addSubview:textLabel];
                    }
                }
            }
            break;
        }
        case 1:
        {
            if (qianfaLeaderArray.count > 0 || huiqianLeaderArray.count > 0) {
                if ([[shenpiDoDict objectForKey:@"status"] integerValue] == 1) {//同意or拒绝
                    [cell.contentView addSubview:yesBtn];
                    [cell.contentView addSubview:noBtn];
                }else{
                    //内容输入
                    [cell.contentView addSubview:fkTextView];
                    [cell.contentView addSubview:textLabel];
                }
            }else{
                //内容输入
                [cell.contentView addSubview:fkTextView];
                [cell.contentView addSubview:textLabel];
            }
            break;
        }
        case 2:{
            if (qianfaLeaderArray.count > 0 || huiqianLeaderArray.count > 0) {
                if ([[shenpiDoDict objectForKey:@"status"] integerValue] == 1) {//同意or拒绝
                    //内容输入
                    [cell.contentView addSubview:fkTextView];
                    [cell.contentView addSubview:textLabel];
                }else{
                    //提交、取消
                    [cell.contentView addSubview:submitBtn];
                    [cell.contentView addSubview:cancelBtn];
                }
            }else{
                //提交、去掉
                [cell.contentView addSubview:submitBtn];
                [cell.contentView addSubview:cancelBtn];
            }
        break;
        }
        case 3:
        {
            //提交、取消
            [cell.contentView addSubview:submitBtn];
            [cell.contentView addSubview:cancelBtn];
            break;
        }
        default:
            break;
    }
    return cell;
    
}

- (void)tapQFLeaderAction:(UIButton *)sender{
    if (qianfaLeaderArray.count > sender.tag) {
        NSDictionary *user = qianfaLeaderArray[sender.tag];
        if (sender.isSelected) {
            [selectedQFArray removeObject:[user objectForKey:@"id"]];
            [sender setSelected:NO];
        }else{
            [selectedQFArray addObject:[user objectForKey:@"id"]];
            [sender setSelected:YES];
        }
    }
}

- (void)tapHQLeaderAction:(UIButton *)sender{
    if (huiqianLeaderArray.count > sender.tag) {
        NSDictionary *user = huiqianLeaderArray[sender.tag];
        if (sender.isSelected) {
            [selectedHQArray removeObject:[user objectForKey:@"id"]];
            [sender setSelected:NO];
        }else{
            [selectedHQArray addObject:[user objectForKey:@"id"]];
            [sender setSelected:YES];
        }
    }
}

@end
