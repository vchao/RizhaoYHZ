//
//  ZXSendMailViewController.m
//  XTBG
//
//  Created by vchao on 15/1/24.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import "ZXSendMailViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "NSObject+SBJson.h"
#import "ZXContactCell.h"
#import "AssetsLibrary/AssetsLibrary.h"
#import "RTLabel.h"

@implementation ZXSendMailViewController

@synthesize infoDictionary;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    dic = [[NSMutableDictionary alloc] init];
    selectedArr = [[NSMutableArray alloc] init];
    dataArray = [[NSArray alloc] init];
    
    selectedArray = [[NSMutableArray alloc] init];
    sendMsg = NO;
    
    contentView.layer.cornerRadius = 4;
    contentView.layer.masksToBounds = YES;
    contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    contentView.layer.borderWidth = 0.5f;
    
    UIImage *loginBg = SY_IMAGE(@"pic_btn_normal_gray");
    UIEdgeInsets logininsets = UIEdgeInsetsMake(5, 5, 5, 5);
    loginBg = [loginBg resizableImageWithCapInsets:logininsets];
    [sendBtn setBackgroundImage:loginBg forState:UIControlStateNormal];
    [sendBtn setBackgroundImage:[SY_IMAGE(@"pic_btn_pressed_gray") resizableImageWithCapInsets:logininsets] forState:UIControlStateHighlighted];
    
    personTableView = [[UITableView alloc] initWithFrame:CGRectMake(8.0f, 44.0f, _MainScreen_Width-16, 176.0f)];
    personTableView.delegate = self;
    personTableView.dataSource = self;
    personTableView.showsVerticalScrollIndicator = NO;
    //不要分割线
    personTableView.backgroundColor = [UIColor whiteColor];
    personTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
        [personTableView reloadData];
    }
    [self getContactsList];
    
    fjWebView = [[UIWebView alloc] initWithFrame:CGRectMake(16, 362, _MainScreen_Width-64, 30)];
    fjWebView.delegate = self;
    [self.view addSubview:fjWebView];
    fjWebView.hidden = YES;
    
    if (infoDictionary && [infoDictionary count] > 0) {
        NSString *title = [infoDictionary objectForKey:@"title"];
        NSString *content = [infoDictionary objectForKey:@"content"];
        NSString *adduser = [infoDictionary objectForKey:@"adduser"];
        NSString *filePath = [infoDictionary objectForKey:@"NewName"];
        NSString *fileName = [infoDictionary objectForKey:@"OldName"];
        
        titleField.text = title;
        BOOL isReplay = [[infoDictionary objectForKey:@"replay"] boolValue];
        if (isReplay) {
            fjTopConstraint.constant = 362;
            self.title = @"回复";
            revicerField.text = adduser;
            [selectRevBtn setEnabled:NO];
            NSString *sender = [infoDictionary objectForKey:@"sender"];
            selectedArray = [[NSMutableArray alloc] init];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:sender forKey:@"id"];
            [dict setObject:adduser forKey:@"realname"];
            [selectedArray addObject:dict];
        }else{
            self.title = @"转发";
            zfFileId = [infoDictionary objectForKey:@"FileId"];
            [selectRevBtn setEnabled:YES];
            
            if (filePath && filePath.length > 0) {
                delFileBtn.hidden = NO;
                fjWebView.hidden = NO;
                isLoaded = NO;
                fjTopConstraint.constant = 400;
                if (!fileName || fileName.length == 0) {
                    NSArray *nameArray = [filePath componentsSeparatedByString:@"/"];
                    fileName = nameArray[nameArray.count-1];
                }
                [fjWebView loadHTMLString:[NSString stringWithFormat:@"附件:<a href=\"%@%@\">%@</a>", API_DOMAIN,filePath,fileName] baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
            }
        }
        contentView.text = content;
    }else{
        fjTopConstraint.constant = 362;
    }
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

- (IBAction)tapSelectPersons:(id)sender{
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f){
        [self alertWithTable:personTableView];
    }else{
        
        NSString *title = [NSString stringWithFormat:@"收件人选择\n\n\n\n\n\n\n\n\n\n\n\n"];
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                                 delegate:self
                                                        cancelButtonTitle:@"取  消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"确  定", nil];
        actionSheet.tag = 101;
        [actionSheet showInView:self.view]; //参数view
        
        [actionSheet addSubview:personTableView];
    }
}

- (IBAction)tapSelectFile:(id)sender{
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    choiceSheet.tag = 102;
    [choiceSheet showInView:self.view];
}

- (IBAction)tapSendMail:(id)sender{
    if (revicerField.text.length > 0) {
        if (titleField.text.length > 0) {
            NSString *staff = @"";
            for (int i=0; i<[selectedArray count]; i++) {
                NSDictionary *dict = [selectedArray objectAtIndex:i];
                staff = [NSString stringWithFormat:@"%@|%@",staff,[dict objectForKey:@"id"]];
            }
            staff = [NSString stringWithFormat:@"%@|",staff];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSInteger uid = [userDefaults integerForKey:USER_ID];
            
            NSString *URLString = [NSString stringWithFormat:@"%@/json2/maillist.php?act=add&uid=%ld",
                                   API_DOMAIN,uid];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            NSDictionary *parameters =@{@"title":titleField.text,@"content":contentView.text,@"staff":staff,@"imgpic":fileField.text?fileField.text:@"",@"filename":uploadFileName?uploadFileName:@"",@"duanxin":sendMsg?@"1":@"0"};
            if (infoDictionary && [infoDictionary count] > 0) {
                BOOL isReplay = [[infoDictionary objectForKey:@"replay"] boolValue];
                if (!isReplay) {//转发
                    parameters =@{@"title":titleField.text,@"content":contentView.text,@"staff":staff,@"imgpic":fileField.text?fileField.text:@"",@"filename":uploadFileName?uploadFileName:@"",@"duanxin":sendMsg?@"1":@"0",@"fileid":zfFileId?zfFileId:@""};
                }
            }
            
            NSData *dd = nil;
            if (fileField.text && fileField.text.length > 0) {
                dd = [NSData dataWithContentsOfFile:fileField.text];
            }
            
            [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                if (dd) {
                    [formData appendPartWithFileData:dd name:@"imgpic" fileName:uploadFileName mimeType:@"image/jpeg"];
                }
                
            } success:^(AFHTTPRequestOperation *operation,id responseObject) {
                [SVProgressHUD showSuccessWithStatus:@"发送成功"];
                revicerField.text = @"";
                [selectedArray removeAllObjects];
                contentView.text = @"";
                titleField.text = @"";
                fileField.text = @"";
                zfFileId = @"";
                fjTopConstraint.constant = 362;
                fjWebView.hidden = YES;
                delFileBtn.hidden = YES;
            } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
                NSLog(@"Error: %@", error);
                [SVProgressHUD showSuccessWithStatus:@"发送失败"];
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:@"请输入邮件主题"];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"请选择联系人"];
    }
    [SVProgressHUD showWithStatus:@"发送中..."];
    
}

- (IBAction)tapCheckSendMsg:(id)sender{
    sendMsg = !sendMsg;
    [sendMsgBtn setSelected:sendMsg];
}

- (IBAction)tapDelFile:(id)sender{
    zfFileId = @"";
    fjTopConstraint.constant = 362;
    fjWebView.hidden = YES;
    delFileBtn.hidden = YES;
}

-(void)alertWithTable:(UITableView *)tableView
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"\n\n\n\n\n\n\n\n\n\n\n\n"//改变UIAlertController高度
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    alert.view.backgroundColor = [UIColor whiteColor];
    CGRect pickerFrame = CGRectMake(0, 40, _MainScreen_Width-16, 200);
    tableView.frame = pickerFrame;
    
    [alert.view addSubview:tableView];
    
    UIToolbar *toolView = [[UIToolbar alloc] initWithFrame:CGRectMake(32, 0, alert.view.frame.size.width-80, 40)];
    toolView.backgroundColor = [UIColor whiteColor];
    toolView.barStyle = UIBarStyleDefault;
    
    UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, alert.view.frame.size.width-104, 40)];
    tLabel.backgroundColor = [UIColor clearColor];
    tLabel.font = [UIFont systemFontOfSize:18];
    tLabel.textColor = [UIColor blackColor];
    tLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString *title = [NSString stringWithFormat:@"收件人选择"];
    tLabel.text = title;
    UIBarButtonItem *bbtTitle = [[UIBarButtonItem alloc] initWithCustomView:tLabel];
    toolView.items = [NSArray arrayWithObjects:bbtTitle, nil];
    toolView.backgroundColor = [UIColor clearColor];
    
    [alert.view addSubview:toolView];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:otherAction];
    
    [self presentViewController:alert animated:YES completion:nil];
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
            [personTableView reloadData];
            
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
    NSString *string = [NSString stringWithFormat:@"%d",section];
    
    if ([selectedArr containsObject:string]) {
        
        UIImageView *imageV = (UIImageView *)[personTableView viewWithTag:20000+section];
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
    NSString *string = [NSString stringWithFormat:@"%d",section];
    
    if ([selectedArr containsObject:string]) {
        imageView.image = [UIImage imageNamed:@"DownAccessory"];
    }
    else
    {
        imageView.image = [UIImage imageNamed:@"UpAccessory"];
    }
    [view addSubview:imageView];
    
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width-24, 11, 18, 18)];
    [selectBtn setImage:[UIImage imageNamed:@"pic_checkbox_normal3"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"pic_checkbox_selected3"] forState:UIControlStateHighlighted];
    [selectBtn setImage:[UIImage imageNamed:@"pic_checkbox_selected3"] forState:UIControlStateSelected];
    [selectBtn setImage:[UIImage imageNamed:@"pic_checkbox_normal3"] forState:UIControlStateSelected | UIControlStateHighlighted];
    selectBtn.tag = section;
    [selectBtn addTarget:self action:@selector(checkBoxSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *indexStr = [NSString stringWithFormat:@"%d", section];
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
    button.frame = CGRectMake(0, 0, tableView.frame.size.width, 40);
    button.tag = 100+section;
    [button addTarget:self action:@selector(openButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UIView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, tableView.frame.size.width, 1)];
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    [view addSubview:lineView];
    [view addSubview:selectBtn];
    
    return view;
}

- (void)checkBoxSelect:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSString *indexStr = [NSString stringWithFormat:@"%d", btn.tag];
    NSArray *array = dic[indexStr];
    for (int i=0; i<[array count]; i++) {
        if (btn.isSelected) {
            [selectedArray removeObject:array[i]];
        }else{
            [selectedArray addObject:array[i]];
        }
    }
    NSString *revicer = @"";
    for (int i=0; i<[selectedArray count]; i++) {
        NSDictionary *d = selectedArray[i];
        if (i==0) {
            revicer = [d objectForKey:@"realname"];
        }else{
            revicer = [NSString stringWithFormat:@"%@,%@",revicer,[d objectForKey:@"realname"]];
        }
    }
    revicerField.text = revicer;
    [personTableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //当前是第几个表头
    NSString *indexStr = [NSString stringWithFormat:@"%d",indexPath.section];
    
    static NSString *CellIdentifier = @"MainCell";
    
    ZXContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ZXContactCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    if ([selectedArr containsObject:indexStr]) {
        cell.nameLabel.text = dic[indexStr][indexPath.row][@"realname"];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    if ([selectedArray containsObject:dic[indexStr][indexPath.row]]) {
        cell.selectImageView.image = [UIImage imageNamed:@"pic_checkbox_selected3"];
    }else{
        cell.selectImageView.image = [UIImage imageNamed:@"pic_checkbox_normal3"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [personTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *indexStr = [NSString stringWithFormat:@"%d",indexPath.section];
    
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
    NSString *revicer = @"";
    for (int i=0; i<[selectedArray count]; i++) {
        NSDictionary *d = selectedArray[i];
        if (i==0) {
            revicer = [d objectForKey:@"realname"];
        }else{
            revicer = [NSString stringWithFormat:@"%@,%@",revicer,[d objectForKey:@"realname"]];
        }
    }
    revicerField.text = revicer;
    [personTableView reloadData];
}

-(void)openButton:(UIButton *)sender
{
    NSString *string = [NSString stringWithFormat:@"%d",sender.tag-100];
    
    //数组selectedArr里面存的数据和表头想对应，方便以后做比较
    if ([selectedArr containsObject:string])
    {
        [selectedArr removeObject:string];
    }
    else
    {
        [selectedArr addObject:string];
    }
    
    [personTableView reloadData];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 102) {//默认是本机
        if (buttonIndex == 0) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            imagePicker.allowsEditing = YES;
            [self presentModalViewController:imagePicker animated:YES];
        }else if (buttonIndex == 1) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            imagePicker.allowsEditing = YES;
            [self presentModalViewController:imagePicker animated:YES];
        }
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        uploadFileName = [representation filename];
        NSLog(@"fileName : %@",uploadFileName);
        UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            // UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }
        
        [self saveImage:image WithName:uploadFileName];
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:nil];
    
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName {
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
    
    fileField.text = fullPathToFile;
}

@end
