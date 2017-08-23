//
//  LoginTableViewCell.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/23.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "LoginTableViewCell.h"


@interface LoginTableViewCell () <UITextFieldDelegate>

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIImageView *iconImageView;

@end

@implementation LoginTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryView = nil;
        self.backgroundColor = [UIColor whiteColor];
        
        [self addContent];
    }
    return self;
}

- (void)addContent {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.iconImageView];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setCellModel:(LoginTableViewCellModel *)cellModel {
    if (!cellModel) {
        return;
    }
    _cellModel = cellModel;
    
    self.titleLabel.frame = cellModel.titleFrame;
    self.titleLabel.attributedText = cellModel.titleAttriute;
    self.textField.frame = cellModel.inputFrame;
    self.textField.placeholder = cellModel.placeHolder;
    
    if (LoginTableViewCellVerification == cellModel.loginCellellType) {
        self.iconImageView.hidden = NO;
        self.iconImageView.frame = cellModel.verificationFrame;
        if (cellModel.imageUrl.length > 0) {
            __weak typeof(self) weakSelf = self;
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:cellModel.imageUrl]
                                  placeholderImage:[UIImage imageNamed:@""]
                                           options:SDWebImageLowPriority
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                             weakSelf.iconImageView.image = image;
                                         }];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateFrameForEdittingCell:isEditting:)]) {
        [self.delegate updateFrameForEdittingCell:self isEditting:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.cellModel.inputedContent = textField.text;
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateFrameForEdittingCell:isEditting:)]) {
        [self.delegate updateFrameForEdittingCell:self isEditting:NO];
    }
}


#pragma mark - Factory method
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _titleLabel;
}

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.delegate = self;
        [_textField showBorder:[UIColor orLineColor]];
        _textField.layer.cornerRadius = 4.f;
        _textField.layer.masksToBounds = YES;
    }
    return _textField;
}

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_iconImageView showBorder:[UIColor redColor]];
        _iconImageView.hidden = YES;
    }
    return _iconImageView;
}


@end
