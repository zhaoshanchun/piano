//
//  ContentListCollectionReusableView.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/1.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "ContentListCollectionReusableView.h"

@interface ContentListCollectionReusableView ()

@property (strong, nonatomic) UIView *topLineView;
@property (strong, nonatomic) UIButton *moreButton;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation ContentListCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
//        self.layer.borderColor = [UIColor redColor].CGColor;
//        self.layer.borderWidth = 0.5f;
        
        [self addSubview:self.topLineView];
        [self addSubview:self.moreButton];
        [self addSubview:self.titleLabel];
    }
    return self;
}


- (void)setTitle:(NSString *)title {
    self.titleLabel.attributedText = formatAttributedStringByORFontGuide(@[title, @"BR17B"], nil);
    CGSize size = getSizeForAttributedString(self.titleLabel.attributedText, MAXFLOAT, getFontByKey(@"BR17B").lineHeight);
    self.titleLabel.frame = CGRectMake(0, 20, size.width, size.height);
}


#pragma mark - Action
- (void)moreButtonAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreButtonAction:)]) {
        [self.delegate moreButtonAction:self.indexPath];
    }
}


#pragma mark - Factory method
- (UIView *)topLineView {
    if (_topLineView == nil) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kContentListCollectionReusableViewWidth - kContentListItemMargin*2, 0.5f)];
        _topLineView.backgroundColor = [UIColor orLineColor];
    }
    return _topLineView;
}

- (UIButton *)moreButton {
    if (_moreButton == nil) {
        NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
        style.alignment = NSTextAlignmentRight;
        NSAttributedString *attribute = formatAttributedStringByORFontGuide(@[@">> More", @"dgy13N"], @[style]);
        CGSize size = getSizeForAttributedString(attribute, 200, kContentListCollectionReusableViewHeight - 10);
        _moreButton = [[UIButton alloc] initWithFrame:CGRectMake(kContentListCollectionReusableViewWidth - kContentListItemMargin*2 - size.width, 10, size.width, kContentListCollectionReusableViewHeight - 10)];
        [_moreButton setAttributedTitle:attribute forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _titleLabel;
}

@end
