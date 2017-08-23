//
//  SearchViewController.m
//  kuaijiazhicheng
//
//  Created by kun on 2017/6/16.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "SearchViewController.h"
#import "BaseTableViewCell.h"
#import "AsyncImage.h"
#import "AppDelegate.h"
#import "GlobalValue.h"
#import "LBToAppStore.h"
#import "PlayerViewController.h"

#define SearchViewControllerCell  @"SearchViewControllerCell"

@interface SearchViewController ()<SearchDetailViewDelegate,UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *videoArray;
    BOOL ifDismss;
    float keybHight;
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ifDismss = NO;
    keybHight = 0;
    
    [self registerForKeyboardNotifications];
    [self setupSearchView];
    [self setupLoadView];
    [self initData:@""];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(ifDismss == YES) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)initData:(NSString *)key {
    videoArray = [NSMutableArray array];
    if([key isEqualToString:@""]) {
        return;
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    GlobalValue *globalValue = appDelegate.globalValue;    
    videoArray = [globalValue keySearchForObjects:key];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTableView {
    _tableView = [UITableView new];
    _tableView.rowHeight = 60;
    _tableView.delegate = self;
    _tableView.dataSource=self;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_tableView];
    [self.tableView registerClass:[BaseTableViewCell class] forCellReuseIdentifier:SearchViewControllerCell];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:rectNav.size.height+rectStatus.size.height]];
    self.tableBottomConstraint = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.view addConstraint:self.tableBottomConstraint];
}

- (void)setupLoadView {
    self.searchLoadView = [UIActivityIndicatorView new];
    self.searchLoadView.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchLoadView.color = [UIColor blackColor];
    CGAffineTransform transform = CGAffineTransformMakeScale(2.0f, 2.0f);
    self.searchLoadView.transform = transform;
    [self.view addSubview:self.searchLoadView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchLoadView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchLoadView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:-self.view.bounds.size.height/4]];
    //[self.searchLoadView startAnimating];
}

- (void)setupSearchView {
    NSLog(@"----->%s", __func__);
    //self.navigationController.navigationBar.translucent = NO;
    self.searchDetailView = [SearchDetailView new];
    self.searchDetailView.frame = CGRectMake(0, 3, self.view.frame.size.width, 30);
    //self.searchDetailView.textField.placeholder = self.placeHolderText;
    //self.searchDetailView.textField.text = @"搜索";
    self.searchDetailView.delegate = self;
    [self.searchDetailView.textField becomeFirstResponder];
    [self.navigationController.navigationBar addSubview:self.searchDetailView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [videoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    long row = [indexPath row];
    VideoObject *object = [videoArray objectAtIndex:row];
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchViewControllerCell];
    cell.uid = object.uid;
    cell.iconImageView.image = [UIImage imageNamed:object.icon];
    cell.nameLabel.text = object.title;
    cell.timeLabel.text = object.time;
    if(![object.time isEqualToString:@""]) {
        NSString *t = @"时长:";
        t = [t stringByAppendingString:object.time];
        cell.playTime.text = t;
    } else {
        cell.playTime.text = @"";
    }
    cell.playImageView.hidden = YES;
    cell.timeLabel.hidden = YES;
    cell.nextImageView.hidden = YES;
    
    AsyncImage *asyncImage = [AsyncImage new];
    [asyncImage LoadImage:cell Object:object];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    long row = [indexPath row];
    VideoObject *object = [videoArray objectAtIndex:row];
    ifDismss = YES;
    if(self.searchDetailView)
        self.searchDetailView.hidden = YES;
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil]; ///:隐藏键盘
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    [self.navigationController pushViewController:[PlayerViewController playerViewControllerWithVideoPath:object.videoPath Title:object.title Index:object.uid Ccode:object.code] animated:YES];
}


#pragma mark - SearchDetailViewDelegate
- (void)dismissButtonWasPressedForSearchDetailView:(SearchDetailView *)searchView {
    [self dismissViewControllerAnimated:NO
                             completion:nil];
}

- (void)searchButtonWasPressedForSearchDetailView:(SearchDetailView *)searchView {
    NSLog(@"搜索内容:::::::::%@",searchView.textField.text);
    [UIView animateWithDuration:0.3 animations:^{
        self.tableBottomConstraint.constant = 0;
        [self.view setNeedsLayout]; //更新视图
        [self.view layoutIfNeeded];
    }];
}

- (void)textFieldEditingChangedForSearchDetailView:(SearchDetailView *)searchView {
    NSLog(@"搜索内容：：：：：：：%@",searchView.textField.text);
    /*
    [self.view bringSubviewToFront:self.searchLoadView];
    [self.searchLoadView startAnimating];
    [self initData:searchView.textField.text];
    [self.searchLoadView stopAnimating];
     */
    [self initData:searchView.textField.text];
    [self.tableView reloadData];
}

- (void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    //kbSize键盘尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//键盘高度
    NSLog(@"hight_hitht:%f",kbSize.height);
    keybHight = kbSize.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.tableBottomConstraint.constant = -kbSize.height;
        [self.view setNeedsLayout]; //更新视图
        [self.view layoutIfNeeded];
    }];
}

// 视图将要消失时,移除通知中心
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
