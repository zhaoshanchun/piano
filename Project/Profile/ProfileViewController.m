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

#define kSectionNumber 3

@interface ProfileViewController () <LoginViewControllerDelegate, RegisterViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, ProfileUserTableViewCellDelegate>

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
                [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"cancel取消" destructiveButtonTitle:nil otherButtonTitles:@[@"退出登陆"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
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
                             @"https://itunes.apple.com/cn/app/id%@?mt=8", AppID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        } else {
            [self.navigationController pushViewController:[UserFeedbackViewController new] animated:YES];
        }
    } else {
        
    }
}


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
    /*
    UIActionSheet *actionSheet;
    NSString *actionSheetTitle = @"添加图片";
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        actionSheet=[[UIActionSheet alloc] initWithTitle:(actionSheetTitle) delegate:self cancelButtonTitle:(@"取消") destructiveButtonTitle:(nil) otherButtonTitles:(@"相册"),@"拍照", nil];
    } else {
        actionSheet=[[UIActionSheet alloc] initWithTitle:(actionSheetTitle) delegate:self cancelButtonTitle:(@"取消") destructiveButtonTitle:(nil) otherButtonTitles:@"相册", nil];
    }
    
    if (!([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)) {
        [actionSheet showInView:self.view];
    } else {
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
     */
    
    NSInteger pickerType;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        NSLog(@"支持相机");
        pickerType = UIImagePickerControllerSourceTypeCamera;
    }
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        NSLog(@"支持图库");
        pickerType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        NSLog(@"支持相片库");
        pickerType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
    
    [UIActionSheet showInView:self.view withTitle:localizeString(@"select_image") cancelButtonTitle:localizeString(@"cancel") destructiveButtonTitle:nil otherButtonTitles:@[localizeString(@"photo_album")] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }];
}

/*
#pragma mark UIActionSheetDelegate - 选择相机还是相册
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSUInteger sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // 支持相机拍照的情况:  0:相册   1:相机   2:取消
        switch (buttonIndex) {
            case 0: {
                [self startElcImagePickerControl];
                return;
                break;
            }
            case 1: {
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            }
            case 2:
            default:
                return;
        }
    } else {
        // 仅支持相册选择的情况
        if (buttonIndex == 1) {
            return;
        } else {
            [self startElcImagePickerControl];
            return;
        }
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = sourceType;
    
    if (!([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self presentViewController:imagePickerController animated:YES completion:^{}];
            }];
        } else {
            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
            [popover presentPopoverFromRect:self.tableView.tableHeaderView.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    } else {
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
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
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                // 上传 image
                [self uploadAvatar:image];
            } else {
                MyLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo){
            
        } else {
            MyLog(@"Uknown asset type");
        }
    }
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}
*/

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

-(void) uploadAvatar:(UIImage *)image {
    if (!image) {
        [self.view makeToast:localizeString(@"图片异常，无法上传！") duration:kToastDuration position:kToastPositionCenter];
        return;
    }
    
    self.userCellModel.avatarImage = image;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
    
    // Post image to server
    __weak typeof(self) weakSelf = self;
    [APIManager postImageWithApI:kAPISetAvatar image:image responseHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            [weakSelf.view makeToast:localizeString(@"上传头像失败！") duration:kToastDuration position:kToastPositionCenter];
        }
    }];
}



@end






