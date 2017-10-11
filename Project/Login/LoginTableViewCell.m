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

@property (strong, nonatomic) UIButton *dropDownListButton;

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
    [self.contentView addSubview:self.dropDownListButton];
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
    
    self.iconImageView.hidden = YES;
    self.dropDownListButton.hidden = YES;
    
    self.titleLabel.frame = cellModel.titleFrame;
    self.titleLabel.attributedText = cellModel.titleAttriute;
    self.textField.frame = cellModel.inputFrame;
    self.textField.placeholder = cellModel.placeHolder;
    self.textField.text = cellModel.inputedContent;
    self.textField.secureTextEntry = (cellModel.loginCellellType == LoginTableViewCellPassWord || cellModel.loginCellellType == LoginTableViewCellConfirmPassWord);
    // [self.textField borderRectForBounds:CGRectMake(5, 0, CGRectGetWidth(cellModel.inputFrame) - 5*2, CGRectGetHeight(cellModel.inputFrame))];
    
    if (LoginTableViewCellVerification == cellModel.loginCellellType) {
        self.iconImageView.hidden = NO;
        self.iconImageView.frame = cellModel.verificationFrame;
        if (cellModel.verificationFilePath.length > 0) {
            UIImage *image = [UIImage imageWithContentsOfFile:cellModel.verificationFilePath];
            self.iconImageView.image = image;
        }
    } else if (LoginTableViewCellMail == cellModel.loginCellellType) {
        self.dropDownListButton.hidden = NO;
        self.dropDownListButton.frame = cellModel.dorpDownButtonFrame;
        
        [self.dropDownListButton setAttributedTitle:cellModel.dorpDownTitleAttribute forState:UIControlStateNormal];
        UIImage *image = [UIImage imageNamed:cellModel.isDorpDowning ? @"common_up_arrow" : @"common_down_arrow"];
        [self.dropDownListButton setImage:image forState:UIControlStateNormal];
        
        CGFloat margin = 5;
        CGSize size = getSizeForAttributedString(cellModel.dorpDownTitleAttribute, MAXFLOAT, MAXFLOAT);
        [self.dropDownListButton setImageEdgeInsets:UIEdgeInsetsMake(0, size.width + margin, 0, -(size.width + margin/2))];
        [self.dropDownListButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -(image.size.width + margin/2), 0, image.size.width + margin)];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}


#pragma mark - button Action
- (void)dropDownListButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropDownButtonClickCell:isOpen:)]) {
        [self.delegate dropDownButtonClickCell:self isOpen:!self.cellModel.isDorpDowning];
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
        _textField.returnKeyType = UIReturnKeyDone;
        [_textField setFontAndTextColorByKey:@"DGY14N"];
        [_textField showBorder:[UIColor orLineColor]];
        _textField.layer.cornerRadius = 4.f;
        _textField.layer.masksToBounds = YES;
        // _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 1)];
    }
    return _textField;
}

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        // [_iconImageView showBorder:[UIColor redColor]];
        _iconImageView.hidden = YES;
    }
    return _iconImageView;
}

- (UIButton *)dropDownListButton {
    if (_dropDownListButton == nil) {
        NSAttributedString *titleAttribute = formatAttributedStringByORFontGuide(@[@"@qq.com", @"BR15N"], nil);
        UIImage *image = [UIImage imageNamed:@"common_down_arrow"];
        CGSize size = getSizeForAttributedString(titleAttribute, MAXFLOAT, MAXFLOAT);
        CGFloat width = size.width + 5 + image.size.width;
        _dropDownListButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, MAX(size.height, image.size.height))];
        [_dropDownListButton setAttributedTitle:titleAttribute forState:UIControlStateNormal];
        [_dropDownListButton setImage:image forState:UIControlStateNormal];
        [_dropDownListButton addTarget:self action:@selector(dropDownListButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _dropDownListButton.hidden = YES;
        
//        [_dropDownListButton showBorder:[UIColor redColor]];
    }
    return _dropDownListButton;
}

@end


