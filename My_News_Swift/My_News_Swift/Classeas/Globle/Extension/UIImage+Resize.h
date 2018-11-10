//
//  UIImage+Resize.h
//  My_News_Swift
//
//  Created by LG on 2017/9/27.
//  Copyright © 2017年 LG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface UIImage (Resize)

/**
 *  根据图片名称生成可拉伸的图片
 *
 *  @param name 图片的名称
 *
 *  @return  可拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;

/**
 *  根据图片名称生成可拉伸的图片,并指定拉抻的区域
 *
 *  @param name 图片的名称
 *  @param left
 *  @param top
 *
 *  @return  可拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;


- (UIImage *)croppedImage:(CGRect)bounds;

- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;

- (CGAffineTransform)transformForOrientation:(CGSize)newSize;

- (UIImage *)fixOrientation;

- (UIImage *)rotatedByDegrees:(CGFloat)degrees;
@end
