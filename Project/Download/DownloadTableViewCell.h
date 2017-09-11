//
//  DownloadTableViewCell.h
//  sifakaoshi
//
//  Created by kun on 2017/9/7.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadTableViewCell : UITableViewCell

@property (nonatomic, strong)   UIImageView       *iconImageView;
@property (nonatomic, strong)   UIImageView       *playImageView;
@property (nonatomic, strong)   UIButton          *dlSwitchButton;

@property (nonatomic, strong)   UILabel           *title;
@property (nonatomic, strong)   UIProgressView    *processView;
@property (nonatomic, strong)   UILabel           *rateValue;
@property (nonatomic, strong)   UILabel           *processValue;

@end
