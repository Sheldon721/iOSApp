//
//  TestViewController.m
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/16.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

#import "APIDataSource.h"
#import "APIRequest.h"
#import "GCDUtil.h"
#import "MainViewController.h"
#import "SliderView.h"
#import "SliderViewController.h"
#import "StartImage.h"
#import "Story.h"
#import "StoryView.h"
#import "UINavigationBar+BackgroundColor.h"

@interface
StoryView ()<UIScrollViewDelegate>
@property (strong, nonatomic) Story* story;
@property (strong, nonatomic) APIDataSource* dataSource;

@property (assign, nonatomic) CGSize viewSize;

@property (assign, nonatomic) CGPoint gestureStartPoint;
@end

@implementation StoryView
#pragma mark - accessors
- (APIDataSource*)dataSource
{
  if (_dataSource == nil) {
    _dataSource = [APIDataSource dataSource];
  }
  return _dataSource;
}
- (void)setIdentifier:(NSUInteger)identifier
{
  if (identifier != _identifier) {
    _identifier = identifier;

    [self loadStoryData];
  }
}
- (CGSize)viewSize
{
  return self.bounds.size;
}
- (SliderViewController*)sliderViewController
{
  if (_sliderViewController == nil) {
    _sliderViewController = [[SliderViewController alloc]
      initWithFrame:CGRectMake(0, 0, self.viewSize.width,
                               [MainViewController sliderDisplayHeight] +
                                 labs([MainViewController sliderInsetY]))
           andStory:self.story];
  }
  return _sliderViewController;
}
#pragma mark - init
- (instancetype)init
{
  if (self = [super init]) {
    [self buildWebView];
    [self buildNavigation];
  }
  return self;
}
- (void)buildWebView
{
  self.backgroundColor = [UIColor whiteColor];
  self.scrollView.contentInset =
    UIEdgeInsetsMake([MainViewController sliderInsetY], 0, 0, 0);

  [self addGestureRecognizer];
}
- (void)buildNavigation
{
}
#pragma mark - data load
- (void)loadSliderView
{
  [self.scrollView addSubview:self.sliderViewController.view];
}
- (void)loadWebView
{
  [[GCDUtil mainQueue] async:^{
    NSData* data =
      [NSData dataWithContentsOfURL:[NSURL URLWithString:self.story.css]];
    NSString* cssContent =
      [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSInteger bodyPadding =
      736 == [[UIScreen mainScreen] bounds].size.height ? 130 : 100;
    NSString* customCss = [NSString
      stringWithFormat:@"body {padding-top:%ldpx;}", (long)bodyPadding];
    NSString* htmlFormatString = @"<html><head><style>%@</style><style "
                                 @"type='text/css'>%@</style></head><body>%@</"
                                 @"body></html>";
    NSString* htmlString =
      [NSString stringWithFormat:htmlFormatString, cssContent, customCss,
                                 self.story.body];
    [[GCDUtil mainQueue] async:^{
      [self loadHTMLString:htmlString baseURL:nil];
    }];
  }];
}
- (void)loadStoryData
{
  [self.dataSource news:self.identifier
             completion:^{
               self.story = self.dataSource.story;

               [self loadSliderView];
               [self loadWebView];
             }];
}
#pragma mark - scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
  //限制scrollview的bounce size
  if (scrollView.contentOffset.y <= 0) {
    CGPoint offset = scrollView.contentOffset;
    offset.y = 0;
    scrollView.contentOffset = offset;
  }
}
#pragma mark - swipe back
- (void)addGestureRecognizer
{
  UISwipeGestureRecognizer* horizontal = [[UISwipeGestureRecognizer alloc]
    initWithTarget:self
            action:@selector(reportHorizontalSwipe:)];
  horizontal.direction = UISwipeGestureRecognizerDirectionRight;
  [self addGestureRecognizer:horizontal];
}
- (void)reportHorizontalSwipe:(UIGestureRecognizer*)recognizer
{
  [self backToMainViewController];
}
- (void)backToMainViewController
{
  [UIView animateWithDuration:0.3
    animations:^{
      self.frame = CGRectMake(self.bounds.size.width, 0, self.bounds.size.width,
                              self.bounds.size.height);
    }
    completion:^(BOOL finished) {
      if ([self.storyViewDelegate
            respondsToSelector:@selector(releaseStoryView)])
        [self.storyViewDelegate releaseStoryView];
    }];
}
- (void)dealloc
{
  //在navigationController作为rootController的时候，好像不会调用子控制器的viewWillDisappear，只有在这里将其先行释放
  [self.sliderViewController.sliderView removeFromSuperview];
}
@end
