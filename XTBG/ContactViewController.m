//
//  ContactViewController.m
//  XTBG
//
//  Created by vchao on 14/11/17.
//  Copyright (c) 2014年 rzzx. All rights reserved.
//

#import "ContactViewController.h"
#import "NSObject+SBJson.h"
#import "SVProgressHUD.h"

@interface ContactViewController ()

@end

@implementation ContactViewController

@synthesize isOpen,selectIndex;

- (void)dealloc
{
    _dataList = nil;
    self.contactsTableView = nil;
    self.isOpen = NO;
    self.selectIndex = nil;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataList = [[NSMutableArray alloc] init];
    
    self.contactsTableView.sectionFooterHeight = 0;
    self.contactsTableView.sectionHeaderHeight = 0;
    self.contactsTableView.dataSource = self;
    self.contactsTableView.delegate = self;
    self.isOpen = NO;
    
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
        NSMutableArray *userArray = [userDict objectForKey:@"user"];
        _dataList = [[NSMutableArray alloc] init];
        for (int i=0; i<[departArray count]; i++) {
            NSDictionary *depart = [departArray objectAtIndex:i];
            NSInteger departID = [[depart objectForKey:@"id"] integerValue];
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:depart];
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int j=0; j<[userArray count]; j++) {
                NSDictionary *user = [userArray objectAtIndex:j];
                NSInteger type = [[user objectForKey:@"type"] integerValue];
                if (departID == type) {
                    [array addObject:user];
                }
            }
            [dict setObject:array forKey:@"user"];
            [_dataList addObject:dict];
        }
        [self.contactsTableView reloadData];
    }
    [self getContactsList];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSInteger uid = [userDefaults integerForKey:USER_ID];
}

- (void)getContactsList{
    if ([_dataList count] == 0) {
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
        if ([_dataList count] == 0) {
            [SVProgressHUD dismiss];
        }
        NSLog(@"%@",[responseObject JSONValue]);
        NSMutableArray *resultArray = [responseObject JSONValue];
        if ([resultArray count] > 1) {
            NSDictionary *departDict = [resultArray objectAtIndex:0];
            NSDictionary *userDict = [resultArray objectAtIndex:1];
            
            NSMutableArray *departArray = [departDict objectForKey:@"depart"];
            NSMutableArray *userArray = [userDict objectForKey:@"user"];
            _dataList = [[NSMutableArray alloc] init];
            for (int i=0; i<[departArray count]; i++) {
                NSDictionary *depart = [departArray objectAtIndex:i];
                NSInteger departID = [[depart objectForKey:@"id"] integerValue];
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:depart];
                
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (int j=0; j<[userArray count]; j++) {
                    NSDictionary *user = [userArray objectAtIndex:j];
                    NSInteger type = [[user objectForKey:@"depart"] integerValue];
                    if (departID == type) {
                        [array addObject:user];
                    }
                }
                [dict setObject:array forKey:@"user"];
                [_dataList addObject:dict];
            }
            [self.contactsTableView reloadData];
            
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isOpen) {
        if (self.selectIndex.section == section) {
            return [[[_dataList objectAtIndex:section] objectForKey:@"user"] count]+1;
        }
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0) {
        return 72;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0) {
        static NSString *CellIdentifier = @"ContactsTableViewCell";
        ContactsTableViewCell *cell = (ContactsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        NSArray *list = [[_dataList objectAtIndex:self.selectIndex.section] objectForKey:@"user"];
        NSDictionary *dict = [list objectAtIndex:indexPath.row-1];
        cell.titleLabel.text = [NSString stringWithFormat:@"[%@]",[dict objectForKey:@"realname"]];
        cell.mobileLabel.text = [NSString stringWithFormat:@"个人电话:%@",[dict objectForKey:@"mobile"]];
        cell.officeTelLabel.text = [NSString stringWithFormat:@"办公电话:%@",[dict objectForKey:@"tel"]];
        cell.msgBtn.tag = self.selectIndex.section*10000+(indexPath.row-1);
        cell.callBtn.tag = self.selectIndex.section*10000+(indexPath.row-1);
        [cell.msgBtn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [cell.callBtn addTarget:self action:@selector(callMobile:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else
    {
        static NSString *CellIdentifier = @"ContactsGroupCell";
        ContactsGroupCell *cell = (ContactsGroupCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        NSString *name = [[_dataList objectAtIndex:indexPath.section] objectForKey:@"name"];
        NSArray *list = [[_dataList objectAtIndex:indexPath.section] objectForKey:@"user"];
        cell.titleLabel.text = name;
        cell.countLabel.text = [NSString stringWithFormat:@"[%lu]",[list count]];
        [cell changeLayout];
        [cell changeArrowWithUp:([self.selectIndex isEqual:indexPath]?YES:NO)];
        return cell;
    }
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([indexPath isEqual:self.selectIndex]) {
            self.isOpen = NO;
            [self didSelectCellRowFirstDo:NO nextDo:NO];
            self.selectIndex = nil;
            
        }else
        {
            if (!self.selectIndex) {
                self.selectIndex = indexPath;
                [self didSelectCellRowFirstDo:YES nextDo:NO];
                
            }else
            {
                
                [self didSelectCellRowFirstDo:NO nextDo:YES];
            }
        }
        
    }else
    {
//        NSDictionary *dic = [_dataList objectAtIndex:indexPath.section];
//        NSArray *list = [dic objectForKey:@"user"];
//        NSDictionary *dict = [list objectAtIndex:indexPath.row-1];
//        NSString *itemName = [dict objectForKey:@"name"];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:itemName message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
//        [alert show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    
    ContactsGroupCell *cell = (ContactsGroupCell *)[self.contactsTableView cellForRowAtIndexPath:self.selectIndex];
    [cell changeArrowWithUp:firstDoInsert];
    
    [self.contactsTableView beginUpdates];
    
    NSInteger section = self.selectIndex.section;
    NSInteger contentCount = [[[_dataList objectAtIndex:section] objectForKey:@"user"] count];
    NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
    for (NSUInteger i = 1; i < contentCount + 1; i++) {
        NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
        [rowToInsert addObject:indexPathToInsert];
    }
    
    if (firstDoInsert)
    {   [self.contactsTableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    else
    {
        [self.contactsTableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    
    [self.contactsTableView endUpdates];
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [self.contactsTableView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    if (self.isOpen) [self.contactsTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)sendMessage:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    NSInteger section = tag/10000;
    NSInteger row = tag%10000;
    NSArray *list = [[_dataList objectAtIndex:section] objectForKey:@"user"];
    NSDictionary *dict = [list objectAtIndex:row];
    NSString *mobile = [dict objectForKey:@"mobile"];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",mobile]]];
}

- (void)callMobile:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    NSInteger section = tag/10000;
    NSInteger row = tag%10000;
    NSArray *list = [[_dataList objectAtIndex:section] objectForKey:@"user"];
    NSDictionary *dict = [list objectAtIndex:row];
    NSString *mobile = [dict objectForKey:@"mobile"];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",mobile]]];
}

@end
