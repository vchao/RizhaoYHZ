//
//  ZXSendMsgViewController.m
//  XTBG
//
//  Created by vchao on 15/1/18.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import "ZXSendMsgViewController.h"
#import "ZXContactCell.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "NSObject+SBJson.h"

@implementation ZXSendMsgViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    dic = [[NSMutableDictionary alloc] init];
    selectedArr = [[NSMutableArray alloc] init];
    dataArray = [[NSArray alloc] init];
    
    selectedArray = [[NSMutableArray alloc] init];
    
    //tableView
    contactsTableView.delegate = self;
    contactsTableView.dataSource = self;
    contactsTableView.showsVerticalScrollIndicator = NO;
    //不要分割线
    contactsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    msgTextView = [[UITextView alloc] initWithFrame:CGRectMake(8, 72, _MainScreen_Width-16, 160)];
    msgTextView.layer.cornerRadius = 4;
    msgTextView.layer.masksToBounds = YES;
    msgTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    msgTextView.layer.borderWidth = 0.5f;
    msgTextView.delegate = self;
    [self.view addSubview:msgTextView];
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 76, _MainScreen_Width-16, 18)];
    textLabel.enabled = NO;//label必须设置为不可用
    textLabel.numberOfLines = 0;
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    textLabel.backgroundColor = [UIColor clearColor];
    NSString *dateString =@"请输入";
    UIFont *dateFont =[UIFont fontWithName:@"Helvetica" size:14.0];
    textLabel.text = dateString;
    textLabel.font = dateFont;
    [self.view addSubview:textLabel];
    
    UIImage *loginBg = SY_IMAGE(@"pic_btn_normal_gray");
    UIEdgeInsets logininsets = UIEdgeInsetsMake(5, 5, 5, 5);
    loginBg = [loginBg resizableImageWithCapInsets:logininsets];
    [sendBtn setBackgroundImage:loginBg forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:loginBg forState:UIControlStateNormal];
    [sendBtn setBackgroundImage:[SY_IMAGE(@"pic_btn_pressed_gray") resizableImageWithCapInsets:logininsets] forState:UIControlStateHighlighted];
    [cancelBtn setBackgroundImage:[SY_IMAGE(@"pic_btn_pressed_gray") resizableImageWithCapInsets:logininsets] forState:UIControlStateHighlighted];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.xml",
                          [NSString stringWithFormat:@"%@/Documents/ProtocolCaches", NSHomeDirectory()], @"contactInfolist"];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *dirPath = [NSString stringWithFormat:@"%@/Documents/ProtocolCaches", NSHomeDirectory()];
    BOOL isDir = YES;
    if (![fm fileExistsAtPath:dirPath isDirectory:&isDir]) {
        [fm createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSArray *array = [self getArrayFromFile:fileName];
    if ([array count] > 1) {
        NSDictionary *departDict = [array objectAtIndex:0];
        NSDictionary *userDict = [array objectAtIndex:1];
        
        NSMutableArray *departArray = [departDict objectForKey:@"depart"];
        
        titleDataArray = [[NSMutableArray alloc] initWithArray:departArray];//分组
        
        NSMutableArray *userArray = [userDict objectForKey:@"user"];
        
        for (int i=0; i<[departArray count]; i++) {
            NSDictionary *depart = [departArray objectAtIndex:i];
            NSInteger departID = [[depart objectForKey:@"id"] integerValue];
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int j=0; j<[userArray count]; j++) {
                NSDictionary *user = [userArray objectAtIndex:j];
                NSInteger type = [[user objectForKey:@"type"] integerValue];
                if (departID == type) {
                    [array addObject:user];
                }
            }
            [dic setObject:array forKey:[NSString stringWithFormat:@"%d",i]];
        }
        [contactsTableView reloadData];
    }
    [self getContactsList];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (msgTextView.text.length == 0) {
        textLabel.text = @"请输入";
    }else{
        textLabel.text = @"";
    }
}

- (IBAction)tapSendMsg:(id)sender{
    if (msgTextView.text.length > 0) {
        if ([selectedArray count] > 0) {
            NSString *staff = @"";
            for (int i=0; i<[selectedArray count]; i++) {
                NSDictionary *dict = [selectedArray objectAtIndex:i];
                staff = [NSString stringWithFormat:@"%@|%@",staff,[dict objectForKey:@"id"]];
            }
            staff = [NSString stringWithFormat:@"%@|",staff];
            
            [SVProgressHUD showWithStatus:@"发送中..."];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSInteger uid = [userDefaults integerForKey:USER_ID];
            
            NSString *URLString = [NSString stringWithFormat:@"%@/json2/message.php?act=add&uid=%ld&content='%@'&staff=%@",
                                   API_DOMAIN,uid,msgTextView.text,staff];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager POST:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [SVProgressHUD showSuccessWithStatus:@"发送成功"];
                NSLog(@"%@",[responseObject JSONValue]);
//                NSMutableDictionary *resultDict = [responseObject JSONValue];
//                NSArray *array = [resultDict objectForKey:@"mailinfo"];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:@"请选择联系人"];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入信息"];
    }
}

- (IBAction)tapCancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tapRefresh:(id)sender{
    [self getContactsList];
}

- (void)getContactsList{
    if ([titleDataArray count] == 0 && [dic count] == 0) {
        [SVProgressHUD showWithStatus:@"加载中..."];
    }
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.xml",
                          [NSString stringWithFormat:@"%@/Documents/ProtocolCaches", NSHomeDirectory()], @"contactInfolist"];
    NSString *URLString = [NSString stringWithFormat:@"%@/json2/user.php",
                           API_DOMAIN];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([titleDataArray count] == 0 && [dic count] == 0) {
            [SVProgressHUD dismiss];
        }
        NSLog(@"%@",[responseObject JSONValue]);
        NSMutableArray *resultArray = [responseObject JSONValue];
        if ([resultArray count] > 1) {
            NSDictionary *departDict = [resultArray objectAtIndex:0];
            NSDictionary *userDict = [resultArray objectAtIndex:1];
            
            NSMutableArray *departArray = [departDict objectForKey:@"depart"];
            
            titleDataArray = [[NSMutableArray alloc] initWithArray:departArray];//分组
            
            NSMutableArray *userArray = [userDict objectForKey:@"user"];
            
            for (int i=0; i<[departArray count]; i++) {
                NSDictionary *depart = [departArray objectAtIndex:i];
                NSInteger departID = [[depart objectForKey:@"id"] integerValue];
                
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (int j=0; j<[userArray count]; j++) {
                    NSDictionary *user = [userArray objectAtIndex:j];
                    NSInteger type = [[user objectForKey:@"depart"] integerValue];
                    if (departID == type) {
                        [array addObject:user];
                    }
                }
                [dic setObject:array forKey:[NSString stringWithFormat:@"%d",i]];
            }
            [contactsTableView reloadData];
            
            [resultArray writeToFile:fileName atomically:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (NSArray *)getArrayFromFile:(NSString *)fileName {
    NSArray *array = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = YES;
    if ([fm fileExistsAtPath:fileName isDirectory:&isDir]) {
        array = [[NSArray alloc] initWithContentsOfFile:fileName];
    }
    return array;
}

#pragma mark----tableViewDelegate
//返回几个表头
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return titleDataArray.count;
}

//每一个表头下返回几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *string = [NSString stringWithFormat:@"%ld",section];
    
    if ([selectedArr containsObject:string]) {
        
        UIImageView *imageV = (UIImageView *)[contactsTableView viewWithTag:20000+section];
        imageV.image = [UIImage imageNamed:@"DownAccessory"];
        
        NSArray *array1 = dic[string];
        return array1.count;
    }
    return 0;
}

//设置表头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

//Section Footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.2;
}

//设置view，将替代titleForHeaderInSection方法
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 5, tableView.frame.size.width-24, 30)];
    NSDictionary *groupDict = [titleDataArray objectAtIndex:section];
    titleLabel.text = [groupDict objectForKey:@"name"];
    [view addSubview:titleLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 15, 18, 10)];
    imageView.tag = 20000+section;
    
    //判断是不是选中状态
    NSString *string = [NSString stringWithFormat:@"%ld",section];
    
    if ([selectedArr containsObject:string]) {
        imageView.image = [UIImage imageNamed:@"DownAccessory"];
    }
    else
    {
        imageView.image = [UIImage imageNamed:@"UpAccessory"];
    }
    [view addSubview:imageView];
    
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width-40, 11, 18, 18)];
    [selectBtn setImage:[UIImage imageNamed:@"pic_checkbox_normal3"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"pic_checkbox_selected3"] forState:UIControlStateHighlighted];
    [selectBtn setImage:[UIImage imageNamed:@"pic_checkbox_selected3"] forState:UIControlStateSelected];
    [selectBtn setImage:[UIImage imageNamed:@"pic_checkbox_normal3"] forState:UIControlStateSelected | UIControlStateHighlighted];
    selectBtn.tag = section;
    [selectBtn addTarget:self action:@selector(checkBoxSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *indexStr = [NSString stringWithFormat:@"%ld", section];
    NSArray *array = dic[indexStr];
    BOOL sel = YES;
    for (int i=0; i<[array count]; i++) {
        if (![selectedArray containsObject:array[i]]) {
            sel = NO;
        }
    }
    if (sel) {
        [selectBtn setSelected:YES];
    }else{
        [selectBtn setSelected:NO];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, _MainScreen_Width, 40);
    button.tag = 100+section;
    [button addTarget:self action:@selector(doButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UIView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, tableView.frame.size.width, 1)];
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    [view addSubview:lineView];
    [view addSubview:selectBtn];
    
    return view;
}

- (void)checkBoxSelect:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSString *indexStr = [NSString stringWithFormat:@"%ld", btn.tag];
    NSArray *array = dic[indexStr];
    for (int i=0; i<[array count]; i++) {
        if (btn.isSelected) {
            [selectedArray removeObject:array[i]];
        }else{
            [selectedArray addObject:array[i]];
        }
    }
    [contactsTableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //当前是第几个表头
    NSString *indexStr = [NSString stringWithFormat:@"%ld",indexPath.section];
    
    static NSString *CellIdentifier = @"MainCell";
    
    ZXContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ZXContactCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    if ([selectedArr containsObject:indexStr]) {
        cell.nameLabel.text = dic[indexStr][indexPath.row][@"realname"];
    }
    
    if ([selectedArray containsObject:dic[indexStr][indexPath.row]]) {
        cell.selectImageView.image = [UIImage imageNamed:@"pic_checkbox_selected3"];
    }else{
        cell.selectImageView.image = [UIImage imageNamed:@"pic_checkbox_normal3"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [contactsTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *indexStr = [NSString stringWithFormat:@"%ld",indexPath.section];
    
    NSIndexPath *path = nil;
    
    if (dic[indexStr][indexPath.row][@"id"]) {
        NSDictionary *dict = dic[indexStr][indexPath.row];
        if ([selectedArray containsObject:dict]) {
            [selectedArray removeObject:dict];
        }else{
            [selectedArray addObject:dict];
        }
        path = [NSIndexPath indexPathForItem:(indexPath.row+1) inSection:indexPath.section];
    }
    else
    {
        path = indexPath;
    }
    [contactsTableView reloadData];
}

-(void)doButton:(UIButton *)sender
{
    NSString *string = [NSString stringWithFormat:@"%ld",sender.tag-100];
    
    //数组selectedArr里面存的数据和表头想对应，方便以后做比较
    if ([selectedArr containsObject:string])
    {
        [selectedArr removeObject:string];
    }
    else
    {
        [selectedArr addObject:string];
    }
    
    [contactsTableView reloadData];
}

@end
