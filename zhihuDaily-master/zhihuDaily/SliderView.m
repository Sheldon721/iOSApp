//
//  SliderView.m
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/19.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

#import "GradientView.h"
#import "SliderView.h"

@interface
SliderView ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView* scrollView;
@property (strong, nonatomic) UIPageControl* pageControl;
@property (strong, nonatomic) UIButton* button;

@property (assign, nonatomic) CGSize viewSize;
@property (assign, nonatomic) NSUInteger pageIndex;
@property (strong, nonatomic) NSTimer* timer;

@property (assign, nonatomic) NSUInteger imageCount;
@property (strong, nonatomic) NSMutableArray<UIImageView*>* imageViews;

@property (assign, nonatomic) BOOL singleImageMode;
@end

@implementation SliderView
#pragma mark - release
- (void)dealloc
{
  [self removeFromSuperview];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    self.viewSize = frame.size;
  }
  return self;
}
- (void)buildSliderView
{
  [self loadImages];
  [self loadContents];
  [self loadButton];
  [self addSubview:self.scrollView];
  [self bringSubviewToFront:self.pageControl];
  [self startSliding];

  NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self
         selector:@selector(stopSliding)
             name:UIApplicationWillResignActiveNotification
           object:nil];
  [nc addObserver:self
         selector:@selector(startSliding)
             name:UIApplicationDidBecomeActiveNotification
           object:nil];
}

- (void)loadImages
{
  for (int i = 0; i < self.imageCount; i++) {
    UIImageView* imageView = [[UIImageView alloc]
      initWithFrame:CGRectMake(i * self.viewSize.width, 0, self.viewSize.width,
                               self.viewSize.height)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;

    imageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.scrollView addSubview:imageView];
    [self.imageViews addObject:imageView];

    //委托获取图片
    if ([self.dataSource
          respondsToSelector:@selector(imageForSliderAtIndex:)]) {
      UIImage* image = [self.dataSource imageForSliderAtIndex:i];
      if (image != nil)
        imageView.image = image;
    }
  }
}
- (void)loadContents
{
  if (![self.dataSource respondsToSelector:@selector(titleForSliderAtIndex:)])
    return;

  for (int i = 0; i < self.imageCount; i++) {
    //委托获取内容
    NSString* content = [self.dataSource titleForSliderAtIndex:i];
    if (content == nil)
      continue;

    GradientView* gradientView = [[GradientView alloc]
      initWithFrame:CGRectMake(i * self.viewSize.width,
                               labs(self.contentInsetY), self.viewSize.width,
                               self.viewSize.height + self.contentInsetY)];
    gradientView.gradientLayer.colors = [NSArray
      arrayWithObjects:(id)[[UIColor clearColor] CGColor],
                       (id)[[UIColor colorWithWhite:0 alpha:0.7] CGColor], nil];

    UILabel* label = [[UILabel alloc]
      initWithFrame:CGRectMake(10, gradientView.bounds.size.height - 70,
                               self.viewSize.width - 20, 50)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:20 weight:0.3];
    label.shadowOffset = CGSizeMake(0, 1);
    label.shadowColor = [UIColor blackColor];
    label.numberOfLines = 2;
    label.text = content;
    //由于label的文字是垂直居中，在单行时需要调用该方法适配
    [label sizeToFit];

    [gradientView addSubview:label];
    [self.scrollView addSubview:gradientView];

    if (![self.dataSource
          respondsToSelector:@selector(subTitleForSliderAtIndex:)])
      continue;

    NSString* sourceString = [self.dataSource subTitleForSliderAtIndex:i];
    UILabel* imageSourceLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(label.frame.origin.x,
                               gradientView.bounds.size.height - 20,
                               gradientView.bounds.size.width - 20, 16)];
    imageSourceLabel.textColor = [UIColor colorWithWhite:.8 alpha:1];
    imageSourceLabel.font = [UIFont systemFontOfSize:10];
    imageSourceLabel.shadowOffset = label.shadowOffset;
    imageSourceLabel.shadowColor = [UIColor colorWithWhite:.3 alpha:1];
    imageSourceLabel.text = sourceString;
    imageSourceLabel.textAlignment = NSTextAlignmentRight;

    [gradientView addSubview:imageSourceLabel];
  }
}
- (void)loadButton
{
  self.button = [[UIButton alloc]
    initWithFrame:CGRectMake(0, 0, _scrollView.contentSize.width,
                             _scrollView.contentSize.height)];
  self.button.titleLabel.text = @"";
  [self.button addTarget:self
                  action:@selector(sliderClicked)
        forControlEvents:UIControlEventTouchUpInside];

  [self.scrollView addSubview:self.button];
}
- (UIPageControl*)pageControl
{
  if (_pageControl == nil) {
    _pageControl = [[UIPageControl alloc] init];
    if (self.singleImageMode)
      return _pageControl;

    _pageControl.numberOfPages = self.imageCount;
    CGSize pagerSize = [_pageControl sizeForNumberOfPages:self.imageCount];
    _pageControl.bounds =
      CGRectMake(0, 0, self.viewSize.width, pagerSize.height);
    _pageControl.center = CGPointMake(self.center.x, self.viewSize.height - 15);

    _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.3];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];

    [_pageControl addTarget:self
                     action:@selector(pageChanged:)
           forControlEvents:UIControlEventValueChanged];

    [self addSubview:_pageControl];
  }
  return _pageControl;
}
- (UIScrollView*)scrollView
{
  if (_scrollView == nil) {
    _scrollView =
      [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.viewSize.width,
                                                     self.viewSize.height)];

    [_scrollView
      setContentSize:CGSizeMake(self.viewSize.width * self.imageCount,
                                self.viewSize.height)];
    [_scrollView setPagingEnabled:true];

    // 禁止反弹效果，隐藏滚动条
    [_scrollView setBounces:false];
    [_scrollView setShowsVerticalScrollIndicator:false];
    [_scrollView setShowsHorizontalScrollIndicator:false];

    _scrollView.delegate = self;
  }
  return _scrollView;
}
#pragma mark - getters
- (BOOL)singleImageMode
{
  return self.imageCount <= 1;
}
- (NSTimeInterval)interval
{
  if (_interval == 0) {
    _interval = 3;
  }
  return _interval;
}
- (CGSize)viewSize
{
  return self.bounds.size;
}
- (NSUInteger)imageCount
{
  if (_imageCount == 0) {
    _imageCount = [self.dataSource numberOfItemsInSliderView];
  }
  return _imageCount;
}

- (NSUInteger)pageIndex
{
  return self.scrollView.contentOffset.x / self.viewSize.width;
}
- (NSMutableArray<UIImageView*>*)imageViews
{
  if (_imageViews == nil) {
    _imageViews = [NSMutableArray array];
  }
  return _imageViews;
}
#pragma mark - public methods
- (void)setImage:(UIImage*)image atIndex:(NSUInteger)index
{
  UIImageView* imageView = self.imageViews[index];
  if (imageView != nil) {
    // CGRect position = imageView.frame;
    [imageView setImage:image];
    [imageView setNeedsDisplay];
    [self setNeedsDisplay];
    [self.scrollView setNeedsDisplay];
  }
}
- (void)stopSliding
{
  [self.timer invalidate];
}
- (void)startSliding
{
  if (self.singleImageMode)
    return;

  if (!self.timer.isValid)
    self.timer =
      [NSTimer scheduledTimerWithTimeInterval:self.interval
                                       target:self
                                     selector:@selector(intervalTriggered)
                                     userInfo:nil
                                      repeats:true];
}
#pragma mark - slider click event
- (void)sliderClicked
{
  if ([self.dataSource respondsToSelector:@selector(touchUpForSliderAtIndex:)])
    [self.dataSource touchUpForSliderAtIndex:self.pageIndex];
}

#pragma mark - Timer

- (void)intervalTriggered
{
  int pageIndex = (int)((self.pageControl.currentPage + 1) % self.imageCount);
  self.pageControl.currentPage = pageIndex;
  [self pageChanged:self.pageControl];
}

- (void)pageChanged:(UIPageControl*)pageControl
{
  CGFloat offsetX = pageControl.currentPage * self.viewSize.width;
  [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:true];
}

#pragma mark - ScrollView delegate methods
- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
  [self.timer invalidate];
}
- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView
                  willDecelerate:(BOOL)decelerate
{
  [self startSliding];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
  self.pageControl.currentPage = self.pageIndex;
}
@end
