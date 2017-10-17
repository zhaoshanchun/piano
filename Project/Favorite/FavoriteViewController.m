//
//  FavoriteViewController.m
//  gangqinjiaocheng
//
//  Created by kun on 2017/9/26.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "FavoriteViewController.h"
#import "FavoriteTableViewCell.h"
#import "FavoritesManager.h"
#import "UIImageView+WebCache.h"
#import "VideoDetailViewController.h"
#import "BaseNavigationController.h"
#import "UIAlertView+Blocks.h"

#define FavoriteCellIdentifier @"FavoriteCellIdentifier"


@interface FavoriteViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic , strong) NSMutableArray *array;
@property (nonatomic , strong) FavoritesManager *favoritesManager;

@end

@implementation FavoriteViewController

- (void)initData{
    self.favoritesManager = [FavoritesManager sharedManager];
    self.array = [self.favoritesManager getFavoriteArray];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBackButtonWithImageKey:@"common_back"];
    [self setNavigationBarTitle:localizeString(@"profile_history")];
    [self initData];
}

- (void)setTableView {
    [self.tableView registerClass:[FavoriteTableViewCell class] forCellReuseIdentifier:FavoriteCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.array.count;
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
    FavoriteObject *obj = [self.array objectAtIndex:section];
    FavoriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FavoriteCellIdentifier forIndexPath:indexPath];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:obj.preview]];
    cell.title.text = obj.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    long section = [indexPath section];
    FavoriteObject *obj = [self.array objectAtIndex:section];
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
        [UIAlertView showWithTitle:nil message:localizeString(@"favority_notice_delete") cancelButtonTitle:@"cancel" otherButtonTitles:@[localizeString(@"yes")] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                FavoriteObject *obj = [self.array objectAtIndex:indexPath.section];
                [self.favoritesManager remove:obj.uuid];
                [self.array removeObjectAtIndex:indexPath.section];
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

@end




