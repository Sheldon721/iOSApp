//
//  ViewController.h
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/15.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Stories;
@class Story;
@class SliderView;

@interface SliderViewController : UIViewController
@property (strong, nonatomic) SliderView* sliderView;

- (instancetype)initWithFrame:(CGRect)frame
                   andStories:(NSArray<Stories*>*)stories;
- (instancetype)initWithFrame:(CGRect)frame andStory:(Story*)story;
@end
