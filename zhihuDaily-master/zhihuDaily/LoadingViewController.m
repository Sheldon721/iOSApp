//
//  LaunchScreenViewController.m
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/16.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

#import "APIDataSource.h"
#import "APIRequest.h"
#import "AppDelegate.h"
#import "CacheUtil.h"
#import "DataKeys.m"
#import "GCDUtil.h"
#import "GradientView.h"
#import "LoadingViewController.h"
#import "MainViewController.h"
#import "StartImage.h"

@interface
LoadingViewController ()
@property (strong, nonatomic) IBOutlet UILabel* authorLabel;
@property (strong, nonatomic) IBOutlet UIImageView* startImage;
@property (strong, nonatomic) IBOutlet UIImageView* logoImage;

@property (strong, nonatomic) APIDataSource* dataSource;
@end

@implementation LoadingViewController
#pragma mark -
- (APIDataSource*)dataSource
{
  if (_dataSource == nil) {
    _dataSource = [APIDataSource dataSource];
  }
  return _dataSource;
}
#pragma mark -
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self loadStartImage];
  [self loadAnimations];
  [self loadGradientView];
}
- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.startImage = nil;
}
#pragma mark -
- (void)loadStartImage
{
  UIImage* image = self.dataSource.startImage;
  if (image != nil) {
    self.startImage.image = image;
    self.authorLabel.text = self.dataSource.startImageAuthor;
  }
}
- (void)loadGradientView
{
  GradientView* gradientView = [[GradientView alloc] init];

  [self.view addSubview:gradientView];

  NSDictionary* views = NSDictionaryOfVariableBindings(gradientView, self.view);
  NSString* vfw = [NSString
    stringWithFormat:@"H:|[gradientView(%f)]|", self.view.bounds.size.width];
  [self.view
    addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfw
                                                           options:0
                                                           metrics:nil
                                                             views:views]];
  [self.view
    addConstraints:[NSLayoutConstraint
                     constraintsWithVisualFormat:@"V:[gradientView(250)]|"
                                         options:0
                                         metrics:nil
                                           views:views]];

  [self.view bringSubviewToFront:self.logoImage];
  [self.view bringSubviewToFront:self.authorLabel];
}
- (void)loadAnimations
{
  //放大动画
  [UIView animateWithDuration:3
                        delay:0.0
                      options:(UIViewAnimationOptionTransitionCrossDissolve)
                   animations:^{
                     self.startImage.layer.transform =
                       CATransform3DMakeScale(1.1, 1.1, 1.1);
                   }
                   completion:nil];

  //跳转
  //不管通过什么方式跳转，在有sb的情况下一定要让该viewcontroller加载sb之后再跳转，否则初始化会出问题
  UIStoryboard* storyboard =
    [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  UINavigationController* viewController = [storyboard
    instantiateViewControllerWithIdentifier:@"RootNavigationController"];
  AppDelegate* delegate = [UIApplication sharedApplication].delegate;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
                 dispatch_get_main_queue(), ^{
                   [delegate changeRootViewController:viewController
                                              animate:true];
                 });
}
@end
