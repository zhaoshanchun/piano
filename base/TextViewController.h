//
//  TextViewController.h
//  base
//
//  Created by kun on 2017/4/24.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewController : UIViewController
+ (instancetype)TextViewControllerWithKey:(NSString *)key;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) UITextView *label;

@end
