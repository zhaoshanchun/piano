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

@class LoginTableViewCell;
@protocol LoginTableViewCellDelegate <NSObject>

- (void)updateFrameForEdittingCell:(LoginTableViewCell *)cell isEditting:(BOOL)isEditting;
- (void)dropDownButtonClickCell:(LoginTableViewCell *)cell isOpen:(BOOL)openDropDownList;

@end

@interface LoginTableViewCell : UIBaseTableViewCell

@property (weak, nonatomic) id<LoginTableViewCellDelegate> delegate;
@property (strong, nonatomic) LoginTableViewCellModel *cellModel;

@end
