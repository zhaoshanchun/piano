//
//  MallPageViewController.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/11/18.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "MallPageViewController.h"

#import <AlibcTradeBiz/AlibcTradeBiz.h>
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibcTradeBiz/AlibcTradeBiz.h>
#import <AlibcTradeSDK/AlibcTradeSDK.h>

@interface MallPageViewController ()

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIButton *goButton;

@property (nonatomic, strong) AlibcTradeProcessSuccessCallback onTradeSuccess;
@property (nonatomic, strong) AlibcTradeProcessFailedCallback onTradeFailure;

@end

@implementation MallPageViewController

- (id)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = NO; // 当前页面需要 Bottom Bar
        self.hideNavigationBar = NO;
        
        _dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarTitle:localizeString(@"exerise_title")];
    
    [self.view addSubview:self.textField];
    [self.view addSubview:self.goButton];
    
    UITextView *label = [[UITextView alloc] initWithFrame:CGRectMake(20, 300, 280, 60)];
    [label setFontAndTextColorByKey:@"dgy14N"];
    label.text = @"534915679859 \ 549091479417 \ 545034488667 \ 551746065153";
    [self.view addSubview:label];
    
    _onTradeSuccess=^(AlibcTradeResult *tradeProcessResult){
        if(tradeProcessResult.result ==AlibcTradeResultTypePaySuccess){
            NSString *tip=[NSString stringWithFormat:@"交易成功:成功的订单%@\n，失败的订单%@\n",[tradeProcessResult payResult].paySuccessOrders,[tradeProcessResult payResult].payFailedOrders];
            NSLog(@"%@", tip);
        }else if(tradeProcessResult.result==AlibcTradeResultTypeAddCard){
            NSLog(@"加入购物车成功");
        }
    };
    _onTradeFailure=^(NSError *error){
        //        退出交易流程
        if (error.code==AlibcErrorCancelled) {
            return ;
        }
        NSDictionary *infor=[error userInfo];
        NSArray*  orderid=[infor objectForKey:@"orderIdList"];
        NSString *tip=[NSString stringWithFormat:@"交易失败:\n订单号\n%@",orderid];
        NSLog(@"%@", tip);
    };
}


#pragma mark - Action
- (void)goAction {
    NSLog(@" ----- pid ----- = %@", self.textField.text);
    
    id<AlibcTradePage> page = [AlibcTradePageFactory itemDetailPage:self.textField.text];
    [self OpenByPage:page];
    
}

- (void)OpenByPage:(id<AlibcTradePage>)page
{
    AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
    showParam.openType = [self openType];
    //    showParam.backUrl=@"tbopen23082328:https://h5.m.taobao.com";
//    showParam.backUrl=[ALiTradeSDKShareParam sharedInstance].backUrl;
//    BOOL isNeedPush=[ALiTradeSDKShareParam sharedInstance].isNeedPush;
//    BOOL isBindWebview=[ALiTradeSDKShareParam sharedInstance].isBindWebview;
    showParam.backUrl=@"tbopen24684986";
    BOOL isNeedPush=NO;
    BOOL isBindWebview=NO;
    showParam.isNeedPush=isNeedPush;
    showParam.nativeFailMode=[self NativeFailMode];
    
    //    showParam.linkKey = @"tmall_scheme";//暂时拉起天猫
    showParam.linkKey=[self schemeType];
    //    showParam.linkKey = @"dingding_scheme";//暂时拉起天猫
    
    if (isBindWebview) {
        
//        ALiTradeWebViewController* view = [[ALiTradeWebViewController alloc] init];
//        NSInteger res = [[AlibcTradeSDK sharedInstance].tradeService show:view webView:view.webView page:page showParams:showParam taoKeParams:[self taokeParam] trackParam:[self customParam] tradeProcessSuccessCallback:self.onTradeSuccess tradeProcessFailedCallback:self.onTradeFailure];
//        if (res == 1) {
//            [self.navigationController pushViewController:view animated:YES];
//        }
    } else {
        if (isNeedPush) {
            [[AlibcTradeSDK sharedInstance].tradeService show:self.navigationController page:page showParams:showParam taoKeParams:[self taokeParam] trackParam:[self customParam] tradeProcessSuccessCallback:self.onTradeSuccess tradeProcessFailedCallback: self.onTradeFailure];
        } else {
            [[AlibcTradeSDK sharedInstance].tradeService show:self page:page showParams:showParam taoKeParams:[self taokeParam] trackParam:[self customParam] tradeProcessSuccessCallback:self.onTradeSuccess tradeProcessFailedCallback: self.onTradeFailure];
        }
        
    }
}

-(AlibcTradeTaokeParams*)taokeParam{
//    if ([ALiTradeSDKShareParam sharedInstance].isUseTaokeParam) {
//        AlibcTradeTaokeParams *taoke = [[AlibcTradeTaokeParams alloc] init];
//        taoke.pid =[[ALiTradeSDKShareParam sharedInstance].taoKeParams objectForKey:@"pid"];
//        taoke.subPid = [[ALiTradeSDKShareParam sharedInstance].taoKeParams objectForKey:@"subPid"];
//        taoke.unionId = [[ALiTradeSDKShareParam sharedInstance].taoKeParams objectForKey:@"unionId"];
//        taoke.adzoneId = [[ALiTradeSDKShareParam sharedInstance].taoKeParams objectForKey:@"adzoneId"];
//        taoke.extParams = [[ALiTradeSDKShareParam sharedInstance].taoKeParams objectForKey:@"extParams"];
//        return taoke;
//    } else {
//        return nil;
//    }
    return nil;
}
-(NSDictionary *)customParam{
//    NSDictionary *customParam=[NSDictionary dictionaryWithDictionary:[ALiTradeSDKShareParam sharedInstance].customParams];
//    return customParam;
    return nil;
}
-(AlibcOpenType)openType{
    
    AlibcOpenType openType=AlibcOpenTypeAuto;
    // switch ([ALiTradeSDKShareParam sharedInstance].openType) {
    switch (0) {
        case 0:
            openType=AlibcOpenTypeAuto;
            break;
        case 1:
            openType=AlibcOpenTypeNative;
            break;
        case 2:
            openType=AlibcOpenTypeH5;
            break;
            
        default:
            break;
    }
    return openType;
}
-(AlibcNativeFailMode )NativeFailMode{
    AlibcNativeFailMode openType=AlibcNativeFailModeJumpH5;
    // switch ([ALiTradeSDKShareParam sharedInstance].NativeFailMode) {
    switch (0) {
        case 0:
            openType=AlibcNativeFailModeJumpH5;
            break;
        case 1:
            openType=AlibcNativeFailModeJumpDownloadPage;
            break;
        case 2:
            openType=AlibcNativeFailModeJumpBrowser;
            break;
        case 3:
            openType=AlibcNativeFailModeNone;
            break;
        default:
            break;
    }
    return openType;
    
}
-(NSString*)schemeType{
    return @"taobao_scheme";
//    NSString*  linkKey=@"tmall_scheme";
//    switch ([ALiTradeSDKShareParam sharedInstance].linkKey) {
//        case 0:
//            linkKey=@"taobao_scheme";
//            break;
//        case 1:
//            linkKey=@"tmall_scheme";
//            break;
//        default:
//            break;
//    }
//    return linkKey;
    
}


#pragma mark - Factory method
- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, 260, 50)];
        [_textField setFontAndTextColorByKey:@"BR16N"];
        _textField.layer.borderColor = [UIColor redColor].CGColor;
        _textField.layer.borderWidth = 0.5f;
        _textField.layer.masksToBounds = YES;
        _textField.layer.cornerRadius = 4.f;
        _textField.text = @"534915679859";
    }
    return _textField;
}
- (UIButton *)goButton {
    if (_goButton == nil) {
        _goButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 200, 70, 40)];
        [_goButton setFontAndTextColorByKey:@"BR16N" forState:UIControlStateNormal];
        [_goButton setTitle:@"Go" forState:UIControlStateNormal];
        _goButton.layer.borderColor = [UIColor grayColor].CGColor;
        _goButton.layer.borderWidth = 0.5f;
        _goButton.layer.masksToBounds = YES;
        _goButton.layer.cornerRadius = 4.f;
        [_goButton addTarget:self action:@selector(goAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goButton;
}



@end






