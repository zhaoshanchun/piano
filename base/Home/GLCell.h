//
//  GLCell.h
//  iOSCoverFlow
//
//  Created by 吕建发 on 16/5/25.
//  Copyright © 2016年 cn.geek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbName;

- (void)setIndexPath:(NSIndexPath *)idxPath withCount:(int)count;
@end
