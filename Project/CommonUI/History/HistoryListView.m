//
//  HistoryListView.m
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/9/11.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "HistoryListView.h"
#import "HistoryManager.h"

@interface HistoryListView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *listArray;

@end

@implementation HistoryListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)setHistoryList:(NSArray *)historyList {
    if (historyList.count == 0) {
        return;
    }
    _historyList = historyList;
    _listArray = [NSMutableArray new];
    
    // 按存入的顺序反序显示
    NSArray *sortArray = [[historyList reverseObjectEnumerator] allObjects];
    for (int i = 0; i < [sortArray count]; i++) {
        ContentModel *contentModel = [sortArray objectAtIndex:i];
        HistoryListCollectionViewCellModel *cellModel = [HistoryListCollectionViewCellModel new];
        cellModel.contentModel = contentModel;
        [self.listArray addObject:cellModel];
    }
    [self.collectionView reloadData];
}


#pragma mark - collectionViewDelegate and collectionViewDatasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HistoryListCollectionViewCell *cell = (HistoryListCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kHistoryListCollectionViewCellIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.listArray.count) {
        HistoryListCollectionViewCellModel *cellModel = [self.listArray objectAtIndex:indexPath.row];
        cell.cellModel = cellModel;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HistoryListCollectionViewCellModel *cellModel = [self.listArray objectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedHistory:)]) {
        [self.delegate selectedHistory:cellModel.contentModel];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kHistoryListItemWidth, kHistoryListItemHeight);
}


#pragma mark - Factory method
- (UICollectionViewFlowLayout *)layout {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = kHistoryListItemMargin;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = (CGSize){kHistoryListItemWidth, kHistoryListItemHeight};
    // layout.sectionInset = (UIEdgeInsets){0, 0, 0, 0};
    return layout;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kHistoryListCollectionViewWidth, kHistoryListItemHeight) collectionViewLayout:[self layout]];
        _collectionView.backgroundView = nil;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setContentInset:UIEdgeInsetsMake(0, kHistoryListItemMargin, 0, 0)];
        [_collectionView registerClass:[HistoryListCollectionViewCell class] forCellWithReuseIdentifier:kHistoryListCollectionViewCellIdentifier];
    }
    return _collectionView;
}

@end


