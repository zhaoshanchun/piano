//
//  VideoDetailViewController.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/30.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "BaseViewController.h"
#import "ContentListModel.h"

@protocol VideoDetailViewControllerDelegate <NSObject>

- (void)playContent:(ContentModel *)contentModel;

@end

@interface VideoDetailViewController : BaseViewController

@property (weak, nonatomic) id<VideoDetailViewControllerDelegate> delegate;
@property (strong, nonatomic) NSArray *allContentsArray;

- (instancetype)initWithContentModel:(ContentModel *)contentModel NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithSourceModel:(SourceModel *)sourceModel NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end
