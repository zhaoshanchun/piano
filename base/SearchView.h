//
//  SearchView.h
//  SearchControllerDemo
//
//  Created by admin on 16/8/30.
//  Copyright © 2016年 thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchView;
@protocol SearchViewDelegate <NSObject>

- (void)searchButtonWasPressedForSearchView:(SearchView *)searchView;

@end

@interface SearchView : UIView

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) id<SearchViewDelegate> delegate;
@property (strong, nonatomic) UIButton *searchButton;

@end
