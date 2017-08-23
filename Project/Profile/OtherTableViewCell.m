//
//  OtherTableViewCell.m
//  riyusuxue
//
//  Created by kun on 2017/5/15.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "OtherTableViewCell.h"

@implementation OtherTableViewCell

- (void)awakeFromNib {
    NSLog(@"%s", __func__);
    
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // NSLog(@"%s", __func__);
    
    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    // NSLog(@"%s", __func__);
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    NSLog(@"--->%s", __func__);
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _iconImageView = [UIImageView new];
    _iconImageView.frame = CGRectMake(20, 5, 60, 60);
    _iconImageView.layer.cornerRadius = 5;
    _iconImageView.clipsToBounds = YES;
    _iconImageView.image = [UIImage imageNamed:@"shuxuebx2.jpg"];
    _nameLabel = [UILabel new];
    _nameLabel.frame = CGRectMake(90, 5, self.bounds.size.width, self.bounds.size.height);
    _nameLabel.font = [UIFont systemFontOfSize:16];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.numberOfLines = 0;
    _nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_nameLabel];
    
}


+ (CGFloat)fixedHeight
{
    return 70;
}

@end
