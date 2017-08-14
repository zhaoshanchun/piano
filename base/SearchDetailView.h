//
//  SearchDetailView.h
//  SearchControllerDemo
//
//  Created by admin on 16/8/30.
//  Copyright © 2016年 thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchDetailView;
@protocol SearchDetailViewDelegate <NSObject>

- (void)dismissButtonWasPressedForSearchDetailView:(SearchDetailView *)searchView;
- (void)searchButtonWasPressedForSearchDetailView:(SearchDetailView *)searchView;
- (void)textFieldEditingChangedForSearchDetailView:(SearchDetailView *)searchView;

@end

@interface SearchDetailView : UIView

@property (weak) id<SearchDetailViewDelegate> delegate;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIButton *cancleButton;

@end
