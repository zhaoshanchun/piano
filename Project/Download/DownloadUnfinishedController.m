//
//  DownloadUnfinishedController.m
//  sifakaoshi
//
//  Created by kun on 2017/9/7.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "DownloadUnfinishedController.h"
#import "DownloadTableViewCell.h"
#import "DownloadManage.h"
#import "UIImageView+WebCache.h"

#define UnFinishedCellIdentifier @"DownloadUnfinishedController"

@interface DownloadUnfinishedController ()<UITableViewDataSource, UITableViewDelegate, ProgramDownloadDelegate>

@property (nonatomic , strong) UITableView *tableView;
@property DownloadManage *dlManage;
@property NSMutableArray *array;

@end

@implementation DownloadUnfinishedController

- (id)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.hideNavigationBar = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%s", __func__);

    self.dlManage = [DownloadManage sharedInstance];
//    [self.dlManage add_download:@"XMTcwMTY0NDI0OA==" url:@"1111" icon:@"https://vthumb.ykimg.com//054104085829AC546A0A4E0454251170" title:@"XMTcwMTY0NDI0OA"];
//    [self.dlManage add_download:@"XMTcwMTYzNDgzMg==" url:@"1111" icon:@"https://vthumb.ykimg.com//054104085829AC546A0A4E0454251170" title:@"XMTcwMTYzNDgzMg"];
//    [self.dlManage add_download:@"XMTcwNDc1NjY2MA==" url:@"1111" icon:@"https://vthumb.ykimg.com//054104085829AC546A0A4E0454251170" title:@"XMTcwNDc1NjY2MA"];

    self.array = [NSMutableArray array];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    // CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    // CGRect rectNav = self.navigationController.navigationBar.frame;
    //float topHight = rectNav.size.height + rectStatus.size.height;
    _tableView = [UITableView new];
    _tableView.rowHeight = 70;
    _tableView.delegate = self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self.tableView registerClass:[DownloadTableViewCell class] forCellReuseIdentifier:UnFinishedCellIdentifier];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:15]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-15]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%s", __func__);
    self.dlManage.delegate = self;
    self.array = [_dlManage select_download_task:NO];
    for(int i = 0; i < self.array.count; i++)
    {
        DLTASK *task = self.array[i];
        if(task.total == 0)
            task.progress = 0;
        else
            task.progress = (float)task.completed/(float)task.total;
    }
    [_tableView reloadData];
    
    if (self.array.count == 0) {
        [self showEmptyTitle:localizeString(@"download_notice_downloading_empty") buttonTitle:nil];
    } else {
        [self hideEmptyView];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.dlManage.delegate = nil;
}

-(void)dlSwitchButtonAciton:(UIButton *)btn
{
    long section = (long)btn.tag;
    DLTASK *task = _array[section];

    NSLog(@"dlSwitchButtonAciton %d", [self.dlManage status:task.uuid]);

   // btn.selected = !btn.selected;
    if([self.dlManage status:task.uuid])
    {
        NSLog(@"pause");
        [self.dlManage pause_download:task.uuid];
    }
    else
    {
        NSLog(@"download");
        [self.dlManage start_download:task.uuid];
    }
    /*
    if(btn.selected == YES)
    {
        [self.dlManage start_download:task.uuid];
    }else
    {
        [self.dlManage pause_download:task.uuid];
    }
    */
}

-(void) rate:(NSString *)uuid rate:(double)rate
{
    //NSLog(@"%@ %f", uuid, rate);
    for(int i = 0; i < _array.count; i++)
    {
        DLTASK *task = _array[i];
        if(task && [task.uuid isEqualToString:uuid])
        {
            task.section = i;
            task.rate = rate;
            [self performSelectorOnMainThread:@selector(updateUI:) withObject:task waitUntilDone:NO];
        }
    }
}

-(void)progress:(NSString *)uuid progress:(float)progress
{
    //NSLog(@"%@ %f", uuid, progress);
    for(int i = 0; i < _array.count; i++)
    {
        DLTASK *task = _array[i];
        if(task && [task.uuid isEqualToString:uuid])
        {
            task.section = i;
            task.progress = progress;
            [self performSelectorOnMainThread:@selector(updateUI:) withObject:task waitUntilDone:NO];
        }
    }
}

-(void)event:(NSString *)uuid event:(int)event error:(int)error;
{
    NSLog(@"%s event %d", __func__, event);
    if(event == 1)
    {
        
    }
    else if(event == 2)
    {
        
    }
}

-(void)updateUI:(DLTASK *)task
{
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:task.section]; //你需要更新的组数
    
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];  //collection 相同
    
    if (self.array.count == 0) {
        [self showEmptyTitle:localizeString(@"download_notice_downloaded_empty") buttonTitle:nil];
    } else {
        [self hideEmptyView];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [downloadArray count];
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    long section = [indexPath section];
    DownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UnFinishedCellIdentifier forIndexPath:indexPath];
    //DownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UnFinishedCellIdentifier];
    DLTASK *task = _array[section];
    
    if([self.dlManage status:task.uuid])
    {
        cell.dlSwitchButton.selected = YES;
       // NSLog(@"dlSwitchButton.selected YES");
    }
    else
    {
        cell.dlSwitchButton.selected = NO;
        //NSLog(@"dlSwitchButton.selected NO");
    }
    cell.title.text = task.title;
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:task.icon]];
    cell.processView.progress = task.progress;
    cell.rateValue.text = [NSString stringWithFormat:@"%0.0fkb/s", task.rate];
    cell.processValue.text = [NSString stringWithFormat:@"%0.0f%%", task.progress*100];
    [cell.dlSwitchButton setTag:section];
    [cell.dlSwitchButton addTarget:self action:@selector(dlSwitchButtonAciton:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //long row = [indexPath row];
    //NSLog(@"row: %ld", row);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
    [headerView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    return headerView;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        UITableView *tableview = (UITableView *)scrollView;
        CGFloat sectionHeaderHeight = 64;
        CGFloat sectionFooterHeight = 120;
        CGFloat offsetY = tableview.contentOffset.y;
        if (offsetY >= 0 && offsetY <= sectionHeaderHeight)
        {
            tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
        }else if (offsetY >= sectionHeaderHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight)
        {
            tableview.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
        }else if (offsetY >= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height)         {
            tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight), 0);
        }
    }
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewCellEditingStyleDelete;
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [UIAlertView showWithTitle:nil message:localizeString(@"download_notice_delete") cancelButtonTitle:localizeString(@"cancel") otherButtonTitles:@[localizeString(@"yes")] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                DLTASK *task = _array[indexPath.section];
                [_dlManage remove_download:task.uuid];
                [self.array removeObjectAtIndex:indexPath.section];
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                if (self.array.count == 0) {
                    [self showEmptyTitle:localizeString(@"download_notice_downloaded_empty") buttonTitle:nil];
                } else {
                    [self hideEmptyView];
                }
            }
        }];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return localizeString(@"delete");
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
