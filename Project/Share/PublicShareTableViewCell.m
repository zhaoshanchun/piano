//
//  PublicShareTableViewCell.m
//  CLPlayerDemo
//
//  Created by JmoVxia on 2017/8/4.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "PublicShareTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+CLSetRect.h"


@interface PublicShareTableViewCell ()

@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIImageView *placeHolderImageView;
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UILabel *titleLabel;

@end


@implementation PublicShareTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryView = nil;
        self.clipsToBounds = YES;
        [self addContent];
    }
    return self;
}

- (void)addContent {
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.placeHolderImageView];
    [self.contentView addSubview:self.playButton];
    [self.contentView addSubview:self.titleLabel];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.backgroundColor = [UIColor orTableViewCellHighlightedColor];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setCellModel:(PublicShareCellModel *)cellModel {
    if (!cellModel) {
        return;
    }
    _cellModel = cellModel;
    
    self.contentLabel.frame = cellModel.contentFrame;
    self.contentLabel.attributedText = cellModel.contentAttribute;
    
    if (cellModel.detailAttribute.length > 0) {
        self.detailLabel.frame = cellModel.detailFrame;
        self.detailLabel.attributedText = cellModel.detailAttribute;
    }
    
    [self stopedPlay];
    self.placeHolderImageView.frame = cellModel.playViewFrame;
    self.playButton.center = self.placeHolderImageView.center;
    __block UIImage *placeholderImage = [UIImage imageNamed:@"Placeholder"];
    [[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:self.cellModel.iconUrl] completion:^(BOOL isInCache) {
        if (isInCache) {
            // 本地存在图片, 替换占位图片
            placeholderImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cellModel.iconUrl];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.placeHolderImageView sd_setImageWithURL:[NSURL URLWithString:cellModel.iconUrl] placeholderImage:placeholderImage];
        });
    }];
    
    self.titleLabel.frame = cellModel.titleFrame;
    self.titleLabel.attributedText = cellModel.titleAttribute;
}

- (void)addPlayView:(CLPlayerView *)playView {
    [self.contentView addSubview:playView];
    playView.url = [NSURL URLWithString:self.cellModel.shareModel.video_url];
    [playView playVideo];
    [self startedPlay];
}

- (void)playAction:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(shouldPlayVideoForCell:)]){
        [_delegate shouldPlayVideoForCell:self];
    }
}

- (void)startedPlay {
    self.placeHolderImageView.hidden = YES;
    self.playButton.hidden = YES;
}

- (void)stopedPlay {
    self.placeHolderImageView.hidden = NO;
    self.playButton.hidden = NO;
}

- (UIImage *)getPictureWithName:(NSString *)name {
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"CLPlayer" ofType:@"bundle"]];
    NSString *path = [bundle pathForResource:name ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];
}

- (CGFloat)cellOffset{
    /*
     - (CGRect)convertRect:(CGRect)rect toView:(nullable UIView *)view;
     将rect由rect所在视图转换到目标视图view中，返回在目标视图view中的rect
     这里用来获取self在window上的位置
     */
    CGRect toWindow = [self convertRect:self.bounds toView:self.window];
    CGPoint windowCenter = self.superview.center;                   //获取父视图的中心
    CGFloat cellOffsetY = CGRectGetMidY(toWindow) - windowCenter.y; //cell在y轴上的位移
    CGFloat offsetDig = 2 * cellOffsetY / self.superview.frame.size.height ; //位移比例
    //要补偿的位移,self.superview.frame.origin.y是tableView的Y值，这里加上是为了让图片从最上面开始显示
    CGFloat offset = - offsetDig * (PublicShareCellImageHeight - PublicShareCellHeight) / 2;
    CGAffineTransform transY = CGAffineTransformMakeTranslation(0,offset);  //让placeHolderImageViewY轴方向位移offset
    self.placeHolderImageView.transform   = transY;
    return offset;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // self.playButton.CLcenterX = self.CLwidth/2.0;
    // self.playButton.CLcenterY = self.CLheight/2.0;
    // self.placeHolderImageView.CLwidth = self.CLwidth;
}


#pragma mark - Factory method
- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UILabel *)detailLabel {
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (UIButton *)playButton {
    if (_playButton == nil) {
        UIImage *playImage = [UIImage imageNamed:@"play"];
        _playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, playImage.size.width, playImage.size.height)];
        // [_playButton setBackgroundImage:[self getPictureWithName:@"CLPlayBtn"] forState:UIControlStateNormal];
        [_playButton setImage:playImage forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UIImageView *)placeHolderImageView {
    if (_placeHolderImageView == nil) {
        _placeHolderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, - (PublicShareCellImageHeight - PublicShareCellHeight) * 0.5, CLscreenWidth, PublicShareCellImageHeight)];
        _placeHolderImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _placeHolderImageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

@end
