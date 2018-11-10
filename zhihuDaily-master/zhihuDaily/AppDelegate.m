//
//  AppDelegate.m
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/15.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

#import "APIDataSource.h"
#import "AppDelegate.h"
#import "CacheUtil.h"
#import "CachedImage.h"
#import "LoadingViewController.h"

@interface
AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application
  didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{

  [[APIDataSource dataSource] startImage:nil];
  return YES;
}

- (void)changeRootViewController:(UIViewController*)viewController
                         animate:(BOOL)animate
{
  if (!self.window.rootViewController || !animate) {
    self.window.rootViewController = viewController;
    return;
  }

  UIView* snapShot = [self.window snapshotViewAfterScreenUpdates:YES];
  [viewController.view addSubview:snapShot];

  self.window.rootViewController = viewController;

  [UIView animateWithDuration:1
    animations:^{
      snapShot.layer.opacity = 0;
    }
    completion:^(BOOL finished) {
      [snapShot removeFromSuperview];
    }];
}

- (void)applicationWillTerminate:(UIApplication*)application
{
  [[CacheUtil cache] saveData];
}
- (void)applicationWillResignActive:(UIApplication*)application
{
  [[CacheUtil cache] saveData];
}
@end
