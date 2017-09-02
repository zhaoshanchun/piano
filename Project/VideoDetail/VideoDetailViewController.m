//
//  VideoDetailViewController.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/30.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "VideoDetailViewController.h"

@interface VideoDetailViewController ()

@end

@implementation VideoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    [self setNavigationBarTitle:@"Video detail"];
    
    UIButton *testBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    testBtn.backgroundColor = [UIColor whiteColor];
    [testBtn setTitle:@"Back" forState:UIControlStateNormal];
    [testBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(testBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
    
    
    [self getSource];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testBtnOnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - API Action
- (void)getSource {
    [self.view showLoading];
    __weak typeof(self) weakSelf = self;
    // http://www.appshopping.store/app/program_source?uuid=XMTc0MDc2NDIxMg==&cert=12345
    NSString *apiName = [NSString stringWithFormat:@"%@?uuid=XMTc0MDc2NDIxMg==&cert=12345", kAPIContentDetail];
    [APIManager requestWithApi:apiName httpMethod:kHTTPMethodGet httpBody:nil responseHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!weakSelf) {
            return;
        }
        [weakSelf.view hideLoading];
        
        if (connectionError) {
            MyLog(@"error : %@",[connectionError localizedDescription]);
        } else {
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            SourceResponseModel *responseModel = [[SourceResponseModel alloc] initWithString:responseString error:nil];
            if (responseModel.errorCode != 0) {
                [weakSelf.view makeToast:responseModel.msg duration:kToastDuration position:kToastPositionCenter];
                return;
            }
            
            SourceModel *sourceModel = responseModel.object;
            MyLog(@"sourceModel.title = %@", sourceModel.title);
        }
    }];
}

@end
