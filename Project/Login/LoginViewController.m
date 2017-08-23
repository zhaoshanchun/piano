//
//  LoginViewController.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/22.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

#import "LoginTableViewCell.h"


@interface LoginViewController () <LoginTableViewCellDelegate>

@property (strong, nonatomic) NSMutableArray *listArray;
@property (strong, nonatomic) UIView *footView;

@end

@implementation LoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarTitle:localizeString(@"login")];

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
    
    LoginTableViewCellModel *userNameCellModel = [[LoginTableViewCellModel alloc] initWithType:LoginTableViewCellUserName];
    userNameCellModel.isFirstCell = YES;
    userNameCellModel.titleAttriute = formatAttributedStringByORFontGuide(@[localizeString(@"profile_title_user_name"), @"BR15N"], nil);
    [userNameCellModel updateFrame];
    [self.listArray addObject:userNameCellModel];
    
    LoginTableViewCellModel *passWordCellModel = [[LoginTableViewCellModel alloc] initWithType:LoginTableViewCellPassWord];
    passWordCellModel.isLastCell = YES;
    passWordCellModel.titleAttriute = formatAttributedStringByORFontGuide(@[localizeString(@"profile_title_password"), @"BR15N"], nil);
    [passWordCellModel updateFrame];
    [self.listArray addObject:passWordCellModel];
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
    cell.delegate = self;
    if (self.listArray.count > indexPath.row) {
        cell.cellModel.indexPath = indexPath;
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
        [self.tableView scrollToRowAtIndexPath:cell.cellModel.indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    } else {
        self.tableView.frame = CGRectMake(CGRectGetMinX(self.tableView.frame), CGRectGetMinY(self.tableView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    }
}


#pragma mark - Action
- (void)loginButtonAction {
    // 登录
    [self.view endEditing:YES];
    
    // TODO... 错误判断
    // user=kens&password=password&alias=alias&phone=123&mail=mail&key=test&code=test
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    for (LoginTableViewCellModel *cellModel in self.listArray) {
        switch (cellModel.loginCellellType) {
            case LoginTableViewCellUserName: {
                [paramDict setObject:cellModel.inputedContent forKey:@"user"];
                break;
            }
            case LoginTableViewCellPassWord:
            case LoginTableViewCellConfirmPassWord: {
                if ([paramDict objectForKey:kPassword]) {
                    NSString *passWord = [paramDict objectForKey:kPassword];
                    if (![passWord isEqualToString:cellModel.inputedContent]) {
                        // TODO... 密码不匹配
                    }
                } else {
                    [paramDict setObject:cellModel.inputedContent forKey:kPassword];
                }
                break;
            }
            case LoginTableViewCellPhone: {
                [paramDict setObject:cellModel.inputedContent forKey:@""];
                break;
            }
            case LoginTableViewCellMail: {
                [paramDict setObject:cellModel.inputedContent forKey:@""];
                break;
            }
            case LoginTableViewCellVerification: {
                [paramDict setObject:cellModel.inputedContent forKey:@""];
                break;
            }
            default:
                break;
        }
    }
}

- (void)registerButtonAction {
    [self.view endEditing:YES];
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Factory method
- (UIView *)footView {
    if (_footView == nil) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 120)];
        _footView.backgroundColor = [UIColor clearColor];
        
        UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 20, CGRectGetWidth(self.tableView.frame) - 50*2, 40)];
        [loginButton setFontAndTextColorByKey:@"W15B" forState:UIControlStateNormal];
        [loginButton setTitle:localizeString(@"login") forState:UIControlStateNormal];
        loginButton.backgroundColor = [UIColor orThemeColor];
        loginButton.layer.cornerRadius = 5.f;
        loginButton.layer.masksToBounds = YES;
        [loginButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:loginButton];
        
        UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(loginButton.frame), CGRectGetMaxY(loginButton.frame) + 10, CGRectGetWidth(loginButton.frame), 30)];
        NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
        style.alignment = NSTextAlignmentCenter;
        NSAttributedString *attribute = formatAttributedStringByORFontGuide(@[localizeString(@"profile_title_register"), @"O14N"], @[style]);
        [registerButton setAttributedTitle:attribute forState:UIControlStateNormal];
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




