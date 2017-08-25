//
//  AdCollectionViewCell.m
//  sifakaoshi
//
//  Created by kun on 2017/6/27.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "AdCollectionViewCell.h"
#import "CollectionViewCell.h"
#import "GlobalValue.h"
#import "AsyncImage.h"
#import "PlayerViewController.h"
#import "AppDelegate.h"

#define MAX_ROW 6
#define MAX_Sections 100

#define AdCollectionViewCellClass     @"AdCollectionViewCellClass"


@interface AdCollectionViewCell()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) UICollectionView *collectionView;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic , strong) UIPageControl *pageControl;

@end

@implementation AdCollectionViewCell

-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupView];
    }
    
    return self;
}

- (void)setupView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0.0;
    layout.minimumInteritemSpacing = 0.0;
    layout.sectionInset = (UIEdgeInsets){0,0,0,0};
    CGSize size = self.bounds.size;
    layout.itemSize = CGSizeMake(size.width, size.height);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];

    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _collectionView.alwaysBounceVertical = YES;
    
    _collectionView.showsVerticalScrollIndicator = FALSE;
    _collectionView.showsHorizontalScrollIndicator = FALSE;
    _collectionView.pagingEnabled = YES;
    
    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self addSubview:_collectionView];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:AdCollectionViewCellClass];
    
    
    //4.设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;

    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.width/2);
    pageControl.bounds = CGRectMake(0, 0, 150, 40);
    pageControl.pageIndicatorTintColor = [UIColor blueColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.enabled = NO;
    pageControl.numberOfPages = MAX_ROW;
    
    [self addSubview:pageControl];
    
    _pageControl=pageControl;
    
    [self addTimer];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return MAX_Sections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MAX_ROW;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:AdCollectionViewCellClass forIndexPath:indexPath];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    GlobalValue *globalValue = appDelegate.globalValue;
    
    cell.itemIndex = [self getRandomNumber:1 to:[globalValue VideoObjectsCount] -1 ];
    cell.playImageView.hidden = NO;

    VideoObject *object = [globalValue getVideoObjectWithIndex:cell.itemIndex];
    
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
        [self.delegate onClick:object];
    
}

#pragma mark 添加定时器
-(void) addTimer{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextpage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer ;
    
}

#pragma mark 删除定时器
-(void) removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

-(void) nextpage{
    
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:MAX_Sections/2];
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    NSInteger nextItem = currentIndexPathReset.item +1;
    NSInteger nextSection = currentIndexPathReset.section;
    
    if (nextItem==MAX_ROW) {
        nextItem=0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark - didScorll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //NSLog(@"--->%s", __func__);
    
    // 坐标系转换获得collectionView上面的位于中心的cell
    CGPoint pointInView = [self convertPoint:self.collectionView.center toView:self.collectionView];
    // 获取这一点的indexPath
    NSIndexPath *indexPathNow = [self.collectionView indexPathForItemAtPoint:pointInView];
    //NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    
    CollectionViewCell *cell = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPathNow];
    //NSLog(@"scrollViewDidScroll--->w: %f, h: %f", scrollView.bounds.size.width, scrollView.bounds.size.width);
    
    int page = (int) (scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%MAX_ROW;
    self.pageControl.currentPage =page;
    [self.collectionView bringSubviewToFront:cell];
    
    
    
    
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}

#pragma mark 当用户停止的时候调用
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
    
}

@end
