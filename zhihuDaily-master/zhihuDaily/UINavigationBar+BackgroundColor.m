//
//  UINavigationBar+BackgroundColor.m
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/22.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

#import "UINavigationBar+BackgroundColor.h"
#import <objc/runtime.h>

@implementation UINavigationBar (BackgroundColor)
static char overlayKey;

- (UIView*)overlay
{
  return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView*)overlay
{
  objc_setAssociatedObject(self, &overlayKey, overlay,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setNavigationBackgroundColor:(UIColor*)backgroundColor
{
  if (!self.overlay) {
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];

    // insert an overlay into the view hierarchy
    self.overlay = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
                               self.bounds.size.height + 20)];
    self.overlay.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.superview insertSubview:self.overlay
                          atIndex:self.superview.subviews.count - 2];

    //移除用作navigationbar类似边框阴影的一个imageview
    [self.subviews
      enumerateObjectsUsingBlock:^(__kindof UIView* _Nonnull obj,
                                   NSUInteger idx, BOOL* _Nonnull stop) {
        NSString* className = [NSString stringWithFormat:@"%@", [obj class]];
        if ([className isEqualToString:@"_UINavigationBarBackground"]) {
          if (obj.subviews.count > 0) {
            [obj.subviews[0] removeFromSuperview];
          }
        }
      }];
  }
  self.overlay.backgroundColor = backgroundColor;
}

- (void)setBackgroundLayerHeight:(CGFloat)height
{
  CGRect rect = self.overlay.frame;
  self.overlay.frame = CGRectMake(0, 0, rect.size.width, height);
}
@end
