//
//  VideoDetailHistoryCell.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/11.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "VideoDetailHistoryCell.h"

@implementation VideoDetailHistoryCell

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

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)addContent {
    [self.contentView addSubview:self.historyView];
}


#pragma mark - Factory method
- (HistoryListView *)historyView {
    if (_historyView == nil) {
        _historyView = [[HistoryListView alloc] initWithFrame:CGRectMake(0, 0, kHistoryListCollectionViewWidth, kHistoryListItemImageHeight)];
        [_historyView showBorder:[UIColor greenColor]];
    }
    return _historyView;
}

@end
