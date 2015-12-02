//
//  ZXWorkShenpiViewController.m
//  XTBG
//
//  Created by vchao on 15/1/31.
//  Copyright (c) 2015年 rzzx. All rights reserved.
//

#import "ZXWorkShenpiViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "NSObject+SBJson.h"

@implementation ZXWorkShenpiViewController

@synthesize infoDictionary;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    pishiLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 72, 70, 30)];
    pishiLabel.font = [UIFont systemFontOfSize:14.f];
    pishiLabel.textColor = [UIColor lightGrayColor];
    pishiLabel.text = @"批示意见：";
    pishiLabel.textAlignment = NSTextAlignmentRight;
    [contentScrollView addSubview:pishiLabel];
    
    pishiView = [[UITextView alloc] initWithFrame:CGRectMake(94, 72, _MainScreen_Width-110, 90)];
    pishiView.layer.cornerRadius = 4;
    pishiView.layer.masksToBounds = YES;
    pishiView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    pishiView.layer.borderWidth = 0.5f;
    pishiView.font = [UIFont systemFontOfSize:14.f];
    [contentScrollView addSubview:pishiView];
    
    caozuoLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 72+38, 70, 30)];
    caozuoLabel.font = [UIFont systemFontOfSize:14.f];
    caozuoLabel.textColor = [UIColor lightGrayColor];
    caozuoLabel.text = @"操作类型：";
    caozuoLabel.textAlignment = NSTextAlignmentRight;
    [contentScrollView addSubview:caozuoLabel];
    
    passBtn = [[UIButton alloc] initWithFrame:CGRectMake(94, 72+42, 75, 26)];
    passBtn.backgroundColor = [UIColor clearColor];
    [passBtn setTitle:@"通过" forState:UIControlStateNormal];
    [passBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [passBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [passBtn setTitle:@"通过" forState:UIControlStateSelected];
    [passBtn setImage:[UIImage imageNamed:@"单选未选"] forState:UIControlStateNormal];
    [passBtn setImage:[UIImage imageNamed:@"单选选中"] forState:UIControlStateHighlighted];
    [passBtn setImage:[UIImage imageNamed:@"单选选中"] forState:UIControlStateSelected];
    [passBtn setImage:[UIImage imageNamed:@"单选未选"] forState:(UIControlStateSelected|UIControlStateHighlighted)];
    [passBtn setImageEdgeInsets:UIEdgeInsetsMake(5.0, 10.0, 4.0, 48.0)];
    [passBtn setTitleEdgeInsets:UIEdgeInsetsMake(5.0, 18.0, 3.0, 0.0)];
    passBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [passBtn addTarget:self action:@selector(tapPassBtn:) forControlEvents:UIControlEventTouchUpInside];
    [passBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [contentScrollView addSubview:passBtn];
    
    unPassBtn = [[UIButton alloc] initWithFrame:CGRectMake(94, 72+42+34, 75, 26)];
    unPassBtn.backgroundColor = [UIColor clearColor];
    [unPassBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    [unPassBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [unPassBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [unPassBtn setTitle:@"拒绝" forState:UIControlStateSelected];
    [unPassBtn setImage:[UIImage imageNamed:@"单选未选"] forState:UIControlStateNormal];
    [unPassBtn setImage:[UIImage imageNamed:@"单选选中"] forState:UIControlStateHighlighted];
    [unPassBtn setImage:[UIImage imageNamed:@"单选选中"] forState:UIControlStateSelected];
    [unPassBtn setImage:[UIImage imageNamed:@"单选未选"] forState:(UIControlStateSelected|UIControlStateHighlighted)];
    [unPassBtn setImageEdgeInsets:UIEdgeInsetsMake(5.0, 10.0, 4.0, 48.0)];
    [unPassBtn setTitleEdgeInsets:UIEdgeInsetsMake(5.0, 18.0, 3.0, 0.0)];
    unPassBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [unPassBtn addTarget:self action:@selector(tapUnPassBtn:) forControlEvents:UIControlEventTouchUpInside];
    [unPassBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [contentScrollView addSubview:unPassBtn];
    
    spUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 72+106, 70, 30)];
    spUserLabel.font = [UIFont systemFontOfSize:14.f];
    spUserLabel.textColor = [UIColor lightGrayColor];
    spUserLabel.text = @"审批人员：";
    spUserLabel.textAlignment = NSTextAlignmentRight;
    [contentScrollView addSubview:spUserLabel];
    spUserLabel.hidden = YES;
    
    userLabel = [[UILabel alloc] initWithFrame:CGRectMake(94, 72+106, _MainScreen_Width-110, 30)];
    userLabel.font = [UIFont systemFontOfSize:14.f];
    [contentScrollView addSubview:userLabel];
    userLabel.hidden = YES;
    
    submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(16, 72+106+38, _MainScreen_Width-32, 40)];
    UIImage *loginBg = SY_IMAGE(@"pic_btn_normal_gray");
    UIEdgeInsets logininsets = UIEdgeInsetsMake(5, 5, 5, 5);
    loginBg = [loginBg resizableImageWithCapInsets:logininsets];
    [submitBtn setBackgroundImage:loginBg forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[SY_IMAGE(@"pic_btn_pressed_gray") resizableImageWithCapInsets:logininsets] forState:UIControlStateHighlighted];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(tapSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentScrollView addSubview:submitBtn];
    pishiLabel.hidden = YES;
    pishiView.hidden = YES;
    caozuoLabel.hidden = YES;
    passBtn.hidden = YES;
    unPassBtn.hidden = YES;
    submitBtn.hidden = YES;
    
    contentDict = [[NSDictionary alloc] init];
    [self getInfo];
}

- (IBAction)refreshInfo:(id)sender{
    [self getInfo];
}

- (void)getInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger uid = [userDefaults integerForKey:USER_ID];
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *URLString = [NSString stringWithFormat:@"%@/json2/gongwen.php?act=show&uid=%ld&id=%@",
                           API_DOMAIN,uid,[infoDictionary objectForKey:@"id"]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",[responseObject JSONValue]);
        NSMutableDictionary *resultDict = [responseObject JSONValue];
        NSArray *valueArray = [resultDict objectForKey:@"value"];
        contentDict = [valueArray objectAtIndex:0];
        [self refreshView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}

- (void)tapPassBtn:(id)sender{
    [passBtn setSelected:YES];
    [unPassBtn setSelected:NO];
}

- (void)tapUnPassBtn:(id)sender{
    [passBtn setSelected:NO];
    [unPassBtn setSelected:YES];
}

- (void)tapSubmitBtn:(id)sender{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger uid = [userDefaults integerForKey:USER_ID];
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *URLString = [NSString stringWithFormat:@"%@/json2/work.php?act=add&uid=%ld&id=%@",
                           API_DOMAIN,uid,[infoDictionary objectForKey:@"id"]];
    
    NSDictionary *parameters =@{@"cont":pishiView.text,@"status":@"1"};//通过
    if (unPassBtn.isSelected) {
        parameters =@{@"cont":pishiView.text,@"status":@"0"};//拒绝
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",[responseObject JSONValue]);
        [self getInfo];//成功后重新刷新本页面
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"操作失败"];
    }];
}

- (void)refreshView{
//    NSDictionary *titleDict = [contentDict objectForKey:@"title"];
    NSString *title = [contentDict objectForKey:@"title"];
    self.title = title;
    
    NSDictionary *editDict = [contentDict objectForKey:@"edit"];
    NSInteger edit = [[editDict objectForKey:@"edit"] integerValue];
    if (edit == 1) {//可编辑
        pishiLabel.hidden = NO;
        pishiView.hidden = NO;
        caozuoLabel.hidden = NO;
        passBtn.hidden = NO;
        unPassBtn.hidden = NO;
        submitBtn.hidden = NO;
    }else{//查看
        pishiLabel.hidden = YES;
        pishiView.hidden = YES;
        caozuoLabel.hidden = YES;
        passBtn.hidden = YES;
        unPassBtn.hidden = YES;
        submitBtn.hidden = YES;
    }
    
    NSInteger mid = [[contentDict objectForKey:@"mid"] integerValue];
    if (mid == 1) {//会议室申请
        NSDictionary *rowing = [contentDict objectForKey:@"rowing"];
        
        UILabel *field1 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8, _MainScreen_Width-110, 30)];
        field1.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field1];
        field1.text = [rowing objectForKey:@"data1"];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, 70, 30)];
        label1.font = [UIFont systemFontOfSize:14.f];
        label1.textColor = [UIColor lightGrayColor];
        label1.text = @"申请部门：";
        label1.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label1];
        
        UILabel *field2 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38, _MainScreen_Width-110, 30)];
        field2.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field2];
        field2.text = [rowing objectForKey:@"data2"];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38, 70, 30)];
        label2.font = [UIFont systemFontOfSize:14.f];
        label2.textColor = [UIColor lightGrayColor];
        label2.text = @"申请人：";
        label2.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label2];
        
        UILabel *field3 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*2, _MainScreen_Width-110, 30)];
        field3.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field3];
        field3.text = [rowing objectForKey:@"data3"];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*2, 70, 30)];
        label3.font = [UIFont systemFontOfSize:14.f];
        label3.textColor = [UIColor lightGrayColor];
        label3.text = @"申请日期：";
        label3.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label3];
        
        UILabel *field4 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*3, _MainScreen_Width-110, 30)];
        field4.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field4];
        field4.text = [rowing objectForKey:@"data4"];
        
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*3, 70, 30)];
        label4.font = [UIFont systemFontOfSize:14.f];
        label4.textColor = [UIColor lightGrayColor];
        label4.text = @"会议主题：";
        label4.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label4];
        
        UILabel *field5 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*4, _MainScreen_Width-110, 30)];
        field5.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field5];
        field5.text = [rowing objectForKey:@"data5"];
        
        UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*4, 70, 30)];
        label5.font = [UIFont systemFontOfSize:14.f];
        label5.textColor = [UIColor lightGrayColor];
        label5.text = @"会议时间：";
        label5.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label5];
        
        UILabel *field6 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*5, _MainScreen_Width-110, 30)];
        field6.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field6];
        field6.text = [rowing objectForKey:@"lasttype"];
        
        UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*5, 70, 30)];
        label6.font = [UIFont systemFontOfSize:14.f];
        label6.textColor = [UIColor lightGrayColor];
        label6.text = @"持续时间：";
        label6.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label6];
        
        UILabel *field7 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*6, _MainScreen_Width-110, 30)];
        field7.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field7];
        NSInteger room = [[rowing objectForKey:@"data7"] integerValue];
        NSString *meetingRoom = @"1000";
        if (room == 2) {
            meetingRoom = @"1032";
        }else if (room == 3) {
            meetingRoom = @"1031";
        }else if (room == 3) {
            meetingRoom = @"0900";
        }
        field7.text = meetingRoom;
        
        UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*6, 70, 30)];
        label7.font = [UIFont systemFontOfSize:14.f];
        label7.textColor = [UIColor lightGrayColor];
        label7.text = @"会议室：";
        label7.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label7];
        
        UILabel *field8 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*7, _MainScreen_Width-110, 30)];
        field8.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field8];
        field8.text = [rowing objectForKey:@"data8"];
        
        UILabel *label8 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*7, 70, 30)];
        label8.font = [UIFont systemFontOfSize:14.f];
        label8.textColor = [UIColor lightGrayColor];
        label8.text = @"备注：";
        label8.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label8];
        
        if (edit == 0) {
            contentScrollView.contentSize = CGSizeMake(_MainScreen_Width, 8+38*8);
        }else{
            pishiView.frame = CGRectMake(94, 8+38*8, _MainScreen_Width-110, 90);
            pishiLabel.frame = CGRectMake(16, 8+38*8+30, 70, 30);
            
            caozuoLabel.frame = CGRectMake(16, 8+38*8+90+19, 70, 30);
            passBtn.frame = CGRectMake(94, 8+38*8+90+4, 75, 26);
            unPassBtn.frame = CGRectMake(94, 8+38*8+90+38, 75, 26);
            [passBtn setSelected:YES];
            
            NSArray *userArray = [contentDict objectForKey:@"user"];
            if ([userArray count] > 0) {
                spUserLabel.hidden = NO;
                userLabel.hidden = NO;
                spUserLabel.frame = CGRectMake(16, 8+38*8+90+38+34, 70, 30);
                userLabel.frame = CGRectMake(94, 8+38*8+90+38+34, _MainScreen_Width-110, 30);
                NSDictionary *userDict = userArray[0];
                userLabel.text = [userDict objectForKey:@"WhoName"];
                
                submitBtn.frame = CGRectMake(16, 8+38*9+90+38+34, _MainScreen_Width-32, 40);
                
                contentScrollView.contentSize = CGSizeMake(_MainScreen_Width, 8+38*9+90+38+34+48);
            }else{
                spUserLabel.hidden = YES;
                userLabel.hidden = YES;
                
                submitBtn.frame = CGRectMake(16, 8+38*8+90+38+34, _MainScreen_Width-32, 40);
                
                contentScrollView.contentSize = CGSizeMake(_MainScreen_Width, 8+38*8+90+38+34+48);
            }
        }
    }else if (mid == 7 || mid == 10) {//工作会议呈报单和市领导参加会议活动呈报单
        NSDictionary *rowing = [contentDict objectForKey:@"rowing"];
        
        UILabel *field1 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8, _MainScreen_Width-110, 30)];
        field1.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field1];
        field1.text = [rowing objectForKey:@"data1"];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, 70, 30)];
        label1.font = [UIFont systemFontOfSize:14.f];
        label1.textColor = [UIColor lightGrayColor];
        label1.text = @"呈报单位：";
        label1.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label1];
        
        UILabel *field2 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38, _MainScreen_Width-110, 30)];
        field2.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field2];
        field2.text = [rowing objectForKey:@"data2"];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38, 70, 30)];
        label2.font = [UIFont systemFontOfSize:14.f];
        label2.textColor = [UIColor lightGrayColor];
        label2.text = @"呈报时间：";
        label2.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label2];
        
        UILabel *field3 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*2, _MainScreen_Width-110, 30)];
        field3.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field3];
        field3.text = [rowing objectForKey:@"data3"];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*2, 70, 30)];
        label3.font = [UIFont systemFontOfSize:14.f];
        label3.textColor = [UIColor lightGrayColor];
        label3.text = @"收件编号：";
        label3.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label3];
        
        UILabel *field4 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*3, _MainScreen_Width-110, 30)];
        field4.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field4];
        field4.text = [rowing objectForKey:@"data4"];
        
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*3, 70, 30)];
        label4.font = [UIFont systemFontOfSize:14.f];
        label4.textColor = [UIColor lightGrayColor];
        label4.text = @"负责人：";
        label4.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label4];
        
        UILabel *field5 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*4, _MainScreen_Width-110, 30)];
        field5.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field5];
        field5.text = [rowing objectForKey:@"data5"];
        
        UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*4, 70, 30)];
        label5.font = [UIFont systemFontOfSize:14.f];
        label5.textColor = [UIColor lightGrayColor];
        label5.text = @"联系人：";
        label5.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label5];
        
        UILabel *field6 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*5, _MainScreen_Width-110, 30)];
        field6.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field6];
        field6.text = [rowing objectForKey:@"data6"];
        
        UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*5, 70, 30)];
        label6.font = [UIFont systemFontOfSize:14.f];
        label6.textColor = [UIColor lightGrayColor];
        label6.text = @"电话：";
        label6.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label6];
        
        NSString *data7 = [rowing objectForKey:@"data7"];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.f]};
        CGRect rect =[data7 boundingRectWithSize:CGSizeMake(_MainScreen_Width-100, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
        CGFloat rectHeight = rect.size.height+8;
        UITextView *field7 = [[UITextView alloc] initWithFrame:CGRectMake(94, 8+38*6, _MainScreen_Width-110, rectHeight)];
        field7.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field7];
        field7.text = data7;
        
        UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*6, 70, 30)];
        label7.font = [UIFont systemFontOfSize:14.f];
        label7.textColor = [UIColor lightGrayColor];
        label7.text = @"呈报事项：";
        label7.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label7];
        
        NSString *data8 = [rowing objectForKey:@"data8"];
        CGRect rect8 =[data8 boundingRectWithSize:CGSizeMake(_MainScreen_Width-100, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
        CGFloat rectHeight8 = rect8.size.height+8;
        UITextView *field8 = [[UITextView alloc] initWithFrame:CGRectMake(94, 8+38*6+rectHeight+8, _MainScreen_Width-110, rectHeight8)];
        field8.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field8];
        field8.text = data8;
        
        UILabel *label8 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*6+rectHeight+8, 70, 30)];
        label8.font = [UIFont systemFontOfSize:14.f];
        label8.textColor = [UIColor lightGrayColor];
        label8.text = @"拟办意见：";
        label8.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label8];
        
        UILabel *label9 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*6+rectHeight+rectHeight8+16, 70, 30)];
        label9.font = [UIFont systemFontOfSize:14.f];
        label9.textColor = [UIColor lightGrayColor];
        label9.text = @"领导批示：";
        label9.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label9];
        
        NSInteger pishiHeight = 30;
        if (edit == 0) {
            NSArray *pishiArray = [contentDict objectForKey:@"pishi"];
            pishiHeight = [pishiArray count]*80;
            if (pishiHeight < 38) {
                pishiHeight = 38;
            }
            for (int i=0; i<[pishiArray count]; i++) {
                NSDictionary *pishi = pishiArray[i];
                
                UIView *pishiContView = [[UIView alloc] initWithFrame:CGRectMake(94, 8+38*6+rectHeight+rectHeight8+16+80*i, _MainScreen_Width-110, 80)];
                [contentScrollView addSubview:pishiContView];
                
                UILabel *psContLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _MainScreen_Width-110, 34)];
                psContLabel.numberOfLines = 2;
                psContLabel.font = [UIFont systemFontOfSize:14.f];
                psContLabel.lineBreakMode = NSLineBreakByWordWrapping;
                psContLabel.text = [pishi objectForKey:@"cont"];
                [pishiContView addSubview:psContLabel];
                
                UILabel *psUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 36, _MainScreen_Width-110, 18)];
                psUserLabel.text = [pishi objectForKey:@"user"];
                psUserLabel.font = [UIFont systemFontOfSize:12.f];
                psUserLabel.textAlignment = NSTextAlignmentRight;
                [pishiContView addSubview:psUserLabel];
                
                UILabel *psTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 54, _MainScreen_Width-110, 18)];
                psTimeLabel.text = [pishi objectForKey:@"time"];
                psTimeLabel.font = [UIFont systemFontOfSize:12.f];
                psTimeLabel.textAlignment = NSTextAlignmentRight;
                [pishiContView addSubview:psTimeLabel];
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 79, _MainScreen_Width-110, 1)];
                lineView.backgroundColor = [UIColor lightGrayColor];
                [pishiContView addSubview:lineView];
            }
        }else{
            UILabel *field9 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*6+rectHeight+rectHeight8+16, _MainScreen_Width-110, 30)];
            field9.font = [UIFont systemFontOfSize:14.f];
            [contentScrollView addSubview:field9];
            field9.text = @"";
        }
        
        
        UILabel *field10 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*6+pishiHeight+rectHeight+rectHeight8+16, _MainScreen_Width-110, 30)];
        field10.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field10];
        field10.text = @"";
        
        UILabel *label10 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*6+pishiHeight+rectHeight+rectHeight8+16, 70, 30)];
        label10.font = [UIFont systemFontOfSize:14.f];
        label10.textColor = [UIColor lightGrayColor];
        label10.text = @"备注：";
        label10.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label10];
        
        if (edit == 0) {
            contentScrollView.contentSize = CGSizeMake(_MainScreen_Width, 8+38*7+pishiHeight+rectHeight+rectHeight8+16);
        }else{
            pishiView.frame = CGRectMake(94, 8+38*8+rectHeight+rectHeight8+16, _MainScreen_Width-110, 90);
            pishiLabel.frame = CGRectMake(16, 8+38*8+30+rectHeight+rectHeight8+16, 70, 30);
            
            caozuoLabel.frame = CGRectMake(16, 8+38*8+90+19+rectHeight+rectHeight8+16, 70, 30);
            passBtn.frame = CGRectMake(94, 8+38*8+90+4+rectHeight+rectHeight8+16, 75, 26);
            unPassBtn.frame = CGRectMake(94, 8+38*8+90+38+rectHeight+rectHeight8+16, 75, 26);
            [passBtn setSelected:YES];
            
            NSArray *userArray = [contentDict objectForKey:@"user"];
            if ([userArray count] > 0) {
                spUserLabel.hidden = NO;
                userLabel.hidden = NO;
                spUserLabel.frame = CGRectMake(16, 8+38*8+90+38+34+rectHeight+rectHeight8+16, 70, 30);
                userLabel.frame = CGRectMake(94, 8+38*8+90+38+34+rectHeight+rectHeight8+16, _MainScreen_Width-110, 30);
                NSDictionary *userDict = userArray[0];
                userLabel.text = [userDict objectForKey:@"WhoName"];
                
                submitBtn.frame = CGRectMake(16, 8+38*9+90+38+34+rectHeight+rectHeight8+16, _MainScreen_Width-32, 40);
                
                contentScrollView.contentSize = CGSizeMake(_MainScreen_Width, 8+38*9+90+38+34+48+rectHeight+rectHeight8+16);
            }else{
                spUserLabel.hidden = YES;
                userLabel.hidden = YES;
                
                submitBtn.frame = CGRectMake(16, 8+38*8+90+38+34+rectHeight+rectHeight8+16, _MainScreen_Width-32, 40);
                
                contentScrollView.contentSize = CGSizeMake(_MainScreen_Width, 8+38*8+90+38+34+48+rectHeight+rectHeight8+16);
            }
        }
    }else if (mid == 8) {//来电来文办理单
        NSDictionary *rowing = [contentDict objectForKey:@"rowing"];
        
        UILabel *field1 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8, _MainScreen_Width-110, 30)];
        field1.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field1];
        field1.text = [rowing objectForKey:@"data1"];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, 70, 30)];
        label1.font = [UIFont systemFontOfSize:14.f];
        label1.textColor = [UIColor lightGrayColor];
        label1.text = @"来文单位：";
        label1.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label1];
        
        UILabel *field2 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38, _MainScreen_Width-110, 30)];
        field2.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field2];
        field2.text = [rowing objectForKey:@"data2"];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38, 70, 30)];
        label2.font = [UIFont systemFontOfSize:14.f];
        label2.textColor = [UIColor lightGrayColor];
        label2.text = @"来文时间：";
        label2.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label2];
        
        UILabel *field3 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*2, _MainScreen_Width-110, 30)];
        field3.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field3];
        field3.text = [rowing objectForKey:@"data3"];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*2, 70, 30)];
        label3.font = [UIFont systemFontOfSize:14.f];
        label3.textColor = [UIColor lightGrayColor];
        label3.text = @"收件编号：";
        label3.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label3];
        
        NSString *data7 = [rowing objectForKey:@"data4"];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.f]};
        CGRect rect =[data7 boundingRectWithSize:CGSizeMake(_MainScreen_Width-100, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
        CGFloat rectHeight = rect.size.height+8;
        UITextView *field7 = [[UITextView alloc] initWithFrame:CGRectMake(94, 8+38*3, _MainScreen_Width-110, rectHeight)];
        field7.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field7];
        field7.text = data7;
        
        UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*3, 70, 30)];
        label7.font = [UIFont systemFontOfSize:14.f];
        label7.textColor = [UIColor lightGrayColor];
        label7.text = @"文件标题：";
        label7.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label7];
        
        NSString *data8 = [rowing objectForKey:@"data5"];
        CGRect rect8 =[data8 boundingRectWithSize:CGSizeMake(_MainScreen_Width-100, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
        CGFloat rectHeight8 = rect8.size.height+8;
        UITextView *field8 = [[UITextView alloc] initWithFrame:CGRectMake(94, 8+38*3+rectHeight+8, _MainScreen_Width-110, rectHeight8)];
        field8.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field8];
        field8.text = data8;
        
        UILabel *label8 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*3+rectHeight+8, 70, 30)];
        label8.font = [UIFont systemFontOfSize:14.f];
        label8.textColor = [UIColor lightGrayColor];
        label8.text = @"拟办意见：";
        label8.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label8];
        
        NSInteger pishiHeight = 38;
        if (edit == 0) {
            NSArray *pishiArray = [contentDict objectForKey:@"pishi"];
            pishiHeight = [pishiArray count]*80;
            if (pishiHeight < 38) {
                pishiHeight = 38;
            }
            for (int i=0; i<[pishiArray count]; i++) {
                NSDictionary *pishi = pishiArray[i];
                
                UIView *pishiContView = [[UIView alloc] initWithFrame:CGRectMake(94, 8+38*3+rectHeight+rectHeight8+16+80*i, _MainScreen_Width-110, 80)];
                [contentScrollView addSubview:pishiContView];
                
                UILabel *psContLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _MainScreen_Width-110, 34)];
                psContLabel.numberOfLines = 2;
                psContLabel.font = [UIFont systemFontOfSize:14.f];
                psContLabel.lineBreakMode = NSLineBreakByWordWrapping;
                psContLabel.text = [pishi objectForKey:@"cont"];
                [pishiContView addSubview:psContLabel];
                
                UILabel *psUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 36, _MainScreen_Width-110, 18)];
                psUserLabel.text = [pishi objectForKey:@"user"];
                psUserLabel.font = [UIFont systemFontOfSize:12.f];
                psUserLabel.textAlignment = NSTextAlignmentRight;
                [pishiContView addSubview:psUserLabel];
                
                UILabel *psTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 54, _MainScreen_Width-110, 18)];
                psTimeLabel.text = [pishi objectForKey:@"time"];
                psTimeLabel.font = [UIFont systemFontOfSize:12.f];
                psTimeLabel.textAlignment = NSTextAlignmentRight;
                [pishiContView addSubview:psTimeLabel];
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 79, _MainScreen_Width-110, 1)];
                lineView.backgroundColor = [UIColor lightGrayColor];
                [pishiContView addSubview:lineView];
            }
        }else{
            UILabel *field9 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*3+rectHeight+rectHeight8+16, _MainScreen_Width-110, 30)];
            field9.font = [UIFont systemFontOfSize:14.f];
            [contentScrollView addSubview:field9];
            field9.text = @"";
        }
        
        UILabel *label9 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*3+rectHeight+rectHeight8+16, 70, 30)];
        label9.font = [UIFont systemFontOfSize:14.f];
        label9.textColor = [UIColor lightGrayColor];
        label9.text = @"领导批示：";
        label9.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label9];
        
        UILabel *field10 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*3+pishiHeight+rectHeight+rectHeight8+16, _MainScreen_Width-110, 30)];
        field10.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field10];
        field10.text = @"";
        
        UILabel *label10 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*3+pishiHeight+rectHeight+rectHeight8+16, 70, 30)];
        label10.font = [UIFont systemFontOfSize:14.f];
        label10.textColor = [UIColor lightGrayColor];
        label10.text = @"备注：";
        label10.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label10];
        
        if (edit == 0) {
            contentScrollView.contentSize = CGSizeMake(_MainScreen_Width, 8+38*4+pishiHeight+rectHeight+rectHeight8+16);
        }else{
            pishiView.frame = CGRectMake(94, 8+38*5+rectHeight+rectHeight8+16, _MainScreen_Width-110, 90);
            pishiLabel.frame = CGRectMake(16, 8+38*5+30+rectHeight+rectHeight8+16, 70, 30);
            
            caozuoLabel.frame = CGRectMake(16, 8+38*5+90+19+rectHeight+rectHeight8+16, 70, 30);
            passBtn.frame = CGRectMake(94, 8+38*5+90+4+rectHeight+rectHeight8+16, 75, 26);
            unPassBtn.frame = CGRectMake(94, 8+38*5+90+38+rectHeight+rectHeight8+16, 75, 26);
            [passBtn setSelected:YES];
            
            NSArray *userArray = [contentDict objectForKey:@"user"];
            if ([userArray count] > 0) {
                spUserLabel.hidden = NO;
                userLabel.hidden = NO;
                spUserLabel.frame = CGRectMake(16, 8+38*5+90+38+34+rectHeight+rectHeight8+16, 70, 30);
                userLabel.frame = CGRectMake(94, 8+38*5+90+38+34+rectHeight+rectHeight8+16, _MainScreen_Width-110, 30);
                NSDictionary *userDict = userArray[0];
                userLabel.text = [userDict objectForKey:@"WhoName"];
                
                submitBtn.frame = CGRectMake(16, 8+38*6+90+38+34+rectHeight+rectHeight8+16, _MainScreen_Width-32, 40);
                
                contentScrollView.contentSize = CGSizeMake(_MainScreen_Width, 8+38*6+90+38+34+48+rectHeight+rectHeight8+16);
            }else{
                spUserLabel.hidden = YES;
                userLabel.hidden = YES;
                
                submitBtn.frame = CGRectMake(16, 8+38*5+90+38+34+rectHeight+rectHeight8+16, _MainScreen_Width-32, 40);
                
                contentScrollView.contentSize = CGSizeMake(_MainScreen_Width, 8+38*5+90+38+34+48+rectHeight+rectHeight8+16);
            }
        }
    }else if (mid == 6) {//市政府办公室电话记录
        NSDictionary *rowing = [contentDict objectForKey:@"rowing"];
        
        UILabel *field1 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8, _MainScreen_Width-110, 30)];
        field1.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field1];
        field1.text = [rowing objectForKey:@"data1"];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, 70, 30)];
        label1.font = [UIFont systemFontOfSize:14.f];
        label1.textColor = [UIColor lightGrayColor];
        label1.text = @"发话单位：";
        label1.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label1];
        
        UILabel *field2 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38, _MainScreen_Width-110, 30)];
        field2.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field2];
        field2.text = [rowing objectForKey:@"data2"];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38, 70, 30)];
        label2.font = [UIFont systemFontOfSize:14.f];
        label2.textColor = [UIColor lightGrayColor];
        label2.text = @"发话人：";
        label2.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label2];
        
        UILabel *field3 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*2, _MainScreen_Width-110, 30)];
        field3.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field3];
        field3.text = [rowing objectForKey:@"data3"];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*2, 70, 30)];
        label3.font = [UIFont systemFontOfSize:14.f];
        label3.textColor = [UIColor lightGrayColor];
        label3.text = @"电话：";
        label3.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label3];
        
        UILabel *field4 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*3, _MainScreen_Width-110, 30)];
        field4.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field4];
        field4.text = [rowing objectForKey:@"data4"];
        
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*3, 70, 30)];
        label4.font = [UIFont systemFontOfSize:14.f];
        label4.textColor = [UIColor lightGrayColor];
        label4.text = @"接话人：";
        label4.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label4];
        
        UILabel *field5 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*4, _MainScreen_Width-110, 30)];
        field5.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field5];
        field5.text = [rowing objectForKey:@"data5"];
        
        UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*4, 70, 30)];
        label5.font = [UIFont systemFontOfSize:14.f];
        label5.textColor = [UIColor lightGrayColor];
        label5.text = @"接话时间：";
        label5.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label5];
        
        UILabel *field6 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*5, _MainScreen_Width-110, 30)];
        field6.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field6];
        field6.text = [rowing objectForKey:@"data6"];
        
        UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*5, 70, 30)];
        label6.font = [UIFont systemFontOfSize:14.f];
        label6.textColor = [UIColor lightGrayColor];
        label6.text = @"编号：";
        label6.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label6];
        
        NSString *data7 = [rowing objectForKey:@"data7"];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.f]};
        CGRect rect =[data7 boundingRectWithSize:CGSizeMake(_MainScreen_Width-100, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
        CGFloat rectHeight = rect.size.height+8;
        UITextView *field7 = [[UITextView alloc] initWithFrame:CGRectMake(94, 8+38*6, _MainScreen_Width-110, rectHeight)];
        field7.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field7];
        field7.text = data7;
        
        UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*6, 70, 30)];
        label7.font = [UIFont systemFontOfSize:14.f];
        label7.textColor = [UIColor lightGrayColor];
        label7.text = @"主要内容：";
        label7.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label7];
        
        NSString *data8 = [rowing objectForKey:@"data8"];
        CGRect rect8 =[data8 boundingRectWithSize:CGSizeMake(_MainScreen_Width-100, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
        CGFloat rectHeight8 = rect8.size.height+8;
        UITextView *field8 = [[UITextView alloc] initWithFrame:CGRectMake(94, 8+38*6+rectHeight+8, _MainScreen_Width-110, rectHeight8)];
        field8.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field8];
        field8.text = data8;
        
        UILabel *label8 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*6+rectHeight+8, 70, 30)];
        label8.font = [UIFont systemFontOfSize:14.f];
        label8.textColor = [UIColor lightGrayColor];
        label8.text = @"拟办意见：";
        label8.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label8];
        
        NSInteger pishiHeight = 38;
        if (edit == 0) {
            NSArray *pishiArray = [contentDict objectForKey:@"pishi"];
            pishiHeight = [pishiArray count]*80;
            if (pishiHeight < 38) {
                pishiHeight = 38;
            }
            for (int i=0; i<[pishiArray count]; i++) {
                NSDictionary *pishi = pishiArray[i];
                
                UIView *pishiContView = [[UIView alloc] initWithFrame:CGRectMake(94, 8+38*6+rectHeight+rectHeight8+16+80*i, _MainScreen_Width-110, 80)];
                [contentScrollView addSubview:pishiContView];
                
                UILabel *psContLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _MainScreen_Width-110, 34)];
                psContLabel.numberOfLines = 2;
                psContLabel.font = [UIFont systemFontOfSize:14.f];
                psContLabel.lineBreakMode = NSLineBreakByWordWrapping;
                psContLabel.text = [pishi objectForKey:@"cont"];
                [pishiContView addSubview:psContLabel];
                
                UILabel *psUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 36, _MainScreen_Width-110, 18)];
                psUserLabel.text = [pishi objectForKey:@"user"];
                psUserLabel.font = [UIFont systemFontOfSize:12.f];
                psUserLabel.textAlignment = NSTextAlignmentRight;
                [pishiContView addSubview:psUserLabel];
                
                UILabel *psTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 54, _MainScreen_Width-110, 18)];
                psTimeLabel.text = [pishi objectForKey:@"time"];
                psTimeLabel.font = [UIFont systemFontOfSize:12.f];
                psTimeLabel.textAlignment = NSTextAlignmentRight;
                [pishiContView addSubview:psTimeLabel];
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 79, _MainScreen_Width-110, 1)];
                lineView.backgroundColor = [UIColor lightGrayColor];
                [pishiContView addSubview:lineView];
            }
        }else{
            UILabel *field9 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*6+rectHeight+rectHeight8+16, _MainScreen_Width-110, 30)];
            field9.font = [UIFont systemFontOfSize:14.f];
            [contentScrollView addSubview:field9];
            field9.text = @"";
        }
        
        UILabel *label9 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*6+rectHeight+rectHeight8+16, 70, 30)];
        label9.font = [UIFont systemFontOfSize:14.f];
        label9.textColor = [UIColor lightGrayColor];
        label9.text = @"领导批示：";
        label9.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label9];
        
        UILabel *field10 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*6+pishiHeight+rectHeight+rectHeight8+16, _MainScreen_Width-110, 30)];
        field10.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field10];
        field10.text = @"";
        
        UILabel *label10 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*6+pishiHeight+rectHeight+rectHeight8+16, 70, 30)];
        label10.font = [UIFont systemFontOfSize:14.f];
        label10.textColor = [UIColor lightGrayColor];
        label10.text = @"备注：";
        label10.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label10];
        
        if (edit == 0) {
            contentScrollView.contentSize = CGSizeMake(_MainScreen_Width, 8+38*7+pishiHeight+rectHeight+rectHeight8+16);
        }else{
            pishiView.frame = CGRectMake(94, 8+38*8+rectHeight+rectHeight8+16, _MainScreen_Width-110, 90);
            pishiLabel.frame = CGRectMake(16, 8+38*8+30+rectHeight+rectHeight8+16, 70, 30);
            
            caozuoLabel.frame = CGRectMake(16, 8+38*8+90+19+rectHeight+rectHeight8+16, 70, 30);
            passBtn.frame = CGRectMake(94, 8+38*8+90+4+rectHeight+rectHeight8+16, 75, 26);
            unPassBtn.frame = CGRectMake(94, 8+38*8+90+38+rectHeight+rectHeight8+16, 75, 26);
            [passBtn setSelected:YES];
            
            NSArray *userArray = [contentDict objectForKey:@"user"];
            if ([userArray count] > 0) {
                spUserLabel.hidden = NO;
                userLabel.hidden = NO;
                spUserLabel.frame = CGRectMake(16, 8+38*8+90+38+34+rectHeight+rectHeight8+16, 70, 30);
                userLabel.frame = CGRectMake(94, 8+38*8+90+38+34+rectHeight+rectHeight8+16, _MainScreen_Width-110, 30);
                NSDictionary *userDict = userArray[0];
                userLabel.text = [userDict objectForKey:@"WhoName"];
                
                submitBtn.frame = CGRectMake(16, 8+38*9+90+38+34+rectHeight+rectHeight8+16, _MainScreen_Width-32, 40);
                
                contentScrollView.contentSize = CGSizeMake(_MainScreen_Width, 8+38*9+90+38+34+48+rectHeight+rectHeight8+16);
            }else{
                spUserLabel.hidden = YES;
                userLabel.hidden = YES;
                
                submitBtn.frame = CGRectMake(16, 8+38*8+90+38+34+rectHeight+rectHeight8+16, _MainScreen_Width-32, 40);
                
                contentScrollView.contentSize = CGSizeMake(_MainScreen_Width, 8+38*8+90+38+34+48+rectHeight+rectHeight8+16);
            }
        }
    }else if (mid == 13) {//预警信息
        NSDictionary *rowing = [contentDict objectForKey:@"rowing"];
        
        UILabel *field1 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8, _MainScreen_Width-110, 30)];
        field1.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field1];
        field1.text = [rowing objectForKey:@"data1"];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, 70, 30)];
        label1.font = [UIFont systemFontOfSize:14.f];
        label1.textColor = [UIColor lightGrayColor];
        label1.text = @"来文单位：";
        label1.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label1];
        
        UILabel *field2 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38, _MainScreen_Width-110, 30)];
        field2.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field2];
        field2.text = [rowing objectForKey:@"data2"];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38, 70, 30)];
        label2.font = [UIFont systemFontOfSize:14.f];
        label2.textColor = [UIColor lightGrayColor];
        label2.text = @"来文时间：";
        label2.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label2];
        
        UILabel *field3 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*2, _MainScreen_Width-110, 30)];
        field3.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field3];
        field3.text = [rowing objectForKey:@"data3"];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*2, 70, 30)];
        label3.font = [UIFont systemFontOfSize:14.f];
        label3.textColor = [UIColor lightGrayColor];
        label3.text = @"接收人：";
        label3.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label3];
        
        NSString *data7 = [rowing objectForKey:@"data4"];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.f]};
        CGRect rect =[data7 boundingRectWithSize:CGSizeMake(_MainScreen_Width-100, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
        CGFloat rectHeight = rect.size.height+8;
        UITextView *field7 = [[UITextView alloc] initWithFrame:CGRectMake(94, 8+38*3, _MainScreen_Width-110, rectHeight)];
        field7.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field7];
        field7.text = data7;
        
        UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*3, 70, 30)];
        label7.font = [UIFont systemFontOfSize:14.f];
        label7.textColor = [UIColor lightGrayColor];
        label7.text = @"文件标题：";
        label7.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label7];
        
        NSString *data8 = [rowing objectForKey:@"data5"];
        CGRect rect8 =[data8 boundingRectWithSize:CGSizeMake(_MainScreen_Width-100, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
        CGFloat rectHeight8 = rect8.size.height+8;
        UITextView *field8 = [[UITextView alloc] initWithFrame:CGRectMake(94, 8+38*3+rectHeight+8, _MainScreen_Width-110, rectHeight8)];
        field8.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field8];
        field8.text = data8;
        
        UILabel *label8 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*3+rectHeight+8, 70, 30)];
        label8.font = [UIFont systemFontOfSize:14.f];
        label8.textColor = [UIColor lightGrayColor];
        label8.text = @"拟办意见：";
        label8.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label8];
        
        NSInteger pishiHeight = 38;
        if (edit == 0) {
            NSArray *pishiArray = [contentDict objectForKey:@"pishi"];
            pishiHeight = [pishiArray count]*80;
            if (pishiHeight < 38) {
                pishiHeight = 38;
            }
            for (int i=0; i<[pishiArray count]; i++) {
                NSDictionary *pishi = pishiArray[i];
                
                UIView *pishiContView = [[UIView alloc] initWithFrame:CGRectMake(94, 8+38*3+rectHeight+rectHeight8+16+80*i, _MainScreen_Width-110, 80)];
                [contentScrollView addSubview:pishiContView];
                
                UILabel *psContLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _MainScreen_Width-110, 34)];
                psContLabel.numberOfLines = 2;
                psContLabel.font = [UIFont systemFontOfSize:14.f];
                psContLabel.lineBreakMode = NSLineBreakByWordWrapping;
                psContLabel.text = [pishi objectForKey:@"cont"];
                [pishiContView addSubview:psContLabel];
                
                UILabel *psUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 36, _MainScreen_Width-110, 18)];
                psUserLabel.text = [pishi objectForKey:@"user"];
                psUserLabel.font = [UIFont systemFontOfSize:12.f];
                psUserLabel.textAlignment = NSTextAlignmentRight;
                [pishiContView addSubview:psUserLabel];
                
                UILabel *psTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 54, _MainScreen_Width-110, 18)];
                psTimeLabel.text = [pishi objectForKey:@"time"];
                psTimeLabel.font = [UIFont systemFontOfSize:12.f];
                psTimeLabel.textAlignment = NSTextAlignmentRight;
                [pishiContView addSubview:psTimeLabel];
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 79, _MainScreen_Width-110, 1)];
                lineView.backgroundColor = [UIColor lightGrayColor];
                [pishiContView addSubview:lineView];
            }
        }else{
            UILabel *field9 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*3+rectHeight+rectHeight8+16, _MainScreen_Width-110, 30)];
            field9.font = [UIFont systemFontOfSize:14.f];
            [contentScrollView addSubview:field9];
            field9.text = @"";
        }
        
        UILabel *label9 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*3+rectHeight+rectHeight8+16, 70, 30)];
        label9.font = [UIFont systemFontOfSize:14.f];
        label9.textColor = [UIColor lightGrayColor];
        label9.text = @"领导批示：";
        label9.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label9];
        
        UILabel *field10 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*3+pishiHeight+rectHeight+rectHeight8+16, _MainScreen_Width-110, 30)];
        field10.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field10];
        field10.text = @"";
        
        UILabel *label10 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*3+pishiHeight+rectHeight+rectHeight8+16, 70, 30)];
        label10.font = [UIFont systemFontOfSize:14.f];
        label10.textColor = [UIColor lightGrayColor];
        label10.text = @"备注：";
        label10.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label10];
        
        if (edit == 0) {
            contentScrollView.contentSize = CGSizeMake(_MainScreen_Width, 8+38*4+pishiHeight+rectHeight+rectHeight8+16);
        }else{
            pishiView.frame = CGRectMake(94, 8+38*5+rectHeight+rectHeight8+16, _MainScreen_Width-110, 90);
            pishiLabel.frame = CGRectMake(16, 8+38*5+30+rectHeight+rectHeight8+16, 70, 30);
            
            caozuoLabel.frame = CGRectMake(16, 8+38*5+90+19+rectHeight+rectHeight8+16, 70, 30);
            passBtn.frame = CGRectMake(94, 8+38*5+90+4+rectHeight+rectHeight8+16, 75, 26);
            unPassBtn.frame = CGRectMake(94, 8+38*5+90+38+rectHeight+rectHeight8+16, 75, 26);
            [passBtn setSelected:YES];
            
            NSArray *userArray = [contentDict objectForKey:@"user"];
            if ([userArray count] > 0) {
                spUserLabel.hidden = NO;
                userLabel.hidden = NO;
                spUserLabel.frame = CGRectMake(16, 8+38*5+90+38+34+rectHeight+rectHeight8+16, 70, 30);
                userLabel.frame = CGRectMake(94, 8+38*5+90+38+34+rectHeight+rectHeight8+16, _MainScreen_Width-110, 30);
                NSDictionary *userDict = userArray[0];
                userLabel.text = [userDict objectForKey:@"WhoName"];
                
                submitBtn.frame = CGRectMake(16, 8+38*6+90+38+34+rectHeight+rectHeight8+16, _MainScreen_Width-32, 40);
                
                contentScrollView.contentSize = CGSizeMake(_MainScreen_Width, 8+38*6+90+38+34+48+rectHeight+rectHeight8+16);
            }else{
                spUserLabel.hidden = YES;
                userLabel.hidden = YES;
                
                submitBtn.frame = CGRectMake(16, 8+38*5+90+38+34+rectHeight+rectHeight8+16, _MainScreen_Width-32, 40);
                
                contentScrollView.contentSize = CGSizeMake(_MainScreen_Width, 8+38*5+90+38+34+48+rectHeight+rectHeight8+16);
            }
        }
    }else if (mid == 15) {//办公用品申请
        NSDictionary *rowing = [contentDict objectForKey:@"rowing"];
        
        NSString *data7 = [rowing objectForKey:@"data1"];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.f]};
        CGRect rect =[data7 boundingRectWithSize:CGSizeMake(_MainScreen_Width-100, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
        CGFloat rectHeight = rect.size.height+8;
        if (rectHeight < 68) {
            rectHeight = 68;
        }
        UITextView *field7 = [[UITextView alloc] initWithFrame:CGRectMake(94, 8, _MainScreen_Width-110, rectHeight)];
        field7.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field7];
        field7.text = data7;
        
        UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, 70, 68)];
        label7.font = [UIFont systemFontOfSize:14.f];
        label7.textColor = [UIColor lightGrayColor];
        label7.text = @"购置办公用品名称、数量、用途及概算费用：";
        label7.lineBreakMode = NSLineBreakByWordWrapping;
        label7.numberOfLines = 4;
        label7.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label7];
        
        NSInteger pishiHeight = 38;
        if (edit == 0) {
            NSArray *pishiArray = [contentDict objectForKey:@"pishi"];
            pishiHeight = [pishiArray count]*80;
            if (pishiHeight < 38) {
                pishiHeight = 38;
            }
            for (int i=0; i<[pishiArray count]; i++) {
                NSDictionary *pishi = pishiArray[i];
                
                UIView *pishiContView = [[UIView alloc] initWithFrame:CGRectMake(94, 8+rectHeight+16+80*i, _MainScreen_Width-110, 80)];
                [contentScrollView addSubview:pishiContView];
                
                UILabel *psContLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _MainScreen_Width-110, 34)];
                psContLabel.numberOfLines = 2;
                psContLabel.font = [UIFont systemFontOfSize:14.f];
                psContLabel.lineBreakMode = NSLineBreakByWordWrapping;
                psContLabel.text = [pishi objectForKey:@"cont"];
                [pishiContView addSubview:psContLabel];
                
                UILabel *psUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 36, _MainScreen_Width-110, 18)];
                psUserLabel.text = [pishi objectForKey:@"user"];
                psUserLabel.font = [UIFont systemFontOfSize:12.f];
                psUserLabel.textAlignment = NSTextAlignmentRight;
                [pishiContView addSubview:psUserLabel];
                
                UILabel *psTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 54, _MainScreen_Width-110, 18)];
                psTimeLabel.text = [pishi objectForKey:@"time"];
                psTimeLabel.font = [UIFont systemFontOfSize:12.f];
                psTimeLabel.textAlignment = NSTextAlignmentRight;
                [pishiContView addSubview:psTimeLabel];
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 79, _MainScreen_Width-110, 1)];
                lineView.backgroundColor = [UIColor lightGrayColor];
                [pishiContView addSubview:lineView];
            }
        }else{
            UILabel *field9 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+rectHeight+16, _MainScreen_Width-110, 30)];
            field9.font = [UIFont systemFontOfSize:14.f];
            [contentScrollView addSubview:field9];
            field9.text = @"";
        }
        
        UILabel *label9 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+rectHeight+16, 70, 30)];
        label9.font = [UIFont systemFontOfSize:14.f];
        label9.textColor = [UIColor lightGrayColor];
        label9.text = @"领导批示：";
        label9.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label9];
        
        NSString *data10 = @"1、购置办公用品及其他物品，先填写购置办公用品审批单，填清购置物品的名称、数量、用途及概算费用，由科室（中心）负责人、经办人签字，行政联络科提出意见，分管领导签意见，视情报领导批示。经以上程序审批同意后按规定采购。2、集中结算时，将审批单附在发票后面，按程序审核后结算。";
        CGRect rect10 =[data10 boundingRectWithSize:CGSizeMake(_MainScreen_Width-100, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
        CGFloat rectHeight10 = rect10.size.height+8;
        
        UITextView *field10 = [[UITextView alloc] initWithFrame:CGRectMake(94, 8+pishiHeight+rectHeight+16, _MainScreen_Width-110, rectHeight10)];
        field10.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field10];
        field10.text = data10;
        
        UILabel *label10 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+pishiHeight+rectHeight+16, 70, 30)];
        label10.font = [UIFont systemFontOfSize:14.f];
        label10.textColor = [UIColor lightGrayColor];
        label10.text = @"备注：";
        label10.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label10];
        
        if (edit == 0) {
            contentScrollView.contentSize = CGSizeMake(_MainScreen_Width, 8+pishiHeight+rectHeight+rectHeight10+16);
        }else{
            pishiView.frame = CGRectMake(94, 8+38+rectHeight+rectHeight10+16, _MainScreen_Width-110, 90);
            pishiLabel.frame = CGRectMake(16, 8+38+30+rectHeight+rectHeight10+16, 70, 30);
            
            caozuoLabel.frame = CGRectMake(16, 8+38+90+19+rectHeight+rectHeight10+16, 70, 30);
            passBtn.frame = CGRectMake(94, 8+38+90+4+rectHeight+rectHeight10+16, 75, 26);
            unPassBtn.frame = CGRectMake(94, 8+38+90+38+rectHeight+rectHeight10+16, 75, 26);
            [passBtn setSelected:YES];
            
            NSArray *userArray = [contentDict objectForKey:@"user"];
            if ([userArray count] > 0) {
                spUserLabel.hidden = NO;
                userLabel.hidden = NO;
                spUserLabel.frame = CGRectMake(16, 8+38+90+38+34+rectHeight+rectHeight10+16, 70, 30);
                userLabel.frame = CGRectMake(94, 8+38+90+38+34+rectHeight+rectHeight10+16, _MainScreen_Width-110, 30);
                NSDictionary *userDict = userArray[0];
                userLabel.text = [userDict objectForKey:@"WhoName"];
                
                submitBtn.frame = CGRectMake(16, 8+38*2+90+38+34+rectHeight+rectHeight10+16, _MainScreen_Width-32, 40);
                
                contentScrollView.contentSize = CGSizeMake(_MainScreen_Width, 8+38*2+90+38+34+48+rectHeight+rectHeight10+16);
            }else{
                spUserLabel.hidden = YES;
                userLabel.hidden = YES;
                
                submitBtn.frame = CGRectMake(16, 8+38+90+38+34+rectHeight+rectHeight10+16, _MainScreen_Width-32, 40);
                
                contentScrollView.contentSize = CGSizeMake(_MainScreen_Width, 8+38+90+38+34+48+rectHeight+rectHeight10+16);
            }
        }
    }else if (mid == 3) {//值班表
        NSDictionary *rowing = [contentDict objectForKey:@"rowing"];
        
        UILabel *field1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, _MainScreen_Width-32, 30)];
        field1.font = [UIFont systemFontOfSize:16.f];
        field1.textAlignment = NSTextAlignmentCenter;
        [contentScrollView addSubview:field1];
        field1.text = [NSString stringWithFormat:@"第 %@ 周值班表",[rowing objectForKey:@"data1"]];
        
        UILabel *field2 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38, _MainScreen_Width-110, 30)];
        field2.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field2];
        field2.text = [NSString stringWithFormat:@"%@~%@",[rowing objectForKey:@"data2"],[rowing objectForKey:@"data3"]];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38, 70, 30)];
        label2.font = [UIFont systemFontOfSize:14.f];
        label2.textColor = [UIColor lightGrayColor];
        label2.text = @"值班时间：";
        label2.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label2];
        
        UILabel *field3 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*2, _MainScreen_Width-110, 30)];
        field3.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field3];
        field3.text = [rowing objectForKey:@"data4"];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*2, 70, 30)];
        label3.font = [UIFont systemFontOfSize:14.f];
        label3.textColor = [UIColor lightGrayColor];
        label3.text = @"带班领导：";
        label3.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label3];
        
        UILabel *field4 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*3, _MainScreen_Width-110, 30)];
        field4.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field4];
        field4.text = [rowing objectForKey:@"data5"];
        
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*3, 70, 30)];
        label4.font = [UIFont systemFontOfSize:14.f];
        label4.textColor = [UIColor lightGrayColor];
        label4.text = @"值班组长：";
        label4.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label4];
        
        UILabel *field5 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*4, _MainScreen_Width-110, 30)];
        field5.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field5];
        field5.text = [rowing objectForKey:@"data6"];
        
        UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*4, 70, 30)];
        label5.font = [UIFont systemFontOfSize:14.f];
        label5.textColor = [UIColor lightGrayColor];
        label5.text = @"周一值班：";
        label5.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label5];
        
        UILabel *field6 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*5, _MainScreen_Width-110, 30)];
        field6.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field6];
        field6.text = [rowing objectForKey:@"data7"];
        
        UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*5, 70, 30)];
        label6.font = [UIFont systemFontOfSize:14.f];
        label6.textColor = [UIColor lightGrayColor];
        label6.text = @"周二值班：";
        label6.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label6];
        
        UILabel *field7 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*6, _MainScreen_Width-110, 30)];
        field7.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field7];
        field7.text = [rowing objectForKey:@"data8"];
        
        UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*6, 70, 30)];
        label7.font = [UIFont systemFontOfSize:14.f];
        label7.textColor = [UIColor lightGrayColor];
        label7.text = @"周三值班：";
        label7.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label7];
        
        UILabel *field8 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*7, _MainScreen_Width-110, 30)];
        field8.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field8];
        field8.text = [rowing objectForKey:@"data9"];
        
        UILabel *label8 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*7, 70, 30)];
        label8.font = [UIFont systemFontOfSize:14.f];
        label8.textColor = [UIColor lightGrayColor];
        label8.text = @"周四值班：";
        label8.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label8];
        
        UILabel *field9 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*8, _MainScreen_Width-110, 30)];
        field9.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field9];
        field9.text = [rowing objectForKey:@"data10"];
        
        UILabel *label9 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*8, 70, 30)];
        label9.font = [UIFont systemFontOfSize:14.f];
        label9.textColor = [UIColor lightGrayColor];
        label9.text = @"周五值班：";
        label9.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label9];
        
        UILabel *field10 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*9, _MainScreen_Width-110, 30)];
        field10.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field10];
        field10.text = [rowing objectForKey:@"data11"];
        
        UILabel *label10 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*9, 70, 30)];
        label10.font = [UIFont systemFontOfSize:14.f];
        label10.textColor = [UIColor lightGrayColor];
        label10.text = @"周六值班：";
        label10.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label10];
        
        UILabel *field11 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*10, _MainScreen_Width-110, 30)];
        field11.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field11];
        field11.text = [rowing objectForKey:@"data12"];
        
        UILabel *label11 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*10, 70, 30)];
        label11.font = [UIFont systemFontOfSize:14.f];
        label11.textColor = [UIColor lightGrayColor];
        label11.text = @"周日值班：";
        label11.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label11];
        
        UILabel *field12 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*11, _MainScreen_Width-110, 30)];
        field12.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field12];
        field12.text = @"12:00-14:00";
        
        UILabel *label12 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*11, 70, 30)];
        label12.font = [UIFont systemFontOfSize:14.f];
        label12.textColor = [UIColor lightGrayColor];
        label12.text = @"午间班：";
        label12.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label12];
        
        UILabel *field13 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*12, _MainScreen_Width-110, 30)];
        field13.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field13];
        field13.text = @"当日18:00-次日8:30";
        
        UILabel *label13 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*12, 70, 30)];
        label13.font = [UIFont systemFontOfSize:14.f];
        label13.textColor = [UIColor lightGrayColor];
        label13.text = @"夜间班：";
        label13.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label13];
        
        UILabel *field14 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*13, _MainScreen_Width-110, 30)];
        field14.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field14];
        field14.text = @"昼夜24小时";
        
        UILabel *label14 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*13, 70, 30)];
        label14.font = [UIFont systemFontOfSize:14.f];
        label14.textColor = [UIColor lightGrayColor];
        label14.text = @"周六、日：";
        label14.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label14];
        
        UILabel *field15 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*14, _MainScreen_Width-110, 30)];
        field15.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field15];
        field15.text = [rowing objectForKey:@"data15"];
        
        UILabel *label15 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*14, 70, 30)];
        label15.font = [UIFont systemFontOfSize:14.f];
        label15.textColor = [UIColor lightGrayColor];
        label15.text = @"值班秘书：";
        label15.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label15];
        
        if (edit == 0) {
            contentScrollView.contentSize = CGSizeMake(_MainScreen_Width, 8+38*15);
        }else{
            pishiView.frame = CGRectMake(94, 8+38*15, _MainScreen_Width-110, 90);
            pishiLabel.frame = CGRectMake(16, 8+38*15+30, 70, 30);
            
            caozuoLabel.frame = CGRectMake(16, 8+38*15+90+19, 70, 30);
            passBtn.frame = CGRectMake(94, 8+38*15+90+4, 75, 26);
            unPassBtn.frame = CGRectMake(94, 8+38*15+90+38, 75, 26);
            [passBtn setSelected:YES];
            
            NSArray *userArray = [contentDict objectForKey:@"user"];
            if ([userArray count] > 0) {
                spUserLabel.hidden = NO;
                userLabel.hidden = NO;
                spUserLabel.frame = CGRectMake(16, 8+38*15+90+38+34, 70, 30);
                userLabel.frame = CGRectMake(94, 8+38*15+90+38+34, _MainScreen_Width-110, 30);
                NSDictionary *userDict = userArray[0];
                userLabel.text = [userDict objectForKey:@"WhoName"];
                
                submitBtn.frame = CGRectMake(16, 8+38*16+90+38+34, _MainScreen_Width-32, 40);
                
                contentScrollView.contentSize = CGSizeMake(_MainScreen_Width, 8+38*16+90+38+34+48);
            }else{
                spUserLabel.hidden = YES;
                userLabel.hidden = YES;
                
                submitBtn.frame = CGRectMake(16, 8+38*15+90+38+34, _MainScreen_Width-32, 40);
                
                contentScrollView.contentSize = CGSizeMake(_MainScreen_Width, 8+38*15+90+38+34+48);
            }
        }
    }else if (mid == 14) {//领导活动
        NSDictionary *rowing = [contentDict objectForKey:@"rowing"];
        
        UILabel *field1 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8, _MainScreen_Width-110, 30)];
        field1.font = [UIFont systemFontOfSize:16.f];
        [contentScrollView addSubview:field1];
        field1.text = [rowing objectForKey:@"data3"];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, 70, 30)];
        label1.font = [UIFont systemFontOfSize:14.f];
        label1.textColor = [UIColor lightGrayColor];
        label1.text = @"期数：";
        label1.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label1];
        
        UILabel *field2 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38, _MainScreen_Width-110, 30)];
        field2.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field2];
        field2.text = [rowing objectForKey:@"data1"];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38, 70, 30)];
        label2.font = [UIFont systemFontOfSize:14.f];
        label2.textColor = [UIColor lightGrayColor];
        label2.text = @"调度人：";
        label2.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label2];
        
        UILabel *field3 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*2, _MainScreen_Width-110, 30)];
        field3.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field3];
        field3.text = [rowing objectForKey:@"data2"];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*2, 70, 30)];
        label3.font = [UIFont systemFontOfSize:14.f];
        label3.textColor = [UIColor lightGrayColor];
        label3.text = @"日期：";
        label3.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label3];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 8+38*3-4, _MainScreen_Width, 1)];
        line1.backgroundColor = [UIColor lightGrayColor];
        [contentScrollView addSubview:line1];
        
        NSArray *contentArray = [rowing objectForKey:@"content"];
        UIView *shu1 = [[UIView alloc] initWithFrame:CGRectMake(94, 8+38*3-4, 1, [contentArray count]*60+38)];
        shu1.backgroundColor = [UIColor lightGrayColor];
        [contentScrollView addSubview:shu1];
        UIView *shu2 = [[UIView alloc] initWithFrame:CGRectMake(_MainScreen_Width/3*2, 8+38*3-4, 1, [contentArray count]*60+38)];
        shu2.backgroundColor = [UIColor lightGrayColor];
        [contentScrollView addSubview:shu2];
        
        UILabel *biaoName = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*3, _MainScreen_Width/3-16, 30)];
        biaoName.font = [UIFont systemFontOfSize:14.f];
        biaoName.text = @"姓名";
        [contentScrollView addSubview:biaoName];
        UILabel *biaoCont = [[UILabel alloc] initWithFrame:CGRectMake(_MainScreen_Width/3+16, 8+38*3, _MainScreen_Width/3-16, 30)];
        biaoCont.font = [UIFont systemFontOfSize:14.f];
        biaoCont.text = @"内容";
        [contentScrollView addSubview:biaoCont];
        UILabel *biaoBeiz = [[UILabel alloc] initWithFrame:CGRectMake(_MainScreen_Width/3*2+16, 8+38*3, _MainScreen_Width/3-16, 30)];
        biaoBeiz.font = [UIFont systemFontOfSize:14.f];
        biaoBeiz.text = @"备注";
        [contentScrollView addSubview:biaoBeiz];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 8+38*4-4, _MainScreen_Width, 1)];
        line2.backgroundColor = [UIColor lightGrayColor];
        [contentScrollView addSubview:line2];
        
        NSInteger jichuY = 8+38*4;
        for (int i=0; i<[contentArray count]; i++) {
            NSDictionary *d = contentArray[i];
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, jichuY+i*60, 70, 30)];
            nameLabel.font = [UIFont systemFontOfSize:14.f];
            nameLabel.text = [d objectForKey:@"name"];
            [contentScrollView addSubview:nameLabel];
            
            UITextView *contLabel = [[UITextView alloc] initWithFrame:CGRectMake(2+94, jichuY+i*60-3, _MainScreen_Width-_MainScreen_Width/3-4-94, 60)];
            contLabel.font = [UIFont systemFontOfSize:14.f];
            contLabel.text = [d objectForKey:@"content"];
            [contentScrollView addSubview:contLabel];
            
            UITextView *bzLabel = [[UITextView alloc] initWithFrame:CGRectMake(2+_MainScreen_Width/3*2, jichuY+i*60-3, _MainScreen_Width/3-4, 60)];
            bzLabel.font = [UIFont systemFontOfSize:14.f];
            bzLabel.text = [d objectForKey:@"bz"];
            [contentScrollView addSubview:bzLabel];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, jichuY+(i+1)*60-4, _MainScreen_Width, 1)];
            lineView.backgroundColor = [UIColor lightGrayColor];
            [contentScrollView addSubview:lineView];
        }
        
        NSInteger pishiHeight = 38;
        if (edit == 0) {
            NSArray *pishiArray = [contentDict objectForKey:@"pishi"];
            pishiHeight = [pishiArray count]*80;
            if (pishiHeight < 38) {
                pishiHeight = 38;
            }
            for (int i=0; i<[pishiArray count]; i++) {
                NSDictionary *pishi = pishiArray[i];
                
                UIView *pishiContView = [[UIView alloc] initWithFrame:CGRectMake(94, 8+38*3-4+[contentArray count]*60+38+80*i, _MainScreen_Width-110, 80)];
                [contentScrollView addSubview:pishiContView];
                
                UILabel *psContLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _MainScreen_Width-110, 34)];
                psContLabel.numberOfLines = 2;
                psContLabel.font = [UIFont systemFontOfSize:14.f];
                psContLabel.lineBreakMode = NSLineBreakByWordWrapping;
                psContLabel.text = [pishi objectForKey:@"cont"];
                [pishiContView addSubview:psContLabel];
                
                UILabel *psUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 36, _MainScreen_Width-110, 18)];
                psUserLabel.text = [pishi objectForKey:@"user"];
                psUserLabel.font = [UIFont systemFontOfSize:12.f];
                psUserLabel.textAlignment = NSTextAlignmentRight;
                [pishiContView addSubview:psUserLabel];
                
                UILabel *psTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 54, _MainScreen_Width-110, 18)];
                psTimeLabel.text = [pishi objectForKey:@"time"];
                psTimeLabel.font = [UIFont systemFontOfSize:12.f];
                psTimeLabel.textAlignment = NSTextAlignmentRight;
                [pishiContView addSubview:psTimeLabel];
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 79, _MainScreen_Width-110, 1)];
                lineView.backgroundColor = [UIColor lightGrayColor];
                [pishiContView addSubview:lineView];
            }
        }else{
            UILabel *field4 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*3-4+[contentArray count]*60+38, _MainScreen_Width-110, 30)];
            field4.font = [UIFont systemFontOfSize:14.f];
            [contentScrollView addSubview:field4];
            field4.text = @"";
        }
        
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*3-4+[contentArray count]*60+38, 70, 30)];
        label4.font = [UIFont systemFontOfSize:14.f];
        label4.textColor = [UIColor lightGrayColor];
        label4.text = @"领导批示：";
        label4.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label4];
        
        UILabel *field5 = [[UILabel alloc] initWithFrame:CGRectMake(94, 8+38*3-4+[contentArray count]*60+38+pishiHeight, _MainScreen_Width-110, 30)];
        field5.font = [UIFont systemFontOfSize:14.f];
        [contentScrollView addSubview:field5];
        field5.text = @"";
        
        UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(16, 8+38*3-4+[contentArray count]*60+38+pishiHeight, 70, 30)];
        label5.font = [UIFont systemFontOfSize:14.f];
        label5.textColor = [UIColor lightGrayColor];
        label5.text = @"备注：";
        label5.textAlignment = NSTextAlignmentRight;
        [contentScrollView addSubview:label5];
        
        if (edit == 0) {
            contentScrollView.contentSize = CGSizeMake(_MainScreen_Width, 8+38*5-4+[contentArray count]*60+38+pishiHeight);
        }else{
            pishiView.frame = CGRectMake(94, 8+38*5-4+[contentArray count]*60+38, _MainScreen_Width-110, 90);
            pishiLabel.frame = CGRectMake(16, 8+38*5-4+[contentArray count]*60+38+30, 70, 30);
            
            caozuoLabel.frame = CGRectMake(16, 8+38*5-4+[contentArray count]*60+38+90+19, 70, 30);
            passBtn.frame = CGRectMake(94, 8+38*5-4+[contentArray count]*60+38+90+4, 75, 26);
            unPassBtn.frame = CGRectMake(94, 8+38*5-4+[contentArray count]*60+38+90+38, 75, 26);
            [passBtn setSelected:YES];
            
            NSArray *userArray = [contentDict objectForKey:@"user"];
            if ([userArray count] > 0) {
                spUserLabel.hidden = NO;
                userLabel.hidden = NO;
                spUserLabel.frame = CGRectMake(16, 8+38*5-4+[contentArray count]*60+38+90+38+34, 70, 30);
                userLabel.frame = CGRectMake(94, 8+38*5-4+[contentArray count]*60+38+90+38+34, _MainScreen_Width-110, 30);
                NSDictionary *userDict = userArray[0];
                userLabel.text = [userDict objectForKey:@"WhoName"];
                
                submitBtn.frame = CGRectMake(16, 8+38*6-4+[contentArray count]*60+38+90+38+34, _MainScreen_Width-32, 40);
                
                contentScrollView.contentSize = CGSizeMake(_MainScreen_Width, 8+38*6-4+[contentArray count]*60+38+90+38+34+48);
            }else{
                spUserLabel.hidden = YES;
                userLabel.hidden = YES;
                
                submitBtn.frame = CGRectMake(16, 8+38*5-4+[contentArray count]*60+38+90+38+34, _MainScreen_Width-32, 40);
                
                contentScrollView.contentSize = CGSizeMake(_MainScreen_Width, 8+38*5-4+[contentArray count]*60+38+90+38+34+48);
            }
        }
    }
}

@end
