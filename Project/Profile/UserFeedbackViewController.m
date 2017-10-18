//
//  UserFeedbackViewController.m
//  zuqiujiaoxue
//
//  Created by kun on 2017/6/6.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "UserFeedbackViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "iToast.h"

@interface UserFeedbackViewController ()<UITextViewDelegate, MFMailComposeViewControllerDelegate>
{
    long MaxLen;
}
@property (nonatomic, strong) UIActivityIndicatorView    *loading;    //详情名字
@property (nonatomic,strong) NSTimer          *timer;
@property (nonatomic, strong) MFMailComposeViewController *mailCompose;
@end

@implementation UserFeedbackViewController


- (void)dealloc {
    //NSLog(@"--- --- ---  UserFeedbackViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBackButtonWithImageKey:@"common_back"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = localizeString(@"profile_feedBack");
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tabBarController.tabBar.hidden=YES;

    UITextView *contentTextView = [UITextView new];
    contentTextView.translatesAutoresizingMaskIntoConstraints = NO;
    contentTextView.backgroundColor = [UIColor whiteColor];
    contentTextView.layer.borderColor = [[UIColor colorWithRed:150.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0]CGColor];
    contentTextView.layer.cornerRadius = 5.0;
    contentTextView.layer.borderWidth = 1.5;
    contentTextView.font = [UIFont systemFontOfSize:15];
    contentTextView.returnKeyType = UIReturnKeyDone;
    contentTextView.delegate = self;
    contentTextView.text = localizeString(@"feedback_notice_content_min");
    MaxLen = 0;
    contentTextView.textColor = [UIColor lightGrayColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChangeText:) name:UITextViewTextDidChangeNotification object:contentTextView];
    [self.view addSubview:contentTextView];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentTextView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:230]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentTextView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:10]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentTextView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-5]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentTextView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:5]];
    
    UIButton *button = [UIButton new];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = [UIColor colorWithRed:57/255.0 green:157/255.0 blue:229/255.0 alpha:1.0];;
    button.layer.masksToBounds = YES;

    [button setTitle:localizeString(@"commit") forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateHighlighted];

    [button addTarget:self action:@selector(buttonClickUp:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(buttonClickDown:) forControlEvents:UIControlEventTouchDown];


    [self.view addSubview:button];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:50]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentTextView attribute:NSLayoutAttributeBottom multiplier:1 constant:10]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-5]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:5]];

    _loading = [UIActivityIndicatorView new];
    _loading.translatesAutoresizingMaskIntoConstraints = NO;
    //_loading.backgroundColor = [UIColor blackColor];
    _loading.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];;
    //_loading.layer.cornerRadius = 8;
    _loading.color = [UIColor whiteColor];
    CGAffineTransform transform = CGAffineTransformMakeScale(3.0f, 3.0f);
    _loading.transform = transform;
    [self.view addSubview:_loading];

    //[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_loading attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:160]];
    
   // [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_loading attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:160]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_loading attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_loading attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    
    UIButton *button1 = [UIButton new];
    button1.translatesAutoresizingMaskIntoConstraints = NO;
    button1.backgroundColor = [UIColor clearColor];
    [button1 addTarget:self action:@selector(contactUs:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button1];
    

    
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:130]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-25]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    UIImageView *image = [UIImageView new];
    image.frame = CGRectMake(3, 6, 50, 25);
    image.image = [UIImage imageNamed:@"Mail.png"];
    [button1 addSubview:image];
    UILabel *us = [UILabel new];
    us.frame = CGRectMake(58, 3, 100, 30);
    us.text = localizeString(@"feedback_title_contact");
    us.textColor = [UIColor blackColor];
    [button1 addSubview:us];
}


-(void)contactUs:(UIButton *)sender{
    NSLog(@"%s ",__func__);
    //if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
    //    [self sendEmailAction]; // 调用发送邮件的代码
    //}
    //创建可变的地址字符串对象
    NSMutableString *mailUrl = [[NSMutableString alloc] init];
    //添加收件人,如有多个收件人，可以使用componentsJoinedByString方法连接，连接符为","
    NSString *recipients = @"hk520@qq.com"; // TODO...
    [mailUrl appendFormat:@"mailto:%@?", recipients];
    //添加抄送人
   // NSString *ccRecipients = @"1622849369@qq.com";
   // [mailUrl appendFormat:@"&cc=%@", ccRecipients];
    //添加密送人
    //NSString *bccRecipients = @"15690725786@163.com";
    //[mailUrl appendFormat:@"&bcc=%@", bccRecipients];
    //添加邮件主题
    [mailUrl appendFormat:@"&subject=%@",@"用户反馈"];
    //添加邮件内容
    [mailUrl appendString:@"&body=<b>请在此输入正文!</b>"];
    //跳转到系统邮件App发送邮件
    NSString *emailPath = [mailUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:emailPath] options:@{} completionHandler:nil];
}

-(void)buttonClickDown:(UIButton *)sender{
    sender.backgroundColor = [UIColor colorWithRed:57/255.0 green:157/255.0 blue:229/255.0 alpha:0.8];
}

-(void)buttonClickUp:(UIButton *)sender{
    NSLog(@"%s MaxLen %ld",__func__, MaxLen);
    sender.backgroundColor = [UIColor colorWithRed:57/255.0 green:157/255.0 blue:229/255.0 alpha:1.0];
    if(MaxLen <= 3)
    {
        [[[[iToast makeText:localizeString(@"feedback_content_min")]setGravity:iToastGravityCenter] setDuration:iToastDurationShort*2] show];
        return;
    }
    [_loading startAnimating];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFunc) userInfo:nil repeats:NO];
}

- (void)timerFunc{
    NSLog(@"%s ",__func__);
   [[[[iToast makeText:localizeString(@"feedback_notice_commit_success")]setGravity:iToastGravityCenter] setDuration:iToastDurationShort] show];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
}

#pragma mark - UITextView方法
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    textView.text=@"";
    textView.textColor = [UIColor blackColor];
    MaxLen = 0;
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChangeText:(NSNotification *)notification

{
    UITextView *textView = (UITextView *)notification.object;
    NSString *toBeString = textView.text;
    
    MaxLen =  [toBeString length];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)sendEmailAction
{
    // 邮件服务器
    _mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    _mailCompose.mailComposeDelegate = self;

    [_mailCompose setMailComposeDelegate:self];
    
    // 设置邮件主题
    [_mailCompose setSubject:@"用户反馈"];
    
    // 设置收件人
    [_mailCompose setToRecipients:@[@"hk502@qq.com"]];
    // 设置抄送人
    //[mailCompose setCcRecipients:@[@"邮箱号码"]];
    // 设置密抄送
    //[mailCompose setBccRecipients:@[@"邮箱号码"]];
    
    /**
     *  设置邮件的正文内容
     */
    //NSString *emailContent = @"我是邮件内容";
    // 是否为HTML格式
    //[mailCompose setMessageBody:emailContent isHTML:NO];
    // 如使用HTML格式，则为以下代码
    //    [mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
    
    /**
     *  添加附件
     */
    /*
    UIImage *image = [UIImage imageNamed:@"image"];
    NSData *imageData = UIImagePNGRepresentation(image);
    [mailCompose addAttachmentData:imageData mimeType:@"" fileName:@"custom.png"];
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"pdf"];
    NSData *pdf = [NSData dataWithContentsOfFile:file];
    [mailCompose addAttachmentData:pdf mimeType:@"" fileName:@"7天精通IOS233333"];
    */
    

    
    // 弹出邮件发送视图
    [self presentViewController:_mailCompose animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSLog(@"Mail Close...");
    switch (result)
    {
        case MFMailComposeResultCancelled: // 用户取消编辑
            NSLog(@"Mail send canceled...");
           // [controller dismissViewControllerAnimated:YES completion:nil];
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent: // 用户点击发送
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
    }
    NSLog(@"Mail Close...");
    // 关闭邮件发送视图
   // [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
