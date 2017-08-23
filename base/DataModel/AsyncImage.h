//
//  ImageLoad.h
//  huazhuangjiaocheng
//
//  Created by kun on 2017/6/9.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "BaseTableViewCell.h"
#import "CollectionViewCell.h"
#import "GlobalValue.h"

@protocol LoadImageDelegate <NSObject>

-(void)LoadImageResult:(BaseTableViewCell *)cell Cell2:(CollectionViewCell *)cell2;

@end

@interface AsyncImage : NSObject

@property (nonatomic, weak) id<LoadImageDelegate> delegate;

-(void)LoadImage:(BaseTableViewCell *)cell Object:(VideoObject *)obj;
-(void)LoadImage2:(CollectionViewCell *)cell Object:(VideoObject *)obj;

@end


