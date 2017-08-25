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
#import "UIView+Toast.h"


@interface LoginViewController () <LoginTableViewCellDelegate>

@property (strong, nonatomic) NSMutableArray *listArray;
@property (strong, nonatomic) NSIndexPath *edittingIndexPath;
@property (strong, nonatomic) UIView *footView;

@end

@implementation LoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarTitle:localizeString(@"login")];
    [self presetData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.view endEditing:YES];
    
    if (self.apiTask) {
        [self.apiTask cancel];
        self.apiTask = nil;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
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
    self.edittingIndexPath = cell.cellModel.indexPath;
}

- (void)keyboardDidShow:(NSNotification *)aNotification {
    // 获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    self.tableView.frame = CGRectMake(CGRectGetMinX(self.tableView.frame), CGRectGetMinY(self.tableView.frame), CGRectGetWidth(self.tableView.frame), CGRectGetHeight(self.view.frame) - keyboardRect.size.height);
    if (self.edittingIndexPath) {
        [self.tableView scrollToRowAtIndexPath:self.edittingIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

- (void)keyboardDidHide:(NSNotification *)aNotification {
    self.tableView.frame = CGRectMake(CGRectGetMinX(self.tableView.frame), CGRectGetMinY(self.tableView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
}


#pragma mark - Action
- (void)loginButtonAction {
    // 登录
    [self.view endEditing:YES];
    
    /*
     http://www.appshopping.store/app/login?user=kunhuang&password=8888889
     response: (post)
     user
     password
     */
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    for (LoginTableViewCellModel *cellModel in self.listArray) {
        switch (cellModel.loginCellellType) {
            case LoginTableViewCellUserName: {
                [paramDict setObject:(cellModel.inputedContent.length > 0) ? cellModel.inputedContent : @"" forKey:kUser];
                break;
            }
            case LoginTableViewCellPassWord: {
                [paramDict setObject:(cellModel.inputedContent.length > 0) ? cellModel.inputedContent : @"" forKey:kPassword];
                break;
            }
            default:
                break;
        }
    }
    if (![paramDict objectForKey:kUser] || [[paramDict objectForKey:kUser] length] == 0) {
//        [self.view makeToast:@"请填写用户名"];
        return;
    }
    if (![paramDict objectForKey:kPassword] || [[paramDict objectForKey:kPassword] length] == 0) {
//        [self.view makeToast:@"请填写密码"];
        return;
    }
 
 
    /*
    self.apiTask = [APIManager requestWithApi:@"http://www.appshopping.store/app/login"
                                    apiMethod:APIMethodPost
                                    andParams:nil // @{kUser:@"kunhuang",kPassword:@"888888898"}
                                progressBlock:nil
                            completionHandler:^(id model, NSInteger statusCode, NSError *err) {
        if (err) {
            
        } else {
            
        }
    }];
    */
    
   
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.appshopping.store/app/login"]]; // 默认为get请求
    request.timeoutInterval = 10.0; // 设置请求超时为5秒
    request.HTTPMethod = @"POST"; // 设置请求方法
    // 设置请求体
    // NSString *param=[NSString stringWithFormat:@"user=%@&password=%@", @"kunhuang", @"888888898"];
    NSString *param = [NSString stringWithFormat:@"user=%@&password=%@", [paramDict objectForKey:kUser], [paramDict objectForKey:kPassword]];
    // 把拼接后的字符串转换为data，设置请求体
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLResponse *response;
    NSError *error;
    NSData *backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        NSLog(@"error : %@",[error localizedDescription]);
    } else {
        NSLog(@"response : %@",response);
        NSLog(@"backData : %@",[[NSString alloc]initWithData:backData encoding:NSUTF8StringEncoding]);
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
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 100)];
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




