//
//  TestViewController.h
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/16.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StoryViewDelegate<NSObject>
/**
 *  当该控制器生命周期结束时调用该方法以释放SliderView
 */
- (void)releaseStoryView;
@end

@interface StoryView : UIWebView
@property (weak, nonatomic) id<StoryViewDelegate> storyViewDelegate;
@property (strong, nonatomic) SliderViewController* sliderViewController;

@property (assign, nonatomic) NSUInteger identifier;
@end
