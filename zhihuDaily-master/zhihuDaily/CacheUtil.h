//
//  CacheUtil.h
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/16.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString* const kCacheImagePath;
extern NSString* const kDataPath;

@class CachedImage;

/**
 *  缓存单例类
 */
@interface CacheUtil : NSObject
@property (strong, nonatomic) NSMutableDictionary* dataDic;
+ (instancetype)cache;

/**
 *  缓存图片
 *
 *  @param key        key
 *  @param url        图片地址
 *  @param completion 回调
 */
- (void)cacheImageWithKey:(NSString*)key andUrl:(NSString*)url completion:(void (^)(UIImage* image))completion;
/**
 *  根据key获取图片
 *
 *  @param key <#key description#>
 *
 *  @return <#return value description#>
 */
- (UIImage*)imageWithKey:(NSString*)key;
/**
 *  根据key获取CachedImages实例
 *
 *  @param key <#key description#>
 *
 *  @return <#return value description#>
 */
- (CachedImage*)cachedImageWithKey:(NSString*)key;
/**
 *  保存缓存
 */
- (void)saveData;
@end
