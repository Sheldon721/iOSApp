//
//  MainTableViewCell.h
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/20.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Stories;

@interface StoriesTableViewCell : UITableViewCell
@property (strong, nonatomic) Stories* stories;
@end
