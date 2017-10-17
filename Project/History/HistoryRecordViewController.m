//
//  HistoryRecord.m
//  apps
//
//  Created by kun on 2017/10/16.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "HistoryRecordViewController.h"
#import "HistoryRecordTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "VideoDetailViewController.h"
#import "BaseNavigationController.h"
#import "UIAlertView+Blocks.h"
#import "HistoryManager.h"

#define HistoryRecordTableViewCellIdentifier @"HistoryRecordTableViewCellIdentifier"


@interface HistoryRecordViewController ()<UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray *historyArray;

@end

@implementation HistoryRecordViewController

- (void)initData{
    self.historyArray = [[HistoryManager sharedManager] getAllHistoryList];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBackButtonWithImageKey:@"common_back"];
    [self setNavigationBarTitle:localizeString(@"profile_history")];
    [self initData];
}

- (void)setTableView {
    [self.tableView registerClass:[HistoryRecordTableViewCell class] forCellReuseIdentifier:HistoryRecordTableViewCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.historyArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
    [headerView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kFavoriteTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    long section = [indexPath section];
    ContentModel *obj = [self.historyArray objectAtIndex:section];

    HistoryRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HistoryRecordTableViewCellIdentifier forIndexPath:indexPath];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:obj.preview]];
    cell.title.text = obj.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    long section = [indexPath section];
    ContentModel *obj = [self.historyArray objectAtIndex:section];
    ContentModel *model = [ContentModel new];
    model.uuid = obj.uuid;
    model.title = obj.title;
    model.preview = obj.preview;
    VideoDetailViewController *vc = [[VideoDetailViewController alloc] initWithContentModel:model];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [UIAlertView showWithTitle:nil message:localizeString(@"history_notice_delete") cancelButtonTitle:@"cancel" otherButtonTitles:@[localizeString(@"yes")] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                ContentModel *obj = [self.historyArray objectAtIndex:indexPath.section];
                [[HistoryManager sharedManager] DeleteHistory:obj.uuid];
                [self.historyArray removeObjectAtIndex:indexPath.section];
                [tableView beginUpdates];
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView endUpdates];
                
            }
        }];
        
    }
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return localizeString(@"delete");
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
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
