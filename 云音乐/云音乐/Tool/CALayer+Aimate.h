//
//  CALayer+Aimate.h
//  云音乐
//
//  Created by 李晓东 on 2017/9/24.
//  Copyright © 2017年 李晓东. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (Aimate)
//暂停播放动画
- (void)pauseAnimate;
//继续播放动画
- (void)resumeAnimate;
@end
