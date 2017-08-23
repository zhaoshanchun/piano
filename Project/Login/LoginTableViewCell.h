//
//  LoginTableViewCell.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/23.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "UIBaseTableViewCell.h"
#import "LoginTableViewCellModel.h"

#define kLoginTableViewCellIdentifier @"kLoginTableViewCellIdentifier"

@protocol LoginTableViewCellDelegate <NSObject>

@end

@interface LoginTableViewCell : UIBaseTableViewCell

@property (weak, nonatomic) id<LoginTableViewCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *idnexPath;
@property (strong, nonatomic) LoginTableViewCellModel *cellModel;

@end
