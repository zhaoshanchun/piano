//
//  RegisterViewController.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/22.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginTableViewCell.h"


@interface RegisterViewController () <LoginTableViewCellDelegate>

@property (strong, nonatomic) NSMutableArray *listArray;
@property (strong, nonatomic) UIView *footView;

@end

@implementation RegisterViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarTitle:localizeString(@"register")];

    [self presetData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.view endEditing:YES];
}

- (void)setTableView {
    [self.tableView registerClass:[LoginTableViewCell class] forCellReuseIdentifier:kLoginTableViewCellIdentifier];
    self.tableView.tableFooterView = self.footView;
}

- (void)presetData {
    self.listArray = [NSMutableArray new];
    
    // 用户名
    LoginTableViewCellModel *userNameCellModel = [[LoginTableViewCellModel alloc] initWithType:LoginTableViewCellUserName];
    userNameCellModel.isFirstCell = YES;
    userNameCellModel.titleAttriute = formatAttributedStringByORFontGuide(@[localizeString(@"profile_title_user_name"), @"BR15N"], nil);
    [userNameCellModel updateFrame];
    [self.listArray addObject:userNameCellModel];
    
    // 密码
    LoginTableViewCellModel *passWordCellModel = [[LoginTableViewCellModel alloc] initWithType:LoginTableViewCellPassWord];
    passWordCellModel.titleAttriute = formatAttributedStringByORFontGuide(@[localizeString(@"profile_title_password"), @"BR15N"], nil);
    [passWordCellModel updateFrame];
    [self.listArray addObject:passWordCellModel];
    
    // 确认密码
    LoginTableViewCellModel *confirmCellModel = [[LoginTableViewCellModel alloc] initWithType:LoginTableViewCellConfirmPassWord];
    confirmCellModel.titleAttriute = formatAttributedStringByORFontGuide(@[localizeString(@"profile_title_confirme_password"), @"BR15N"], nil);
    [confirmCellModel updateFrame];
    [self.listArray addObject:confirmCellModel];
    
    // 电话
    LoginTableViewCellModel *phoneCellModel = [[LoginTableViewCellModel alloc] initWithType:LoginTableViewCellPhone];
    phoneCellModel.titleAttriute = formatAttributedStringByORFontGuide(@[localizeString(@"profile_title_phone"), @"BR15N"], nil);
    [phoneCellModel updateFrame];
    [self.listArray addObject:phoneCellModel];
    
    // 邮箱
    LoginTableViewCellModel *emailCellModel = [[LoginTableViewCellModel alloc] initWithType:LoginTableViewCellMail];
    emailCellModel.titleAttriute = formatAttributedStringByORFontGuide(@[localizeString(@"profile_title_email"), @"BR15N"], nil);
    [emailCellModel updateFrame];
    [self.listArray addObject:emailCellModel];
    
    // 验证码
    LoginTableViewCellModel *verificationCellModel = [[LoginTableViewCellModel alloc] initWithType:LoginTableViewCellVerification];
    verificationCellModel.isLastCell = YES;
    verificationCellModel.titleAttriute = formatAttributedStringByORFontGuide(@[localizeString(@"profile_title_verification"), @"BR15N"], nil);
    [verificationCellModel updateFrame];
    [self.listArray addObject:verificationCellModel];
}



#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listArray.count > indexPath.row) {
        LoginTableViewCellModel *cellModel = [self.listArray objectAtIndex:indexPath.row];
        return cellModel.cellHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLoginTableViewCellIdentifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.delegate = self;
    if (self.listArray.count > indexPath.row) {
        cell.cellModel = [self.listArray objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - LoginTableViewCellDelegate
- (void)updateFrameForEdittingCell:(LoginTableViewCell *)cell isEditting:(BOOL)isEditting {
    if (isEditting) {
        self.tableView.frame = CGRectMake(CGRectGetMinX(self.tableView.frame), CGRectGetMinY(self.tableView.frame), CGRectGetWidth(self.tableView.frame), CGRectGetHeight(self.view.frame) - 216);
        [self.tableView scrollToRowAtIndexPath:cell.indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    } else {
        self.tableView.frame = CGRectMake(CGRectGetMinX(self.tableView.frame), CGRectGetMinY(self.tableView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    }
}


#pragma mark - Action
- (void)registerButtonAction {
    // TODO... 注册
    [self.view endEditing:YES];
}


#pragma mark - Factory method
- (UIView *)footView {
    if (_footView == nil) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 120)];
        _footView.backgroundColor = [UIColor clearColor];
        
        UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 20, CGRectGetWidth(self.tableView.frame) - 50*2, 40)];
        [registerButton setFontAndTextColorByKey:@"W15B" forState:UIControlStateNormal];
        [registerButton setTitle:localizeString(@"register") forState:UIControlStateNormal];
        registerButton.backgroundColor = [UIColor orThemeColor];
        registerButton.layer.cornerRadius = 5.f;
        registerButton.layer.masksToBounds = YES;
        [registerButton addTarget:self action:@selector(registerButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:registerButton];
    }
    return _footView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end




