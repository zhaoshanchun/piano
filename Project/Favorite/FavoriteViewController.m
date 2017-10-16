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

// @property (nonatomic , strong) UITableView *tableView;
// TODO...
@property NSMutableArray *array;
@property FavoritesManager *favoritesManager;

@end

@implementation FavoriteViewController

- (void)initData{
    self.favoritesManager = [FavoritesManager sharedManager];
    
    // TODO...

    self.array = [self.favoritesManager getFavoriteArray];
}

- (void)initView{
    
    /*
    UIView *head = [UIView new];
    head.backgroundColor = [UIColor orThemeColor];
    head.frame = CGRectMake(0, 0, self.view.bounds.size.width, 60);
    [self.view addSubview:head];
    
    UIButton *back = [UIButton new];
    back.frame = CGRectMake(10, 26, 20, 22);
    back.contentMode = UIViewContentModeScaleAspectFit;
    [back setImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(OnBack:) forControlEvents:UIControlEventTouchUpInside];    //back.image = [UIImage imageNamed:@"Back"];
    [head addSubview:back];
     */
    
    // TODO...
    /*
    _tableView = [UITableView new];
    _tableView.rowHeight = 70;
    _tableView.delegate = self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self.tableView registerClass:[FavoriteTableViewCell class] forCellReuseIdentifier:FavoriteCellIdentifier];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:head attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:15]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-15]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
     */
}

/*
- (void)OnBack:(id)bt
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];
    //self = nav;
    // Do any additional setup after loading the view.
    // self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    [self initData];
    
    // [self initView];
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
    //cell.title.text = @"标题标题标题标题标题标题标题标题标题标";   // TODO...
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

    // BaseNavigationController *navigationController = [[BaseNavigationController alloc] initWithRootViewController:vc];
    // [self presentViewController:navigationController animated:NO completion:nil];
}

/*
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
*/

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
        
        // TODO... local string
        
        /*
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定删除该消息？" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //
            //            [_classArray removeObjectAtIndex:indexPath.row];
            ///[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            //NSLog(@"delete section: %ld", [indexPath section]);
            //[self.array removeObjectAtIndex:indexPath.section];
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        */
        
        [UIAlertView showWithTitle:nil message:localizeString(@"你确定删除该收藏？") cancelButtonTitle:@"cancel" otherButtonTitles:@[localizeString(@"yes")] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                // TODO...  删除 源数据
                
                // TODO...  删除 tableView cell
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
    // TODO... local string
    return @"删除";
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
