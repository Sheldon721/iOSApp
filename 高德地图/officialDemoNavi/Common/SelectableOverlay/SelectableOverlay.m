//
//  SelectableOverlay.m
//  officialDemo2D
//
//  Created by 李晓东 on 17-11-2.
//  Copyright (c) 2017年 李晓东. All rights reserved.
//

#import "SelectableOverlay.h"

@implementation SelectableOverlay

#pragma mark - MAOverlay Protocol

- (CLLocationCoordinate2D)coordinate
{
    return [self.overlay coordinate];
}

- (MAMapRect)boundingMapRect
{
    return [self.overlay boundingMapRect];
}

#pragma mark - Life Cycle

- (id)initWithOverlay:(id<MAOverlay>)overlay
{
    self = [super init];
    if (self)
    {
        self.overlay       = overlay;
        self.selected      = NO;
        self.selectedColor = [UIColor colorWithRed:0.05 green:0.39 blue:0.9  alpha:0.8];
        self.regularColor  = [UIColor colorWithRed:0.5  green:0.6  blue:0.9  alpha:0.8];
    }
    
    return self;
}

@end
