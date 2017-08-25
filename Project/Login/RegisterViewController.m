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
@property (strong, nonatomic) NSIndexPath *edittingIndexPath;

@property (strong, nonatomic) NSString *verificationImageFilePath;
@property (strong, nonatomic) NSString *verificationKey;

@end

@implementation RegisterViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarTitle:localizeString(@"register")];
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getVerification];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)setTableView {
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeNone;
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
    
    // Full name
    LoginTableViewCellModel *fullNameCellModel = [[LoginTableViewCellModel alloc] initWithType:LoginTableViewCellFullName];
    fullNameCellModel.titleAttriute = formatAttributedStringByORFontGuide(@[localizeString(@"profile_title_full_name"), @"BR15N"], nil);
    [fullNameCellModel updateFrame];
    [self.listArray addObject:fullNameCellModel];
    
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
    verificationCellModel.verificationFilePath = self.verificationImageFilePath;
    [verificationCellModel updateFrame];
    [self.listArray addObject:verificationCellModel];
}

- (void)getVerification {
    [APIManager downloadWithUrl:@"http://www.appshopping.store/app/get_verify_code" completedHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSDictionary* headers = [(NSHTTPURLResponse *)response allHeaderFields];
        if (headers[@"key"]) {
            self.verificationKey = headers[@"key"];
            NSLog(@"verificationKey = %@", self.verificationKey);
        }
        
        NSLog(@"File downloaded to: %@", filePath);
        self.verificationImageFilePath = [[filePath absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        // file:///Users/zhaosc/Library/Developer/CoreSimulator/Devices/4BFA1AB3-C11D-4FFE-9C35-D9E46A8C5E63/data/Containers/Data/Application/719C3E7A-8EC9-495D-93F5-EA53D6DB86D2/Documents/get_verify_code.png
        if (self.verificationImageFilePath.length > 0 && self.listArray.count > 0) {
            for (LoginTableViewCellModel *cellModel in self.listArray) {
                if (LoginTableViewCellVerification == cellModel.loginCellellType) {
                    cellModel.verificationFilePath = self.verificationImageFilePath;
                    [cellModel updateFrame];
                    if (cellModel.indexPath) {
                        [self.tableView beginUpdates];
                        [self.tableView reloadRowsAtIndexPaths:@[cellModel.indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        [self.tableView endUpdates];
                    }
                    break;
                }
            }
        }
    }];
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
        LoginTableViewCellModel *cellModel = [self.listArray objectAtIndex:indexPath.row];
        cellModel.indexPath = indexPath;
        cell.cellModel = cellModel;
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
- (void)registerButtonAction {
    // 注册
    [self.view endEditing:YES];
    
    // user=kens&password=password&alias=alias&phone=123&mail=mail&key=test&code=test
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    for (LoginTableViewCellModel *cellModel in self.listArray) {
        switch (cellModel.loginCellellType) {
            case LoginTableViewCellUserName: {
                [paramDict setObject:(cellModel.inputedContent.length > 0) ? cellModel.inputedContent : @"" forKey:kUser];
                break;
            }
            case LoginTableViewCellFullName: {
                [paramDict setObject:(cellModel.inputedContent.length > 0) ? cellModel.inputedContent : @"" forKey:kFullName];
                break;
            }
            case LoginTableViewCellPassWord:
            case LoginTableViewCellConfirmPassWord: {
                if ([paramDict objectForKey:kPassword]) {
                    NSString *passWord = [paramDict objectForKey:kPassword];
                    if (![passWord isEqualToString:cellModel.inputedContent]) {
                        // TODO... 密码不匹配
                        break;
                        return;
                    }
                } else {
                    [paramDict setObject:(cellModel.inputedContent.length > 0) ? cellModel.inputedContent : @"" forKey:kPassword];
                }
                break;
            }
            case LoginTableViewCellPhone: {
                [paramDict setObject:(cellModel.inputedContent.length > 0) ? cellModel.inputedContent : @"" forKey:kPhone];
                break;
            }
            case LoginTableViewCellMail: {
                [paramDict setObject:(cellModel.inputedContent.length > 0) ? cellModel.inputedContent : @"" forKey:kMail];
                break;
            }
            case LoginTableViewCellVerification: {
                [paramDict setObject:(cellModel.inputedContent.length > 0) ? cellModel.inputedContent : @"" forKey:kCode];
                break;
            }
            default:
                break;
        }
    }
    
    // Check
    if (![paramDict objectForKey:kUser] || [[paramDict objectForKey:kUser] length] == 0) {
        // [self.view makeToast:@"请填写用户名"];
        return;
    }
    if (![paramDict objectForKey:kPassword] || [[paramDict objectForKey:kPassword] length] == 0) {
        // 密码长度
        return;
    }
    if (![paramDict objectForKey:kMail] || [[paramDict objectForKey:kMail] length] == 0) {
        // 邮件格式
        return;
    }
    if (![paramDict objectForKey:kCode] || [[paramDict objectForKey:kCode] length] == 0) {
        // 数字位数
        return;
    }
    
    // API request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.appshopping.store/app/register"]];
    request.timeoutInterval = 10.0;
    request.HTTPMethod = @"POST";
    
    // user=kens&password=password&alias=alias&phone=123&mail=mail&key=test&code=test
    NSString *param=[NSString stringWithFormat:@"user=%@&password=%@&alias=%@&phone=%@&mail=%@&key=%@&code=%@", [paramDict objectForKey:kUser], [paramDict objectForKey:kFullName], [paramDict objectForKey:kPassword], [paramDict objectForKey:kPhone], [paramDict objectForKey:kMail], self.verificationKey, [paramDict objectForKey:kCode]];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    
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


#pragma mark - Factory method
- (UIView *)footView {
    if (_footView == nil) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 80)];
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




