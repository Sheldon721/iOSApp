//
//  PlayerCell.m
//  LCZPlayerDemo
//
//  Created by 李晓东 on 2017/11/8.
//  Copyright © 2017年 李晓东. All rights reserved.
//

#import "PlayerCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
@interface PlayerCell ()<UIGestureRecognizerDelegate>
{
    UIWindow *_window;
}
@end

@implementation PlayerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}
#pragma mark - 根据状态控制菊花显示隐藏
- (void)setPlayerState:(LCZPlayerState)playerState{
    _playerState = playerState;
    // 控制菊花显示、隐藏
    if (playerState == LCZPlayerStateBuffering) {
        [self.loadingView startAnimating];
    }else if(playerState == LCZPlayerStatePlaying){
        //隐藏
        [self.loadingView stopAnimating];
    }else if (playerState == LCZPlayerStatePause){
        //隐藏
        [self.loadingView stopAnimating];
    }
    else{
        //隐藏
        [self.loadingView stopAnimating];
    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor blackColor];
        //创建底部功具视图
        [self createBottomToolView];
        //创建播放器
        [self createAVPlayer];
        //创建播放器尾部视图
        [self createFooterView];
        //创建占位图
        [self createPlaceholderFigure];
        //创建播放器头部视图
        [self createHeaderView];
        
    }
    return  self;
}
#pragma mark - 模型赋值
- (void)setModel:(ShiPingModel *)model{
    //播放地址
    self.playerLayer.player = [AVPlayer playerWithURL:[NSURL URLWithString:model.mp4_url]];
    //添加监控
    [self addObserverWithPlayItem:self.playerLayer.player.currentItem];
    //标题
    self.headerLabel.text = model.title;
    //占位图
    [self.placeholderImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    //头像
    [self.avatarsImageView sd_setImageWithURL:[NSURL URLWithString:model.topicImg]];
    //名称
    [self.userName setText:model.topicName];
}
#pragma mark - 创建占位图
- (void)createPlaceholderFigure{
    //占位图
    self.placeholderImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.placeholderImageView];
    self.placeholderImageView.userInteractionEnabled = YES;
    self.placeholderImageView.backgroundColor = [UIColor blackColor];
    //占位图上的播放按钮
    self.placeholderPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.placeholderImageView addSubview:self.placeholderPlayButton];
    [self.placeholderPlayButton setImage:[UIImage imageNamed:@"ZFPlayer_play_btn"] forState:UIControlStateNormal];
    [self.placeholderPlayButton addTarget:self action:@selector(startPlayingVideo:) forControlEvents:UIControlEventTouchUpInside];
    //约束
    [self.placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.contentView);
        make.bottom.equalTo(self.bottomToolView.mas_top);
    }];
    [self.placeholderPlayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.placeholderImageView);
        make.centerY.equalTo(self.placeholderImageView);
        make.height.width.equalTo(@80);
    }];
}
#pragma mark - 占位图上的按钮时调用
-(void)startPlayingVideo:(UIButton *)sender{
    if (self.playerState == LCZPlayerStateFailed) {
        
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    //还原正在播放的cell
    for (PlayerCell *cell in self.cellMutableArray) {
        if (cell.playerState == LCZPlayerStatePlaying) {
            //移除隐藏头尾控件的计时器
            [cell.dismissTimer invalidate];
            cell.dismissTimer = nil;
            //显示遮盖层
            cell.placeholderImageView.hidden = NO;
            cell.headerImageView.hidden = NO;
            //暂停播放
            [cell pause];
            //还原播放进度
            [cell.playerLayer.player seekToTime:kCMTimeZero];
            
        }
        
    }
    //播放视频
    [self play];
    //隐藏占位图
    self.placeholderImageView.hidden = YES;
    
}
#pragma mark -创建播放器
- (void)createAVPlayer{
    //播放器视图
    self.playerView = [[UIView alloc]init];
    self.playerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 225);
    [self.contentView addSubview:self.playerView];
    //播放层
    self.playerLayer = [[AVPlayerLayer alloc]init];
    self.playerLayer.frame = self.playerView.frame;
    // 等比例填充，直到一个维度到达区域边界
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.playerView.layer addSublayer:self.playerLayer];
    //添加通知
    [self addNotificatonForPlayer];
    //小菊花
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.playerView addSubview:self.loadingView];
    //给播放器视图添加单击手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [self.playerView addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;
    //给播放器视图添加拖拽手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(adjustVolume:)];
    [self.playerView addGestureRecognizer:panGestureRecognizer];
    panGestureRecognizer.delegate = self;
    
    //约束
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.playerView);
    }];
    //获取系统音量控件
    [self mpVolumeView];
}
#pragma mark - 单击手势 隐藏 显示 头尾部控件
- (void)tapGestureRecognizer:(UITapGestureRecognizer *)tap{
    if (self.headerImageView.hidden== YES && self.footerImageView.hidden == YES ) {
        //显示
        [self showHeaderViewAndBottomView];
        //5秒后隐藏 头尾视图
        [self dismissTimerView];
    }
    else{
        //销毁计时器
        [self.dismissTimer invalidate];
        self.dismissTimer = nil;
        //隐藏
        [self hideHeaderViewAndBottomView];
    }
}

#pragma mark - 拖拽手势  调节播放进度。音量。亮度
- (void)adjustVolume:(UIPanGestureRecognizer *)recognizer{
    
    //获取当前坐标点
    CGPoint currentCoordinatePoint = [recognizer locationInView:self];
    //获取手指移动后，在相对坐标中的偏移量
    CGPoint offset = [recognizer translationInView:self];
    //获取手势在指定视图坐标系统的移动速度 用于判断方向
    CGPoint velocity = [recognizer velocityInView:self];
    //定义方向的枚举
    typedef NS_ENUM(NSUInteger, UIPanGestureRecognizerDirection) {
        UIPanGestureRecognizerDirectionUndefined,
        UIPanGestureRecognizerDirectionUp,
        UIPanGestureRecognizerDirectionDown,
        UIPanGestureRecognizerDirectionLeft,
        UIPanGestureRecognizerDirectionRight
    };
    //默认值
    static UIPanGestureRecognizerDirection direction = UIPanGestureRecognizerDirectionUndefined;
    NSLog(@"%lf-%lf",fabs(velocity.y),fabs(velocity.x));
    //判断是在y轴还是x轴移动  fabs( )主要是求精度要求更高的double
    if (fabs(velocity.y / velocity.x) >5.0) {
        if (velocity.y>0) {
            //下
            direction = UIPanGestureRecognizerDirectionDown;
        }
        else{
            //上
            direction = UIPanGestureRecognizerDirectionUp;
        }
    }else if (fabs(velocity.x / velocity.y) >5.0) {
        //判断拖拽方向
        if (velocity.x>0) {
            //右
            direction = UIPanGestureRecognizerDirectionRight;
        }
        else{
            //左
            direction = UIPanGestureRecognizerDirectionLeft;
        }
    }
    
    
    
    
    //判断在哪个方向
    switch (direction) {
        case UIPanGestureRecognizerDirectionUp://上
            //判断手势在屏幕的位置
            if (currentCoordinatePoint.x < self.frame.size.width / 2) {//在左边
                //系统亮度为1，跳出
                if ([UIScreen mainScreen].brightness == 1) {
                    return;
                }
                // 增加系统屏幕亮度
                [UIScreen mainScreen].brightness += 0.01;
                
                
            }
            else{//在右边
                //系统音量为1。跳出
                if (self.volumeViewSlider.value == 1) {
                    return;
                }
                //增加音量
                self.volumeViewSlider.value += 0.01;
                
                
            }
            break;
        case UIPanGestureRecognizerDirectionDown:
            //判断手势在屏幕的位置
            if (currentCoordinatePoint.x < self.frame.size.width / 2) {//在左边
                //系统亮度为0，跳出
                if ([UIScreen mainScreen].brightness == 0) {
                    return;
                }
                // 减少系统屏幕亮度
                [UIScreen mainScreen].brightness -= 0.01;
            }
            else{//在右边
                //系统音量为0。跳出
                if (self.volumeViewSlider.value == 0) {
                    return;
                }
                //减小音量
                self.volumeViewSlider.value -= 0.01;
                
                
            }
            break;
        case UIPanGestureRecognizerDirectionLeft:
            //快退
            if (fabs(offset.y)  < 1 && fabs(offset.y) < fabs(offset.x) ) {
                //跳转到指定时间
                [self.playerLayer.player seekToTime:CMTimeMake(self.slider.value * [self duration] -10, 1.0) completionHandler:^(BOOL finished) {
                    
                }];
            }
            
            break;
        case UIPanGestureRecognizerDirectionRight:
            //快进
            if (fabs(offset.y)  < 1 && fabs(offset.y) < fabs(offset.x)) {
                //跳转到指定时间
                [self.playerLayer.player seekToTime:CMTimeMake(self.slider.value * [self duration] +10, 1.0) completionHandler:^(BOOL finished) {
                    
                }];
            }
            break;
            
        default:
            break;
    }
    
    
    
}

#pragma mark - 获取系统音量
- (void)mpVolumeView{
    self.volumeViewSlider = nil;
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(10, 50, 200, 4)];
    
    for (UIView* newView in volumeView.subviews) {
        if ([newView.class.description isEqualToString:@"MPVolumeSlider"]){
            self.volumeViewSlider = (UISlider*)newView;
            break;
        }
    }
}

#pragma mark - 播放视频
- (void)play{
    //播放
    [self.playerLayer.player play];
    //设置播放按钮状态
    self.playOrPauseBtn.selected = NO;
    //开启计时器,播放5秒后隐藏头、尾视图
    [self dismissTimerView];
    //设置播放状态
    self.playerState = LCZPlayerStatePlaying;
}
#pragma mark - 暂停视频
- (void)pause{
    //暂停
    [self.playerLayer.player pause];
    //设置播放按钮状态
    self.playOrPauseBtn.selected = YES;
    //设置播放器状态
    self.playerState = LCZPlayerStatePause;
}
#pragma mark - 添加进度 监控
/** 给player 添加 time observer */
- (void)addPlayerObserver
{
    __weak typeof(self)weakSelf = self;
    //监听播放进度
    
    self.playTimeObserver = [self.playerLayer.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        AVPlayerItem *playerItem = weakSelf.playerLayer.player.currentItem;
        //当前播放进度
        float current = CMTimeGetSeconds(time);
        //总时长
        float total = CMTimeGetSeconds([playerItem duration]);
        if (weakSelf.sliderState == NO) {
            //设置UI
            weakSelf.totalPlayingTime.text = [weakSelf convertTime:total];
            weakSelf.currentPlaybackTime.text = [weakSelf convertTime:current];
            weakSelf.slider.value = current / total;
        }
    }];
}

/** 给当前播放的item 添加观察者
 需要监听的字段和状态
 status :  AVPlayerItemStatusUnknown,AVPlayerItemStatusReadyToPlay,AVPlayerItemStatusFailed
 loadedTimeRanges  :  缓冲进度
 playbackBufferEmpty : seekToTime后，缓冲数据为空，而且有效时间内数据无法补充，播放失败
 playbackLikelyToKeepUp : seekToTime后,可以正常播放，相当于readyToPlay，一般拖动滑竿菊花转，到了这个这个状态菊花隐藏
 
 */
- (void)addObserverWithPlayItem:(AVPlayerItem *)item
{
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
}

/** 移除 item 的 observer */
- (void)removeObserverWithPlayItem:(AVPlayerItem *)item
{
    [item removeObserver:self forKeyPath:@"status"];
    [item removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [item removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [item removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
}

/** 数据处理 获取到观察到的数据 并进行处理 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    AVPlayerItem *item = object;
    if ([keyPath isEqualToString:@"status"]) {
        // 获取播放状态
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status) {
            case AVPlayerStatusUnknown://缓冲中
            {
                [self.loadingProgress setProgress:0.0 animated:NO];
                //设置播放状态
                self.playerState = LCZPlayerStateBuffering;
            }
                break;
            case AVPlayerStatusReadyToPlay://播放中
            {
                //设置播放状态
                self.playerState = LCZPlayerStatePlaying;
                //添加定时器监控
                [self addPlayerObserver];
                
            }
                break;
            case AVPlayerStatusFailed://播放失败
            {
                self.playerState = LCZPlayerStateFailed;
            }
                break;
            default:
                break;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        // 缓冲进度
        [self handleLoadedTimeRangesWithPlayerItem:item];
        
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        // 当缓冲是空的时候
        if (self.playerLayer.player.currentItem.playbackBufferEmpty) {
            self.playerState = LCZPlayerStateBuffering;
            
        }
        
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        // 当缓冲好的时候
        if (self.playerLayer.player.currentItem.playbackLikelyToKeepUp && self.playerState == LCZPlayerStateBuffering){
            self.playerState = LCZPlayerStatePlaying;
        }
        
        
        
        
    }
}
#pragma mark - 处理缓冲进度
/** 处理缓冲进度 */
- (void)handleLoadedTimeRangesWithPlayerItem:(AVPlayerItem *)item
{
    NSArray *loadArray = item.loadedTimeRanges;
    
    CMTimeRange range = [[loadArray firstObject] CMTimeRangeValue];
    
    float start = CMTimeGetSeconds(range.start);
    
    float duration = CMTimeGetSeconds(range.duration);
    
    NSTimeInterval totalTime = start + duration;// 缓存总长度
    //缓存总长度 ／ 视频总时长 = 当前进度长度
    self.loadingProgress.progress = totalTime / [self duration];
    
}

#pragma mark - 添加通知
/**
 添加关键通知
 
 AVPlayerItemDidPlayToEndTimeNotification     视频播放结束通知
 AVPlayerItemTimeJumpedNotification           视频进行跳转通知
 AVPlayerItemPlaybackStalledNotification      视频异常中断通知
 UIApplicationDidEnterBackgroundNotification  进入后台
 UIApplicationDidBecomeActiveNotification     返回前台
 
 */
- (void)addNotificatonForPlayer
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(videoPlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [center addObserver:self selector:@selector(videoPlayError:) name:AVPlayerItemPlaybackStalledNotification object:nil];
    [center addObserver:self selector:@selector(videoPlayEnterBack:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [center addObserver:self selector:@selector(videoPlayBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

#pragma mark - 移除 通知
/** 移除 通知 */
- (void)removeNotification
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [center removeObserver:self name:AVPlayerItemPlaybackStalledNotification object:nil];
    [center removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [center removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [center removeObserver:self];
}

#pragma mark - 视频播放结束
/** 视频播放结束 */
- (void)videoPlayEnd:(NSNotification *)notic
{
    NSLog(@"视频播放结束");
    //移除隐藏头尾控件的计时器
    [self.dismissTimer invalidate];
    self.dismissTimer = nil;
    
    //还原播放进度
    [self.playerLayer.player seekToTime:kCMTimeZero];
    //显示占位图
    self.placeholderImageView.hidden = NO;
    self.headerImageView.hidden = NO;
    
}
#pragma mark - 视频异常中断
/** 视频异常中断 */
- (void)videoPlayError:(NSNotification *)notic
{
    NSLog(@"视频异常中断");
}
#pragma mark - 进入后台
/** 进入后台 */
- (void)videoPlayEnterBack:(NSNotification *)notic
{
    
    [self pause];
    if (self.fullScreenBtn.selected == YES) {
        //缩小视频
        [self reduceTheVideo];
    }
    NSLog(@"进入后台");
    
}
#pragma mark - 返回前台
/** 返回前台 */
- (void)videoPlayBecomeActive:(NSNotification *)notic
{
    NSLog(@"返回前台");
    [self play];
    
    
}



#pragma mark - 获取总视频时长
- (double)duration{
    AVPlayerItem *playerItem = self.playerLayer.player.currentItem;
    if (playerItem.status == AVPlayerItemStatusReadyToPlay){
        return CMTimeGetSeconds([[playerItem asset] duration]);
    }
    else{
        return 0.0;
    }
}
#pragma mark - 获取视频当前播放的时长
- (double)currentTime{
    if (self.playerLayer.player) {
        return CMTimeGetSeconds([self.playerLayer.player currentTime]);
    }else{
        return 0.0;
    }
}





#pragma mark - 播放器头部控件
- (void)createHeaderView{
    //背景视图
    self.headerImageView = [[UIImageView alloc]init];
    self.headerImageView.userInteractionEnabled = YES;
    [self.headerImageView setImage:[UIImage imageNamed:@"top_shadow"]];
    //返回按钮
    self.headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.headerImageView addSubview:self.headerBtn];
    [self.headerBtn setImage:[UIImage imageNamed:@"backLife"] forState:UIControlStateNormal];
    [self.headerBtn addTarget:self action:@selector(restorenitialUI:) forControlEvents:UIControlEventTouchUpInside];
    //标题
    self.headerLabel = [[UILabel alloc]init];
    [self.headerImageView addSubview:self.headerLabel];
    [self.headerLabel setFont:[UIFont systemFontOfSize:18]];
    self.headerLabel.numberOfLines = 0;
    [self.headerLabel setTextColor:[UIColor whiteColor]];
    
    [self.contentView addSubview:self.headerImageView];
    //设置UI约束Frame
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playerView);
        make.left.equalTo(self.playerView);
        make.right.equalTo(self.playerView);
        make.height.equalTo(@60);
    }];
    [self.headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView);
        make.left.equalTo(self.headerImageView);
        make.width.height.equalTo(@40);
    }];
    [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerBtn.mas_top).offset(8);
        make.left.equalTo(self.headerBtn.mas_right);
        make.right.equalTo(self.headerImageView).offset(-5);
    }];
    
    
}
#pragma mark - 点击返回按钮时调用
- (void)restorenitialUI:(UIButton *)sender{
    [self pause];
    //还原播放进度
    [self.playerLayer.player seekToTime:kCMTimeZero];
    //显示占位图
    self.placeholderImageView.hidden = NO;
    //移除隐藏头尾控件的计时器
    [self.dismissTimer invalidate];
    self.dismissTimer = nil;
}
#pragma mark - 尾部控件
- (void)createFooterView{
    //尾部背景视图
    self.footerImageView = [[UIImageView alloc]init];
    
    [self.footerImageView setUserInteractionEnabled:YES];
    [self.footerImageView setImage:[UIImage imageNamed:@"bottom_shadow"]];
    //播放\暂停按钮
    self.playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.footerImageView addSubview:self.playOrPauseBtn];
    [self.playOrPauseBtn setImage:[UIImage imageNamed:@"video_pause"] forState:UIControlStateNormal];
    [self.playOrPauseBtn setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateSelected];
    self.playOrPauseBtn.selected = YES;
    //添加点击事件
    [self.playOrPauseBtn addTarget:self action:@selector(playOrPauseTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    //当前播放时间
    self.currentPlaybackTime = [[UILabel alloc]init];
    [self.footerImageView addSubview:self.currentPlaybackTime];
    [self.currentPlaybackTime setText:@"00:00"];
    [self.currentPlaybackTime setTextColor:[UIColor whiteColor]];
    [self.currentPlaybackTime setFont:[UIFont systemFontOfSize:14]];
    [self.currentPlaybackTime setTextAlignment:NSTextAlignmentCenter];
    //缓存进度条
    self.loadingProgress = [[UIProgressView alloc]init];
    [self.footerImageView addSubview:self.loadingProgress];
    //设置进度条颜色
    self.loadingProgress.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    self.loadingProgress.trackTintColor = [UIColor clearColor];
    [self.loadingProgress setProgress:0.0 animated:NO];
    //滑动条
    self.slider = [[UISlider alloc]init];
    [self.footerImageView addSubview:self.slider];
    self.slider.minimumValue = 0.0;
    self.slider.maximumValue = 1.0;
    //设置滑动条图片
    [self.slider setThumbImage:[UIImage imageNamed:@"dot"]  forState:UIControlStateNormal];
    self.slider.minimumTrackTintColor = [UIColor greenColor];
    self.slider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    self.slider.continuous = YES;
    //指定初始值
    self.slider.value = 0.0;
    [self.slider addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.slider addTarget:self action:@selector(sliderTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    //总播放时长
    self.totalPlayingTime = [[UILabel alloc]init];
    [self.footerImageView addSubview:self.totalPlayingTime];
    [self.totalPlayingTime setFont:[UIFont systemFontOfSize:14]];
    [self.totalPlayingTime setTextColor:[UIColor whiteColor]];
    [self.totalPlayingTime setText:@"00:00"];
    [self.totalPlayingTime setTextAlignment:NSTextAlignmentCenter];
    //全屏按钮
    self.fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.footerImageView addSubview:self.fullScreenBtn];
    [self.fullScreenBtn setImage:[UIImage imageNamed:@"screen_full"] forState:UIControlStateNormal];
    [self.fullScreenBtn setImage:[UIImage imageNamed:@"screen_unfull"] forState:UIControlStateSelected];
    [self.fullScreenBtn addTarget:self action:@selector(fullScreenTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.playerView addSubview:self.footerImageView];
    //设置UI约束Frame
    [self.footerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playerView);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.playerView);
        make.right.equalTo(self.playerView);
    }];
    [self.playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.footerImageView);
        make.width.height.equalTo(@40);
        make.left.equalTo(self.footerImageView).offset(5);
    }];
    [self.currentPlaybackTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.footerImageView).offset(-5);
        make.left.equalTo(self.playOrPauseBtn.mas_right);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.footerImageView).offset(-15);
        make.left.equalTo(self.currentPlaybackTime.mas_right);
        make.right.equalTo(self.footerImageView).offset(-100);
    }];
    [self.loadingProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.footerImageView).offset(-18);
        make.left.equalTo(self.currentPlaybackTime.mas_right);
        make.right.equalTo(self.footerImageView).offset(-100);
    }];
    [self.totalPlayingTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.footerImageView).offset(-5);
        make.left.equalTo(self.slider.mas_right).offset(10);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.footerImageView);
        make.left.equalTo(self.totalPlayingTime.mas_right);
        make.right.equalTo(self.footerImageView).offset(-5);
        make.height.equalTo(@40);
    }];
}

#pragma mark - slider按下
- (void)sliderTouchDown:(UISlider *)slider{
    //关闭隐藏头尾视图的计时器
    [self.dismissTimer invalidate];
    self.dismissTimer = nil;
    //设置slider状态
    self.sliderState = YES;
    
}

#pragma mark - slider弹起
- (void)sliderTouchUpInside:(UISlider *)slider{
    __weak typeof(self)weakSelf = self;
    //跳转到指定时间
    [self.playerLayer.player seekToTime:CMTimeMake(slider.value * [self duration], 1.0) completionHandler:^(BOOL finished) {
        if (finished == YES) {
            weakSelf.sliderState = NO;
        }
        
    }];
    //开启计时器,播放5秒后隐藏头、尾视图
    [self dismissTimerView];
}

#pragma mark - slider值改变
- (void)sliderValueChanged:(UISlider *)slider{
    self.currentPlaybackTime.text = [self convertTime:slider.value * [self duration]];
    self.playerLayer.player.volume = slider.value;
}

#pragma mark - 点击播放或暂停按钮时调用
- (void)playOrPauseTouchUpInside:(UIButton *)sender{
    if (sender.selected == NO) {
        sender.selected = YES;
        //暂停
        [self pause];
    }
    else{
        sender.selected = NO;
        //播放
        [self play];
    }
}

#pragma mark - 全屏／或缩小 时调用
- (void)fullScreenTouchUpInside:(UIButton *)sender{
    //全屏
    if (sender.selected == NO) {
        sender.selected = YES;
        //让设备横屏
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft]forKey:@"orientation"];
        self.lastWindow.backgroundColor = [UIColor purpleColor];
        [self.playerView addSubview:self.headerImageView];
        [self.lastWindow addSubview:self.playerView];
        //把播放层设置为屏幕大小
        self.playerLayer.frame = self.lastWindow.frame;
        self.playerLayer.videoGravity = AVLayerVideoGravityResize;
        self.playerView.frame = self.lastWindow.frame;
        //重新设置头尾部控件约束
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.playerView);
            make.left.equalTo(self.playerView);
            make.right.equalTo(self.playerView);
            make.height.equalTo(@60);
        }];
        [self.footerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.playerView);
            make.height.equalTo(@50);
            make.bottom.equalTo(self.playerView);
            make.right.equalTo(self.playerView);
        }];
    }else{//缩小
        [self reduceTheVideo];
    }
}

- (UIWindow *)lastWindow
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        
        if ([window isKindOfClass:[UIWindow class]] &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            
            return window;
    }
    
    return [UIApplication sharedApplication].keyWindow;
}

- (void)reduceTheVideo{
    self.fullScreenBtn.selected = NO;
    //还原设备屏幕方向
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait]forKey:@"orientation"];
    self.playerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 225);
    self.playerLayer.frame = self.playerView.frame;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    //添加到原视图上
    [self.contentView addSubview:self.playerView];
    [self.contentView addSubview:self.placeholderImageView];
    [self.contentView addSubview:self.headerImageView];
    //重新设置头部控件约束
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playerView);
        make.left.equalTo(self.playerView);
        make.right.equalTo(self.playerView);
        make.height.equalTo(@60);
    }];
}
#pragma mark -  创建底部功具视图
- (void)createBottomToolView{
    self.bottomToolView = [[UIView alloc]init];
    [self.contentView addSubview:self.bottomToolView];
    self.bottomToolView.backgroundColor = [UIColor whiteColor];
    //用户头像
    self.avatarsImageView = [[UIImageView alloc]init];
    [self.bottomToolView addSubview:self.avatarsImageView];
    self.avatarsImageView.layer.cornerRadius = 25;
    self.avatarsImageView.layer.masksToBounds = YES;
    //用户名称
    self.userName = [[UILabel alloc]init];
    [self.bottomToolView addSubview:self.userName];
    //分享
    self.sharingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomToolView addSubview:self.sharingBtn];
    [self.sharingBtn setImage:[UIImage imageNamed:@"552cc42e5e94c_32.png"] forState:UIControlStateNormal];
    [self.sharingBtn addTarget:self action:@selector(shareVideo:) forControlEvents:UIControlEventTouchUpInside];
    //约束
    [self.bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self);
        make.height.equalTo(@60);
    }];
    [self.avatarsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomToolView).offset(5);
        make.bottom.equalTo(self.bottomToolView).offset(-5);
        make.left.equalTo(self.bottomToolView).offset(10);
        make.width.height.equalTo(@50);
    }];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomToolView).offset(5);
        make.left.equalTo(self.avatarsImageView.mas_right).offset(10);
        make.bottom.equalTo(self.bottomToolView).offset(-5);
        make.right.equalTo(self.bottomToolView).offset(-70);
    }];
    [self.sharingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomToolView).offset(5);
        make.right.equalTo(self.bottomToolView).offset(-10);
        make.width.height.equalTo(@50);
        make.bottom.equalTo(self.bottomToolView).offset(-5);
    }];
}

#pragma mark - 分享视频
- (void)shareVideo:(UIButton *)sender{
    //此处功能  分享到QQ、微博、微信。
    //1、创建分享参数
    NSArray *imageArray = @[[UIImage imageNamed:@"tabbar_picture@3x.png"]];
    
    
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:self.model.title
                                         images:imageArray
                                            url:[NSURL URLWithString:self.model.mp4_url]
                                          title:self.model.title
                                           type:SSDKContentTypeAuto];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"分享成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                               UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                               
                               [alert addAction:action];
                               NSLog(@"111");
                               // [self presentViewController:alert animated:YES completion:nil];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"分享失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
                               UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                               
                               [alert addAction:action];
                               // [self presentViewController:alert animated:YES completion:nil];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
}

#pragma mark - 时间转换
- (NSString *)convertTime:(float)second{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [[self dateFormatter] setDateFormat:@"HH:mm:ss"];
    } else {
        [[self dateFormatter] setDateFormat:@"mm:ss"];
    }
    return [[self dateFormatter] stringFromDate:date];
}

#pragma mark - 隐藏头尾部视图的计时器
- (void)dismissTimerView{
    if (self.dismissTimer == nil) {
    
        self.dismissTimer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(hideHeaderViewAndBottomView) userInfo:nil repeats:NO];
        /*我们通常在主线程中使用NSTimer，有个实际遇到的问题需要注意。当滑动界面时，系统为了更好地处理UI事件和滚动显示，主线程runloop会暂时停止处理一些其它事件，这时主线程中运行的NSTimer就会被暂停。解决办法就是改变NSTimer运行的mode（mode可以看成事件类型），不使用缺省的NSDefaultRunLoopMode，而是改用NSRunLoopCommonModes，这样主线程就会继续处理NSTimer事件了*/
        [[NSRunLoop currentRunLoop] addTimer:self.dismissTimer forMode:NSDefaultRunLoopMode];
    }
}

#pragma mark 隐藏headerView和bottomView
- (void)hideHeaderViewAndBottomView {
    [UIView animateWithDuration:0.5 animations:^{
        self.headerImageView.hidden = YES;
        self.footerImageView.hidden = YES;
    } completion:^(BOOL finished) {
        if (finished == YES) {
            [self.dismissTimer invalidate];
            self.dismissTimer = nil;
        }
    }];
}

#pragma mark 显示headerView和bottomView
- (void)showHeaderViewAndBottomView {
    [UIView animateWithDuration:0.5 animations:^{
        self.headerImageView.hidden = NO;
        self.footerImageView.hidden = NO;
    }];
}

#pragma mark - GestureRecognizerDelagate
//当拖动UISlider时会被误认为是手势，所以在这个判断一下   解决手势与UISlider事件的冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if([touch.view isKindOfClass:[UISlider class]])
        return NO;
    else
        return YES;
}


- (void)dealloc{
    [self destroyPlayer];
}

#pragma mark - 销毁播放器
- (void)destroyPlayer{
    //暂停播放
    [self pause];
    [self.playerLayer.player.currentItem cancelPendingSeeks];
    [self.playerLayer.player.currentItem.asset cancelLoading];
    //移除播放层
    [self.playerLayer removeFromSuperlayer];
    //替换为nil
    [self.playerLayer.player replaceCurrentItemWithPlayerItem:nil];
    self.playerLayer.player = nil;
    self.playerLayer = nil;
    //释放计时器
    [self.dismissTimer invalidate];
    self.dismissTimer = nil;
    //移除进度监控
    [self.playerLayer.player removeTimeObserver:self.playTimeObserver];
    //移除监听
    [self removeObserverWithPlayItem:self.playerLayer.player.currentItem];
    //移除通知
    [self removeNotification];
}







- (void)prepareForReuse{
    [super prepareForReuse];
    //显示占位图
    self.placeholderImageView.hidden = NO;
    //显示头尾部控件
    self.headerImageView.hidden = NO;
    self.footerImageView.hidden = NO;
    //暂停监听进度
    [self.playTimeObserver invalidate];
    self.playTimeObserver = nil;
    //暂停隐藏头尾部控件的计时器
    [self.dismissTimer invalidate];
    self.dismissTimer = nil;
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
