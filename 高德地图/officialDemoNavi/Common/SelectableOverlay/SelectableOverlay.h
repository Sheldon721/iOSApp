//
//  SelectableOverlay.h
//  officialDemo2D
//
//  Created by 李晓东 on 17-11-2.
//  Copyright (c) 2017年 李晓东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@interface SelectableOverlay : NSObject<MAOverlay>

@property (nonatomic, assign) NSInteger routeID;

@property (nonatomic, assign, getter = isSelected) BOOL selected;
@property (nonatomic, strong) UIColor * selectedColor;
@property (nonatomic, strong) UIColor * regularColor;

@property (nonatomic, strong) id<MAOverlay> overlay;

- (id)initWithOverlay:(id<MAOverlay>) overlay;

@end
