//
//  DriveNaviViewController.h
//  AMapNaviKit
//
//  Created by李晓东 on 17/10/12.
//  Copyright © 2017年 李晓东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

@protocol DriveNaviViewControllerDelegate;

@interface DriveNaviViewController : UIViewController

@property (nonatomic, weak) id <DriveNaviViewControllerDelegate> delegate;

@property (nonatomic, strong) AMapNaviDriveView *driveView;

@end

@protocol DriveNaviViewControllerDelegate <NSObject>

- (void)driveNaviViewCloseButtonClicked;

@end
