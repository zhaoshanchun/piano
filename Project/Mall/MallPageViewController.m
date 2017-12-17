//
//  MallPageViewController.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/11/18.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "MallPageViewController.h"
#import "MallGoodsTableViewCell.h"

#import <AlibcTradeBiz/AlibcTradeBiz.h>
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibcTradeBiz/AlibcTradeBiz.h>
#import <AlibcTradeSDK/AlibcTradeSDK.h>
//#import <AlibcTradeBiz/AlibcWebViewController.h>

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
    
    [self setNavigationBarTitle:localizeString(@"商城")];
    
    _onTradeSuccess = ^(AlibcTradeResult *tradeProcessResult){
        if(tradeProcessResult.result ==AlibcTradeResultTypePaySuccess){
            NSString *tip=[NSString stringWithFormat:@"交易成功:成功的订单%@\n，失败的订单%@\n",[tradeProcessResult payResult].paySuccessOrders,[tradeProcessResult payResult].payFailedOrders];
            NSLog(@"%@", tip);
        }else if(tradeProcessResult.result==AlibcTradeResultTypeAddCard){
            NSLog(@"加入购物车成功");
        }
    };
    _onTradeFailure = ^(NSError *error){
        // 退出交易流程
        if (error.code==AlibcErrorCancelled) {
            return ;
        }
        NSDictionary *infor=[error userInfo];
        NSArray*  orderid=[infor objectForKey:@"orderIdList"];
        NSString *tip=[NSString stringWithFormat:@"交易失败:\n订单号\n%@",orderid];
        NSLog(@"%@", tip);
    };
    
    [self addGoods];
}

- (void)setTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:[MallGoodsTableViewCell class] forCellReuseIdentifier:kMallGoodsTableViewCellIdentifier];
}

- (void)addGoods {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *goods = [MallGoodsModel getCurrentGoods];
        if (goods.count > 0) {
            for (MallGoodsModel *item in goods) {
                MallGoodsTableViewCellModel *cellModel = [MallGoodsTableViewCellModel new];
                cellModel.itemModel = item;
                [self.dataArray addObject:cellModel];
            }
        }
        
        dispatch_main_sync_safe(^{
            if (self.dataArray.count > 0) {
                [self.tableView reloadData];
            }
        });
    });
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataArray.count) {
        MallGoodsTableViewCellModel *cellModel = [self.dataArray objectAtIndex:indexPath.row];
        return cellModel.cellHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MallGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMallGoodsTableViewCellIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataArray.count) {
        MallGoodsTableViewCellModel *cellModel = [self.dataArray objectAtIndex:indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:cellModel.itemModel.logoUrl]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     if (!error) {
                                         cell.imageView.backgroundColor = [UIColor clearColor];
                                         cell.imageView.image = image;
                                     }
                                 }];
        NSAttributedString *titleAttribute = formatAttributedStringByORFontGuide(@[cellModel.itemModel.itemName, @"BR16B"], nil);
        cell.title.attributedText = titleAttribute;
        [cell.title sizeToFit];
        
        NSAttributedString *priceAttribute = formatAttributedStringByORFontGuide(@[cellModel.itemModel.price, @"O16B"], nil);
        cell.priceLabel.attributedText = priceAttribute;
        [cell.priceLabel layoutIfNeeded];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataArray.count) {
        return;
    }
    
    MallGoodsTableViewCellModel *cellModel = [self.dataArray objectAtIndex:indexPath.row];
    id<AlibcTradePage> page = [AlibcTradePageFactory itemDetailPage:cellModel.itemModel.itemId];
    [self OpenByPage:page];
}


#pragma mark - Alibc Helper
- (void)OpenByPage:(id<AlibcTradePage>)page {
    AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
    showParam.openType = [self openType];
    //    showParam.backUrl=@"tbopen23082328:https://h5.m.taobao.com";
//    showParam.backUrl=[ALiTradeSDKShareParam sharedInstance].backUrl;
//    BOOL isNeedPush=[ALiTradeSDKShareParam sharedInstance].isNeedPush;
//    BOOL isBindWebview=[ALiTradeSDKShareParam sharedInstance].isBindWebview;
    showParam.backUrl = @"tbopen24684986";
    BOOL isNeedPush = NO;
    BOOL isBindWebview = NO;
    showParam.isNeedPush = isNeedPush;
    showParam.nativeFailMode = [self NativeFailMode];
    
    //    showParam.linkKey = @"tmall_scheme";//暂时拉起天猫
    showParam.linkKey = [self schemeType];
    //    showParam.linkKey = @"dingding_scheme";//暂时拉起天猫
    
    if (isBindWebview) {
//        AlibcWebViewController *view = [[AlibcWebViewController alloc] init];
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
- (NSMutableArray *)getCurrentGoods {
    NSMutableArray *currentGoods = [NSMutableArray new];
    
    MallGoodsModel *goods1 = [MallGoodsModel new];
    goods1.itemId = @"559163223052";
    goods1.itemName = @"备考2018护士执业资格考试轻松过考试达人护士资格考试用书人卫版";
    goods1.price = @"¥59.25";
    goods1.logoUrl = @"https://g-search3.alicdn.com/img/bao/uploaded/i4/i4/3379994517/TB1g3F0g6uhSKJjSspmXXcQDpXa_!!0-item_pic.jpg_80x80.jpg";
    [currentGoods addObject:goods1];
    
    MallGoodsModel *goods2 = [MallGoodsModel new];
    goods2.itemId = @"532960538882";
    goods2.itemName = @"2018年护士资格考试书过关精点 护考必备军医版送懒人必记";
    goods2.price = @"¥119.00";
    goods2.logoUrl = @"https://g-search2.alicdn.com/img/bao/uploaded/i4/i3/766915730/TB2EwNPXj3nyKJjSZFHXXaTCpXa_!!766915730.jpg_80x80.jpg";
    [currentGoods addObject:goods2];
    
    MallGoodsModel *goods3 = [MallGoodsModel new];
    goods3.itemId = @"560314460439";
    goods3.itemName = @"护士资格证考试用书2018年全国护士执业资格考试试题库护考2017护士资格考试历年真题冲刺试卷及解析搭人卫版军医版轻松过职业指导";
    goods3.price = @"¥ 15.80";
    goods3.logoUrl = @"https://g-search2.alicdn.com/img/bao/uploaded/i4/i2/1120654631/TB1mIyVc0LO8KJjSZPcXXaV0FXa_!!0-item_pic.jpg_80x80.jpg";
    [currentGoods addObject:goods3];
    
    MallGoodsModel *goods4 = [MallGoodsModel new];
    goods4.itemId = @"559485047706";
    goods4.itemName = @"现货 2018护士执业资格考试人卫版随身记 护士执业资格证考试2018人卫版护士执业资格考试用书 全国护考护士资格证考试试题2018年";
    goods4.price = @"¥ 39.75";
    goods4.logoUrl = @"https://g-search1.alicdn.com/img/bao/uploaded/i4/i4/2855675733/TB1479LgInI8KJjSspeXXcwIpXa_!!0-item_pic.jpg_80x80.jpg";
    [currentGoods addObject:goods4];
    
    MallGoodsModel *goods5 = [MallGoodsModel new];
    goods5.itemId = @"557994230575";
    goods5.itemName = @"全套】2018年护士资格证考试用书2018人卫版雪狐狸教材+护士资格考试模拟试卷及解析+考点随身记+口袋书护考轻松过试题职业军医版";
    goods5.price = @"¥ 98.00";
    goods5.logoUrl = @"https://g-search2.alicdn.com/img/bao/uploaded/i4/i4/1775910047/TB1Q3oMb7fb_uJkSndVXXaBkpXa_!!0-item_pic.jpg_80x80.jpg";
    [currentGoods addObject:goods5];
    
    MallGoodsModel *goods6 = [MallGoodsModel new];
    goods6.itemId = @"560221209932";
    goods6.itemName = @"现货新版 护士资格证考试用书2018人卫版护士执业资格考试用书教材轻松过+冲刺跑+随身记考试达人卫版2018年护士执业资格考试用书";
    goods6.price = @"¥ 200.30";
    goods6.logoUrl = @"https://g-search3.alicdn.com/img/bao/uploaded/i4/i4/2131382629/TB1sBzbaVHM8KJjSZFwXXcibXXa_!!0-item_pic.jpg_80x80.jpg";
    [currentGoods addObject:goods6];
    
    MallGoodsModel *goods7 = [MallGoodsModel new];
    goods7.itemId = @"562120420675";
    goods7.itemName = @"人卫版2018年全国护士执业资格证考试书全套 教材+习题+试卷+解析";
    goods7.price = @"¥88.00";
    goods7.logoUrl = @"https://g-search1.alicdn.com/img/bao/uploaded/i4/i2/3247180560/TB2oZBzggvD8KJjSsplXXaIEFXa_!!3247180560.jpg_80x80.jpg";
    [currentGoods addObject:goods7];
    
    MallGoodsModel *goods8 = [MallGoodsModel new];
    goods8.itemId = @"43321409127";
    goods8.itemName = @"全套12样】2018年护士执业资格考试用书应试指导教材人卫版+模拟试卷解析+必考点学霸笔记雪狐狸护士职业资格证人机对话软件真试题";
    goods8.price = @"¥ 108.00";
    goods8.logoUrl = @"https://g-search1.alicdn.com/img/bao/uploaded/i4/i3/2168050686/TB1KtymdDAKL1JjSZFCXXXFspXa_!!2-item_pic.png_80x80.jpg";
    [currentGoods addObject:goods8];
    
    MallGoodsModel *goods9 = [MallGoodsModel new];
    goods9.itemId = @"524902250164";
    goods9.itemName = @"【现货速发】人卫版护士资格证考试用书2018护考执业资格考试指导教材轻松过+随身记+冲刺跑共3本可搭军医历年真题试题职业急救包";
    goods9.price = @"¥ 200.25";
    goods9.logoUrl = @"https://g-search3.alicdn.com/img/bao/uploaded/i4/i1/2194134838/TB1QOBmckfb_uJkSndVXXaBkpXa_!!0-item_pic.jpg_80x80.jpg";
    [currentGoods addObject:goods9];
    
    MallGoodsModel *goods10 = [MallGoodsModel new];
    goods10.itemId = @"554092901380";
    goods10.itemName = @"护士资格证考试用书2018年护士资格考试教材历年真题及解析模拟试卷试题库全国护士执业护考职业指导搭轻松过随身记军医人卫版";
    goods10.price = @"¥ 39.80";
    goods10.logoUrl = @"https://g-search1.alicdn.com/img/bao/uploaded/i4/i3/2689011101/TB1VfoOh_nI8KJjSszbXXb4KFXa_!!0-item_pic.jpg_80x80.jpg";
    [currentGoods addObject:goods10];
    
    return currentGoods;
}


@end






