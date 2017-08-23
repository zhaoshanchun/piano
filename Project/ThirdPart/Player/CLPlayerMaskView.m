//
//  CLPlayerMaskView.m
//  CLPlayerDemo
//
//  Created by JmoVxia on 2017/2/24.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CLPlayerMaskView.h"
#import "CLSlider.h"
//#import "Masonry.h"
//间隙
#define Padding        10
//顶部底部工具条高度
#define ToolBarHeight     40
//进度条颜色
#define ProgressColor     [UIColor colorWithRed:0.54118 green:0.51373 blue:0.50980 alpha:1.00000]
//缓冲颜色
#define ProgressTintColor [UIColor orangeColor]
//播放完成颜色
#define PlayFinishColor   [UIColor whiteColor]


@interface CLPlayerMaskView ()


@end

@implementation CLPlayerMaskView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initViews];
    }
    return self;
}
- (void)initViews{
    //[self addSubview:self.topToolBar];
    [self addSubview:self.bottomToolBar];
    [self addSubview:self.activity];
    [self.topToolBar addSubview:self.backButton];
    [self.bottomToolBar addSubview:self.playButton];
    [self.bottomToolBar addSubview:self.fullButton];
    [self.bottomToolBar addSubview:self.currentTimeLabel];
    [self.bottomToolBar addSubview:self.totalTimeLabel];
    [self.bottomToolBar addSubview:self.progress];
    [self.bottomToolBar addSubview:self.slider];
    [self addSubview:self.failButton];
    [self makeFailButtonConstraints];
    [self makeActivityConstraints];
    //[self makeTopToolBarConstraints];
    [self makeBottomToolBarConstraints];
    self.fullButton.hidden = YES;
    self.totalTimeLabel.hidden = YES;
    self.topToolBar.backgroundColor = [UIColor colorWithRed:0.00000f green:0.00000f blue:0.00000f alpha:0.50000f];
    self.bottomToolBar.backgroundColor = [UIColor colorWithRed:0.00000f green:0.00000f blue:0.00000f alpha:0.50000f];
    
}
#pragma mark - 约束

- (void)makeFailButtonConstraints
{
    //activity左侧与父视图左侧对齐
    NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:self.failButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.failButton.superview attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    //activity右侧与父视图右侧对齐
    NSLayoutConstraint* rightConstraint = [NSLayoutConstraint constraintWithItem:self.failButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.failButton.superview attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    leftConstraint.active = YES;
    rightConstraint.active = YES;
}

- (void)makeActivityConstraints
{
    //activity左侧与父视图左侧对齐
    NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:self.activity attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.activity.superview attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    //activity右侧与父视图右侧对齐
    NSLayoutConstraint* rightConstraint = [NSLayoutConstraint constraintWithItem:self.activity attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.activity.superview attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    leftConstraint.active = YES;
    rightConstraint.active = YES;
}


- (void)makeTopToolBarConstraints
{
    //topToolBar左侧与父视图左侧对齐
    NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:self.topToolBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.topToolBar.superview attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
    
    //topToolBar右侧与父视图右侧对齐
    NSLayoutConstraint* rightConstraint = [NSLayoutConstraint constraintWithItem:self.topToolBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.topToolBar.superview attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
    
    //topToolBar顶部与父视图顶部对齐
    NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:self.topToolBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topToolBar.superview attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    
    //topToolBar高度为父视图高度40
    NSLayoutConstraint* heightConstraint = [NSLayoutConstraint constraintWithItem:self.topToolBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:ToolBarHeight];
    
    leftConstraint.active = YES;
    rightConstraint.active = YES;
    topConstraint.active = YES;
    heightConstraint.active = YES;
    
    //backButton左侧与父视图左侧对齐
    NSLayoutConstraint* backButtonLeftConstraint = [NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.backButton.superview attribute:NSLayoutAttributeLeading multiplier:1.0f constant:5.0f];
    
    //backButton居父视图Y柱中间
    NSLayoutConstraint* backButtonTopConstraint = [NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.backButton.superview attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    //backButton高度为父视图高度25
    NSLayoutConstraint* backButtonHeightConstraint = [NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:25.0f];
    
    //backButton高度为父视图宽度25
    NSLayoutConstraint* backButtonWidthConstraint = [NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:25.0f];
    
    
    backButtonLeftConstraint.active = YES;
    backButtonTopConstraint.active = YES;
    backButtonHeightConstraint.active = YES;
    backButtonWidthConstraint.active = YES;

}

- (void)makeBottomToolBarConstraints
{
    //bottomToolBar左侧与父视图左侧对齐
    NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:self.bottomToolBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.bottomToolBar.superview attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
    
    //bottomToolBar右侧与父视图右侧对齐
    NSLayoutConstraint* rightConstraint = [NSLayoutConstraint constraintWithItem:self.bottomToolBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.bottomToolBar.superview attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
    
    //bottomToolBar顶部与父视图顶部对齐
    NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:self.bottomToolBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomToolBar.superview attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    //bottomToolBar高度为父视图高度40
    NSLayoutConstraint* heightConstraint = [NSLayoutConstraint constraintWithItem:self.bottomToolBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:ToolBarHeight];
    
    leftConstraint.active = YES;
    rightConstraint.active = YES;
    topConstraint.active = YES;
    heightConstraint.active = YES;
    
    
    //playButton左侧与父视图左侧对齐
    NSLayoutConstraint* playButtonLeftConstraint = [NSLayoutConstraint constraintWithItem:self.playButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.playButton.superview attribute:NSLayoutAttributeLeading multiplier:1.0f constant:5.0f];
    
    //playButton居父视图Y柱中间
    NSLayoutConstraint* playButtonTopConstraint = [NSLayoutConstraint constraintWithItem:self.playButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.playButton.superview attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    //playButton高度为父视图高度25
    NSLayoutConstraint* playButtonHeightConstraint = [NSLayoutConstraint constraintWithItem:self.playButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:25.0f];
    
    //playButton高度为父视图宽度25
    NSLayoutConstraint* playButtonWidthConstraint = [NSLayoutConstraint constraintWithItem:self.playButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:25.0f];
    
    playButtonLeftConstraint.active = YES;
    playButtonTopConstraint.active = YES;
    playButtonHeightConstraint.active = YES;
    playButtonWidthConstraint.active = YES;
    
    
    //currentTimeLabel左侧与父视图左侧对齐
    NSLayoutConstraint* currentTimeLabelLeftConstraint = [NSLayoutConstraint constraintWithItem:self.currentTimeLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.playButton attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:5.0f];
    
    //currentTimeLabel居父视图Y柱中间
    NSLayoutConstraint* currentTimeLabelTopConstraint = [NSLayoutConstraint constraintWithItem:self.currentTimeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.currentTimeLabel.superview attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    //currentTimeLabel高度为父视图高度25
    NSLayoutConstraint* currentTimeLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:self.currentTimeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:25.0f];
    
    //currentTimeLabel高度为父视图宽度25
    NSLayoutConstraint* currentTimeLabelWidthConstraint = [NSLayoutConstraint constraintWithItem:self.currentTimeLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:35.0f];
    
    currentTimeLabelLeftConstraint.active = YES;
    currentTimeLabelTopConstraint.active = YES;
    currentTimeLabelHeightConstraint.active = YES;    
    currentTimeLabelWidthConstraint.active = YES;

    
    //totalTimeLabel右侧与父视图右侧对齐
    NSLayoutConstraint* totalTimeLabelLeftConstraint = [NSLayoutConstraint constraintWithItem:self.totalTimeLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.totalTimeLabel.superview attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
    
    //totalTimeLabel居父视图Y柱中间
    NSLayoutConstraint* totalTimeLabelTopConstraint = [NSLayoutConstraint constraintWithItem:self.totalTimeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.totalTimeLabel.superview attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    //totalTimeLabel高度为父视图高度25
    NSLayoutConstraint* totalTimeLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:self.totalTimeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:25.0f];
    
    //totalTimeLabel高度为父视图宽度25
   // NSLayoutConstraint* totalTimeLabelWidthConstraint = [NSLayoutConstraint constraintWithItem:self.totalTimeLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:55.0f];
    
    totalTimeLabelLeftConstraint.active = YES;
    totalTimeLabelTopConstraint.active = YES;
    totalTimeLabelHeightConstraint.active = YES;
   // totalTimeLabelWidthConstraint.active = YES;
    
    //progress左侧与父视图左侧对齐
    NSLayoutConstraint* progressLeftConstraint = [NSLayoutConstraint constraintWithItem:self.progress attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.currentTimeLabel attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:2.0f];
    
    //progress右侧与父视图右侧对齐
    NSLayoutConstraint* progressRightConstraint = [NSLayoutConstraint constraintWithItem:self.progress attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.totalTimeLabel attribute:NSLayoutAttributeLeading multiplier:1.0f constant:-2.0f];
    
    //progress顶部与父视图顶部对齐
    NSLayoutConstraint* progressTopConstraint = [NSLayoutConstraint constraintWithItem:self.progress attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.progress.superview attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    //progress高度为父视图高度40
    NSLayoutConstraint* progressHeightConstraint = [NSLayoutConstraint constraintWithItem:self.progress attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:2];
    
    progressLeftConstraint.active = YES;
    progressRightConstraint.active = YES;
    progressTopConstraint.active = YES;
    progressHeightConstraint.active = YES;
    
    //slider左侧与父视图左侧对齐
    NSLayoutConstraint* sliderLeftConstraint = [NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.currentTimeLabel attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:2.0f];
    
    //slider右侧与父视图右侧对齐
    NSLayoutConstraint* sliderRightConstraint = [NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.totalTimeLabel attribute:NSLayoutAttributeLeading multiplier:1.0f constant:-2.0f];
    
    //slider顶部与父视图顶部对齐
    NSLayoutConstraint* sliderTopConstraint = [NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.slider.superview attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    //slider高度为父视图高度40
    NSLayoutConstraint* sliderHeightConstraint = [NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:2];
    
    sliderLeftConstraint.active = YES;
    sliderRightConstraint.active = YES;
    sliderTopConstraint.active = YES;
    sliderHeightConstraint.active = YES;
    
    //fullButton右侧与父视图右侧对齐
    NSLayoutConstraint* fullButtonRightConstraint = [NSLayoutConstraint constraintWithItem:self.fullButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.fullButton.superview attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-5.0f];
    
    //fullButton剧中父视图
    NSLayoutConstraint* fullButtonTopConstraint = [NSLayoutConstraint constraintWithItem:self.fullButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.fullButton.superview attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    //fullButton高度为父视图高度25
    NSLayoutConstraint* fullButtonHeightConstraint = [NSLayoutConstraint constraintWithItem:self.fullButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:25.0f];
    
    //fullButton高度为父视图高度25
    NSLayoutConstraint* fullButtonWidthConstraint = [NSLayoutConstraint constraintWithItem:self.fullButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:25.0f];
    
    fullButtonRightConstraint.active = YES;
    fullButtonTopConstraint.active = YES;
    fullButtonHeightConstraint.active = YES;
    fullButtonWidthConstraint.active = YES;
    
}

- (void)makeConstraints{
    /*
    //顶部工具条
    [self.topToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(ToolBarHeight);
    }];
    //底部工具条
    [self .bottomToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(ToolBarHeight);
    }];
    //转子
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    //返回按钮
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(Padding);
        make.bottom.mas_equalTo(-Padding);
        make.width.equalTo(self.backButton.mas_height);
    }];
    //播放按钮
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(Padding);
        make.bottom.mas_equalTo(-Padding);
        make.width.equalTo(self.backButton.mas_height);
    }];
    //全屏按钮
    [self.fullButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(-Padding);
        make.top.mas_equalTo(Padding);
        make.width.equalTo(self.backButton.mas_height);
    }];
    //当前播放时间
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playButton.mas_right).offset(Padding);
        make.width.mas_equalTo(35);
        make.centerY.equalTo(self.bottomToolBar);
    }];
    //总时间
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fullButton.mas_left).offset(-Padding);
        make.width.mas_equalTo(35);
        make.centerY.equalTo(self.bottomToolBar);
    }];
    //缓冲条
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentTimeLabel.mas_right).offset(Padding);
        make.right.equalTo(self.totalTimeLabel.mas_left).offset(-Padding);
        make.height.mas_equalTo(2);
        make.centerY.equalTo(self.bottomToolBar);
    }];
    //滑杆
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.progress);
    }];
     
     
    //失败按钮
    [self.failButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
     */
    
    //self.bottomToolBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLog(@"----> %s", __func__);
}



#pragma mark - 懒加载
//顶部工具条
- (UIView *) topToolBar{
    if (_topToolBar == nil){
        _topToolBar = [[UIView alloc] init];
        _topToolBar.userInteractionEnabled = YES;
        _topToolBar.translatesAutoresizingMaskIntoConstraints = NO;
        _topToolBar.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _topToolBar;
}
//底部工具条
- (UIView *) bottomToolBar{
    if (_bottomToolBar == nil){
        _bottomToolBar = [[UIView alloc] init];
        _bottomToolBar.userInteractionEnabled = YES;
        _bottomToolBar.translatesAutoresizingMaskIntoConstraints = NO;
        _bottomToolBar.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bottomToolBar;
}
//转子
- (UIActivityIndicatorView *) activity{
    if (_activity == nil){
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activity.translatesAutoresizingMaskIntoConstraints = NO;
        _activity.contentMode = UIViewContentModeScaleAspectFit;
        [_activity startAnimating];
    }
    return _activity;
}
//返回按钮
- (UIButton *) backButton{
    if (_backButton == nil){
        _backButton = [[UIButton alloc] init];
        _backButton.translatesAutoresizingMaskIntoConstraints = NO;
        _backButton.contentMode = UIViewContentModeScaleAspectFit;
        [_backButton setImage:[self getPictureWithName:@"CLBackBtn"] forState:UIControlStateNormal];
        [_backButton setImage:[self getPictureWithName:@"CLBackBtn"] forState:UIControlStateHighlighted];
        [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
//播放按钮
- (UIButton *) playButton{
    if (_playButton == nil){
        _playButton = [[UIButton alloc] init];
        _playButton.translatesAutoresizingMaskIntoConstraints = NO;
        _playButton.contentMode = UIViewContentModeScaleAspectFit;
        [_playButton setImage:[self getPictureWithName:@"CLPlayBtn"] forState:UIControlStateNormal];
        [_playButton setImage:[self getPictureWithName:@"CLPauseBtn"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}
//全屏按钮
- (UIButton *) fullButton{
    if (_fullButton == nil){
        _fullButton = [[UIButton alloc] init];
        _fullButton.translatesAutoresizingMaskIntoConstraints = NO;
        _fullButton.contentMode = UIViewContentModeScaleAspectFit;
        [_fullButton setImage:[self getPictureWithName:@"CLMaxBtn"] forState:UIControlStateNormal];
        [_fullButton setImage:[self getPictureWithName:@"CLMinBtn"] forState:UIControlStateSelected];
        [_fullButton addTarget:self action:@selector(fullButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullButton;
}
//当前播放时间
- (UILabel *) currentTimeLabel{
    if (_currentTimeLabel == nil){
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _currentTimeLabel.contentMode = UIViewContentModeScaleAspectFit;
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font      = [UIFont systemFontOfSize:12];
        _currentTimeLabel.text      = @"00:00";
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}
//总时间
- (UILabel *) totalTimeLabel{
    if (_totalTimeLabel == nil){
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _totalTimeLabel.contentMode = UIViewContentModeScaleAspectFit;
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font      = [UIFont systemFontOfSize:12];
        _totalTimeLabel.text      = @"00:00";
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}
//缓冲条
- (UIProgressView *) progress{
    if (_progress == nil){
        _progress = [[UIProgressView alloc] init];
        _progress.translatesAutoresizingMaskIntoConstraints = NO;
        _progress.contentMode = UIViewContentModeScaleAspectFit;
        _progress.trackTintColor = ProgressColor;
        _progress.progressTintColor = ProgressTintColor;
    }
    return _progress;
}
//滑动条
- (CLSlider *) slider{
    if (_slider == nil){
        _slider = [[CLSlider alloc] init];
        _slider.translatesAutoresizingMaskIntoConstraints = NO;
        _slider.contentMode = UIViewContentModeScaleAspectFit;
        // slider开始滑动事件
        [_slider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [_slider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [_slider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        //左边颜色
        _slider.minimumTrackTintColor = PlayFinishColor;
        //右边颜色
        _slider.maximumTrackTintColor = [UIColor clearColor];
    }
    return _slider;
}
//加载失败按钮
- (UIButton *) failButton
{
    if (_failButton == nil) {
        _failButton = [[UIButton alloc] init];
        _failButton.translatesAutoresizingMaskIntoConstraints = NO;
        _failButton.contentMode = UIViewContentModeScaleAspectFit;
        _failButton.hidden = YES;
        [_failButton setTitle:@"加载失败,点击重试" forState:UIControlStateNormal];
        [_failButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _failButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _failButton.backgroundColor = [UIColor colorWithRed:0.00000f green:0.00000f blue:0.00000f alpha:0.50000f];
        [_failButton addTarget:self action:@selector(failButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _failButton;
}

#pragma mark - 按钮点击事件

//返回按钮
- (void)backButtonAction:(UIButton *)button{
    if (_delegate && [_delegate respondsToSelector:@selector(cl_backButtonAction:)]) {
        [_delegate cl_backButtonAction:button];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}
//播放按钮
- (void)playButtonAction:(UIButton *)button{
    button.selected = !button.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(cl_playButtonAction:)]) {
        [_delegate cl_playButtonAction:button];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}
//全屏按钮
- (void)fullButtonAction:(UIButton *)button{
    button.selected = !button.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(cl_fullButtonAction:)]) {
        [_delegate cl_fullButtonAction:button];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}
//失败按钮
- (void)failButtonAction:(UIButton *)button{
    self.failButton.hidden = YES;
    [self.activity startAnimating];
    if (_delegate && [_delegate respondsToSelector:@selector(cl_failButtonAction:)]) {
        [_delegate cl_failButtonAction:button];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}
#pragma mark - 滑杆
//开始滑动
- (void)progressSliderTouchBegan:(CLSlider *)slider{
    if (_delegate && [_delegate respondsToSelector:@selector(cl_progressSliderTouchBegan:)]) {
        [_delegate cl_progressSliderTouchBegan:slider];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}
//滑动中
- (void)progressSliderValueChanged:(CLSlider *)slider{
    if (_delegate && [_delegate respondsToSelector:@selector(cl_progressSliderValueChanged:)]) {
        [_delegate cl_progressSliderValueChanged:slider];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}
//滑动结束
- (void)progressSliderTouchEnded:(CLSlider *)slider{
    if (_delegate && [_delegate respondsToSelector:@selector(cl_progressSliderTouchEnded:)]) {
        [_delegate cl_progressSliderTouchEnded:slider];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}
#pragma mark - 获取资源图片
- (UIImage *)getPictureWithName:(NSString *)name{
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"CLPlayer" ofType:@"bundle"]];
    NSString *path   = [bundle pathForResource:name ofType:@"png"];
    //NSLog(@"-->%s path: %@", __func__, path);
    return [UIImage imageWithContentsOfFile:path];
}


@end
