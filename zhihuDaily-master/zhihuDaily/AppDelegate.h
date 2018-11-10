//
//  AppDelegate.h
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/15.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder<UIApplicationDelegate>

@property (strong, nonatomic) UIWindow* window;
- (void)changeRootViewController:(UIViewController*)viewController
                         animate:(BOOL)animate;

@end
