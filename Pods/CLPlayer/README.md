# 使用AVPlayer自定义支持全屏的播放器

#功能
    本视频播放器主要自定义了带缓冲显示的进度条，可以拖动调节视频播放进度的播放条，具有当前播放时间和总时间的Label，全屏播放功能，定时消失的工具条，视频卡顿监听，视频加载失败处理。支持旋转屏幕自动全屏，可以添加到UItableView上。使用Masonry布局，工具条单独封装出来，方便大家修改。
#接口与用法
+ 接口

```
/**视频url*/
@property (nonatomic,strong) NSURL *url;
/**旋转自动全屏，默认Yes*/
@property (nonatomic,assign) BOOL autoFullScreen;
/**重复播放，默认No*/
@property (nonatomic,assign) BOOL repeatPlay;
/**是否支持横屏，默认No*/
@property (nonatomic,assign) BOOL isLandscape;
/**拉伸方式，默认全屏填充*/
@property (nonatomic,assign) VideoFillMode fillMode;

/**播放*/
- (void)playVideo;
/**暂停*/
- (void)pausePlay;
/**返回按钮回调方法*/
- (void)backButton:(BackButtonBlock) backButton;
/**播放完成回调*/
- (void)endPlay:(EndBolck) end;
/**销毁播放器*/
- (void)destroyPlayer;
/**
 根据播放器所在位置计算是否滑出屏幕
 @param tableView Cell所在tableView
 @param cell 播放器所在Cell
 */
- (void)calculateScrollOffset:(UITableView *)tableView cell:(UITableViewCell *)cell;

```

+ 使用方法

      直接使用cocoapods导入，`pod 'CLPlayer'`

+ TableView使用方法

```
#pragma mark - 点击播放代理
- (void)PlayVideoWithCell:(TableViewCell *)cell;
{
//记录被点击的cell
    _cell = cell;
    
    //销毁播放器
    [_playerView destroyPlayer];
    _playerView = nil;
    
    _playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, 0, cell.width, cell.height)];
    [cell.contentView addSubview:_playerView];
    
    //根据旋转自动支持全屏，默认支持
    //    playerView.autoFullScreen = NO;
    //重复播放，默认不播放
    //    playerView.repeatPlay     = YES;
    //如果播放器所在页面支持横屏，需要设置为Yes，不支持不需要设置(默认不支持)
    //    playerView.isLandscape    = YES;
    
    //视频地址
    _playerView.url = [NSURL URLWithString:cell.model.videoUrl];
    
    //播放
    [_playerView playVideo];
    
    //返回按钮点击事件回调
    [_playerView backButton:^(UIButton *button) {
        NSLog(@"返回按钮被点击");
    }];
    
    //播放完成回调
    [_playerView endPlay:^{
        
        //销毁播放器
        [_playerView destroyPlayer];
        _playerView = nil;
        NSLog(@"播放完成");
    }];
 
}

```
    在`tableView`滑动代理中，需要使用`- (void)calculateScrollOffset:(UITableView *)tableView cell:(UITableViewCell *)cell`方法，将`tableView`和播放器所在`cell`传递给播放器，播放器会在内部计算播放器所在位置，在超出屏幕的时候，会对播放器销毁。

```
#pragma mark - 滑动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //计算偏移来销毁播放器
    [_playerView calculateScrollOffset:self.tableView cell:_cell];
}
```
#播放器效果图

![](https://github.com/JmoVxia/CLPlayer/blob/master/%E6%95%88%E6%9E%9C%E5%9B%BE1.gif)
![](https://github.com/JmoVxia/CLPlayer/blob/master/%E6%95%88%E6%9E%9C%E5%9B%BE2.gif)
![](https://github.com/JmoVxia/CLPlayer/blob/master/%E6%95%88%E6%9E%9C%E5%9B%BE3.gif)




#详细请看简书

http://www.jianshu.com/p/11e05d684c05
