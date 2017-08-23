//
//  HistoryView.m
//  sifakaoshi
//
//  Created by kun on 2017/6/28.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "HistoryView.h"
#import "CollectionViewCell.h"
#import "AppDelegate.h"
#import "AsyncImage.h"

#define HistoryViewCellClass     @"HistoryViewCellClass"


@interface HistoryView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSArray *historyArray;
}

@property (nonatomic, copy) UICollectionView *collectionView;
@end


@implementation HistoryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initDate];
        [self setupView];

    }
    return self;
}

-(void)initDate{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    GlobalValue *globalValue = appDelegate.globalValue;
    
    //1.原始数组
    NSMutableArray *array = [globalValue historyView];
    //2.倒序的数组
    historyArray = [[array reverseObjectEnumerator] allObjects];
    
}
-(void)setupView{
    NSLog(@"bounds: %f, %f", self.bounds.size.width, self.bounds.size.height);
    UILabel *label = [UILabel new];
    [label setFont:[UIFont systemFontOfSize:18]];
    label.textColor = [UIColor blackColor];
    label.text = @"历史观看";
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:label];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:20]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:18]];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 2.0;
    layout.minimumInteritemSpacing = 0.0;
    layout.sectionInset = (UIEdgeInsets){0,2,0,2};
        
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _collectionView.alwaysBounceHorizontal = YES;
    //_collectionView.scrollsToTop = NO;
    _collectionView.showsVerticalScrollIndicator = FALSE;
    _collectionView.showsHorizontalScrollIndicator = FALSE;
    _collectionView.pagingEnabled = YES;
    //4.设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;

    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self addSubview:_collectionView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:HistoryViewCellClass];
    
    
}

-(void)historyReload{
    [self initDate];
    if(_collectionView)
        [_collectionView reloadData];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [historyArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:HistoryViewCellClass forIndexPath:indexPath];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    GlobalValue *globalValue = appDelegate.globalValue;
    long row = [indexPath row];

    NSString *uid = historyArray[row];
    VideoObject *object = [globalValue getVideoObject:uid];
    cell.itemIndex = object.index;

    cell.iconImageView.image = [UIImage imageNamed:object.icon];
    cell.nameLabel.text = object.title;
    if(![object.time isEqualToString:@""])
    {
        NSString *t = @"时长:";
        t = [t stringByAppendingString:object.time];
        cell.playTime.text = t;
    }
    else{
        cell.playTime.text = @"";
    }
    
    AsyncImage *asyncImage = [AsyncImage new];
    [asyncImage LoadImage2:cell Object:object];
    
    return cell;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    GlobalValue *globalValue = appDelegate.globalValue;
    
    VideoObject *object = [globalValue getVideoObjectWithIndex:cell.itemIndex];
    
    //[self.navigationController pushViewController:[PlayerViewController playerViewControllerWithVideoPath:object.videoPath Title:object.title Index:object.uid Ccode:object.code] animated:YES];
    if(self.delegate)
        [self.delegate onClickHistoryView:object];
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    float w = self.bounds.size.width;
    w = w/3;
    float h = w*0.65;
    return CGSizeMake(w, h);
}

@end
