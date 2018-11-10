//
//  PlayerCell.h
//  LCZPlayerDemo
//
//  Created by 李晓东 on 2017/11/8.
//  Copyright © 2017年 李晓东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 播放器的几种状态
typedef NS_ENUM(NSInteger, LCZPlayerState) {
    LCZPlayerStateFailed,        // 播放失败
    LCZPlayerStateBuffering,     // 缓冲中
    LCZPlayerStatePlaying,       // 播放中
    LCZPlayerStatePause,          // 暂停播放
};


@interface PlayerCell : UITableViewCell
/** 播放地址 */
@property(nonatomic, strong) NSString *videoAddress;
/**播放层 */
@property(nonatomic,strong) AVPlayerLayer *playerLayer;
/** 播放器视图 */
@property(nonatomic,strong) UIView *playerView;
/** 播放器状态 */
@property(nonatomic,assign) LCZPlayerState playerState;
/** 占位图 */
@property(nonatomic,strong) UIImageView *placeholderImageView;
/** 占位图上的播放按钮 */
@property(nonatomic,strong) UIButton *placeholderPlayButton;
/**播放器头部视图 */
@property(nonatomic,strong) UIImageView *headerImageView;
/**返回按钮 */
@property(nonatomic,strong) UIButton *headerBtn;
/** 标题 */
@property(nonatomic, strong) UILabel *headerLabel;
/** 播放器尾部视图 */
@property(nonatomic,strong) UIImageView *footerImageView;
/** 播放或暂停按钮 */
@property(nonatomic,strong) UIButton *playOrPauseBtn;
/** 当前播放时长 */
@property(nonatomic,strong) UILabel *currentPlaybackTime;
/** 滑动条 */
@property(nonatomic,strong) UISlider *slider;
/** 缓存进度条 */
@property(nonatomic,strong) UIProgressView *loadingProgress;
/** 总播放时长 */
@property(nonatomic,strong) UILabel *totalPlayingTime;
/** 全屏按钮 */
@property(nonatomic,strong) UIButton *fullScreenBtn;
/** 遮盖层按钮 */
@property(nonatomic,strong) UIButton *coverLayerBtn;
/** 底部工具视图 */
@property(nonatomic,strong) UIView *bottomToolView;
/** 视频模型 */
@property(nonatomic,strong) ShiPingModel *model;
/** 小菊花 */
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
/** 监听播放起状态的监听者 */
@property (nonatomic ,strong) id playTimeObserver;
/** sliderState */
@property(nonatomic,assign) BOOL  sliderState;
/** 日期格式化 */
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
/** 隐藏头尾视图计时器 */
@property(nonatomic,strong) NSTimer *dismissTimer;
/** 系统音量 */
@property(nonatomic,strong) UISlider *volumeViewSlider;
/** 用户头像 */
@property(nonatomic,strong) UIImageView *avatarsImageView;
/** 用户名称 */
@property(nonatomic,strong) UILabel *userName;
/** 分享按钮 */
@property(nonatomic,strong) UIButton *sharingBtn;
/** 存储所有cell的数组  */
@property(nonatomic,strong) NSMutableArray *cellMutableArray;
@property(nonatomic,strong) NSIndexPath *indexPath;
@property(nonatomic,strong) UITableView *tableView;
/** 最外层窗口 */
@property(nonatomic,strong) UIWindow *lastWindow;


#pragma mark - 销毁播放器
- (void)destroyPlayer;
#pragma mark - 点击返回按钮时调用
- (void)restorenitialUI:(UIButton *)sender;
@end
