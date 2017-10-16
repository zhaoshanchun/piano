//
//  ProfileViewController.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/16.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserFeedbackViewController.h"
#import "LoginViewController.h"
#import "ProfileUserTableViewCell.h"
#import "UIActionSheet+Blocks.h"
#import "FavoriteViewController.h"
#import "ELCImagePickerController.h"
#import "HistoryRecordViewController.h"

#define kSectionNumber 3

#define kDictPhotoName @"kDictPhotoName" 
#define kDictPhotoType @"kDictPhotoType"

@interface ProfileViewController () <LoginViewControllerDelegate, RegisterViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, ProfileUserTableViewCellDelegate, ELCImagePickerControllerDelegate>

@property (strong, nonatomic) ProfileUserTableViewCellModel *userCellModel;

@end

@implementation ProfileViewController

- (id)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = NO; // 当前页面需要 Bottom Bar
        self.hideNavigationBar = NO;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarTitle:localizeString(@"page_title_profile")];
    [self presetData];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRegisterSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kRegisterSuccessNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRegisterSuccessNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTableView {
    [self.tableView registerClass:[ProfileUserTableViewCell class] forCellReuseIdentifier:kProfileUserTableViewCellIdentifier];
    [self.tableView registerClass:[UIBaseTableViewCell class] forCellReuseIdentifier:kUIBaseTableViewCellIndentifier];
}

- (void)presetData {
    if (self.userModel) {
        ProfileUserTableViewCellModel *cellModel = [ProfileUserTableViewCellModel new];
        cellModel.userModel = self.userModel;
        self.userCellModel = cellModel;
    } else {
        self.userCellModel = [ProfileUserTableViewCellModel new];
    }
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kSectionNumber;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 20.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        // User cell
        return 1;
    } else if (section == 1) {
        // 评价+反馈
        return 2;
    } else {
        // 历史记录+收藏
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return self.userCellModel.cellHeight;
    }
    return kCellDefaultHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ProfileUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfileUserTableViewCellIdentifier forIndexPath:indexPath];
            cell.delegate = self;
            cell.cellModel = self.userCellModel;
            return cell;
        }
    } else if (indexPath.section == 1) {
        UIBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUIBaseTableViewCellIndentifier forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.textLabel.attributedText = formatAttributedStringByORFontGuide(@[localizeString(@"profile_evaluate"), @"BR15N"], nil);
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_right_arrow"]];
        } else {
            cell.textLabel.attributedText = formatAttributedStringByORFontGuide(@[localizeString(@"profile_feedBack"), @"BR15N"], nil);
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_right_arrow"]];
        }
        return cell;
    } else {
        UIBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUIBaseTableViewCellIndentifier forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.textLabel.attributedText = formatAttributedStringByORFontGuide(@[localizeString(@"profile_history"), @"BR15N"], nil);
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_right_arrow"]];
        } else {
            cell.textLabel.attributedText = formatAttributedStringByORFontGuide(@[localizeString(@"profile_bookmark"), @"BR15N"], nil);
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_right_arrow"]];
        }
        return cell;
    }
    UIBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUIBaseTableViewCellIndentifier forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (self.userCellModel.userModel) {
                // Logined, go to logout!
                [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:localizeString(@"cancel") destructiveButtonTitle:nil otherButtonTitles:@[@"profile_logout"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                    if (buttonIndex == 0) {
                        // Logout
                        saveObjectToUserDefaults(kLoginedUser, nil);
                        self.userCellModel.userModel = nil;
                        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                    }
                }];
            } else {
                // Unlogin, go to login page
                LoginViewController *vc = [LoginViewController new];
                vc.delegate = self;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NSString *str = [NSString stringWithFormat:
                             @"https://itunes.apple.com/cn/app/id%@?mt=8", AppID];  // TODO...
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        } else {
            [self.navigationController pushViewController:[UserFeedbackViewController new] animated:YES];
        }
    } else {
        if (indexPath.row == 0) {
            
            HistoryRecordViewController *vc = [HistoryRecordViewController new];
            [self.navigationController pushViewController:vc animated:YES];

            
        } else {
            FavoriteViewController *vc = [FavoriteViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
}

// hello
#pragma mark - LoginViewControllerDelegate
- (void)loginSuccess {
    NSData *userModelData = (NSData *)getObjectFromUserDefaults(kLoginedUser);
    if (userModelData) {
        UserModel *userModel = [NSKeyedUnarchiver unarchiveObjectWithData:userModelData];
        self.userCellModel.userModel = userModel;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark - kRegisterSuccessNotification
- (void)registerSuccess {
    [self loginSuccess];
}



#pragma mark - ProfileUserTableViewCellDelegate  点击了头像
- (void)tapedAvatar {
    
    NSMutableArray *dictArray = [NSMutableArray new];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
        // 支持 所有相片列表
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:localizeString(@"photo_title_albem"), kDictPhotoName, @(UIImagePickerControllerSourceTypeSavedPhotosAlbum), kDictPhotoType, nil];
        [dictArray addObject:dict];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        // 支持相机
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:localizeString(@"photo_title_camera"), kDictPhotoName, @(UIImagePickerControllerSourceTypeCamera), kDictPhotoType, nil];
        [dictArray addObject:dict];
    }
    /*
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        // 支持 所有相册列表
        pickerType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
     */
    
    NSMutableArray *titleArray = [NSMutableArray new];
    for (NSDictionary *dict in dictArray) {
        [titleArray addObject:[dict objectForKey:kDictPhotoName]];
    }
    
    [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:localizeString(@"cancel") destructiveButtonTitle:nil otherButtonTitles:titleArray tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == dictArray.count) {
            return;
        } else {
            UIImagePickerControllerSourceType type = [[[dictArray objectAtIndex:buttonIndex] objectForKey:kDictPhotoType] integerValue];
            if (UIImagePickerControllerSourceTypeSavedPhotosAlbum == type) {
                [self startElcImagePickerControl];
            } else {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.sourceType = type;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
        }
    }];
}


#pragma mark 打开照片浏览器
- (void)startElcImagePickerControl {
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    elcPicker.maximumImagesCount = 1; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    // elcPicker.mediaTypes = @[kUTTypeImage];
    elcPicker.imagePickerDelegate = self;
    [self presentViewController:elcPicker animated:YES completion:nil];
}


#pragma mark ELCImagePickerControllerDelegate - 选择相册照片回调
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
            UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
            // 上传 image
            [self uploadAvatar:image];
        } else {
            MyLog(@"UIImagePickerControllerReferenceURL = %@", dict);
        }
    }
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark UIImagePickerControllerDelegate 拍照回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image) {
        image = [image scaledToSize:CGSizeMake(100, 100)];
        [self uploadAvatar:image];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)uploadAvatar:(UIImage *)image {
    if (!image) {
        [self.view makeToast:localizeString(@"error_alert_upload_abnormal_image") duration:kToastDuration position:kToastPositionCenter];
        return;
    }
    
    self.userCellModel.avatarImage = image;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
    // IOS 图片上传处理 图片压缩 图片处理 http://blog.csdn.net/yidu_blog/article/details/50837740
    // Post image to server
    __weak typeof(self) weakSelf = self;
    [APIManager postImageWithApI:kAPISetAvatar image:image responseHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            [weakSelf.view makeToast:localizeString(@"error_alert_upload_avatar") duration:kToastDuration position:kToastPositionCenter];
        } else {
            // 图片上传完成后，返回图片id更新到UserDefault中
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            UploadPhotoResponseModel *uploadResponseModel = [[UploadPhotoResponseModel alloc] initWithString:responseString error:nil];
            if (uploadResponseModel.message.length > 0) {
                NSData *userModelData = (NSData *)getObjectFromUserDefaults(kLoginedUser);
                if (userModelData) {
                    UserModel *userModel = [NSKeyedUnarchiver unarchiveObjectWithData:userModelData];
                    userModel.icon = uploadResponseModel.message;
                    NSData *userModelData = [NSKeyedArchiver archivedDataWithRootObject:userModel];
                    saveObjectToUserDefaults(kLoginedUser, userModelData);
                }
            }
        }
    }];
}



@end






