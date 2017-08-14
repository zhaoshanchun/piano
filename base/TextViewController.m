//
//  TextViewController.m
//  base
//
//  Created by kun on 2017/4/24.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "TextViewController.h"

@interface TextViewController ()

@end

@implementation TextViewController


+ (instancetype)TextViewControllerWithKey:(NSString *)key
{
    TextViewController *vc = [TextViewController new];
    vc.key = key;
    //NSLog(@"%s -->%@", __func__, urlString);
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _label = [UITextView new];
    _label.frame = self.view.bounds;
    [_label setEditable:NO];
   // [_label setFont:[UIFont systemFontOfSize:20]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:17],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    _label.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedStringFromTable(self.key, @"Text", nil) attributes:attributes];
    //_label.text = NSLocalizedStringFromTable(@"text_six", @"Text", nil);
    [self.view addSubview:_label];
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

@end
