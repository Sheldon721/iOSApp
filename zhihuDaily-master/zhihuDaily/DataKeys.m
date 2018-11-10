//
//  DataKeys.m
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/17.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

/*
 用于存放plist的key
 */

#import <Foundation/Foundation.h>

/*缓存图片*/
static NSString* const DATAKEY_CACHEDIMAGES = @"CachedImages";
static NSString* const DATAKEY_CACHEDIMAGES_URL = @"url";
static NSString* const DATAKEY_CACHEDIMAGES_FILENAME = @"fileName";

/*起始图片*/
static NSString* const DATAKEY_STARTIMAGE = @"StartImage";
static NSString* const DATAKEY_STARTIMAGE_AUTHOR = @"StartImageAuthor";
static NSString* const DATAKEY_STARTIMAGE_URL = @"StartImageUrl";

/*首页数据*/
static NSString* const DATAKEY_STORIES = @"StoryData";
static NSString* const DATAKEY_STORIES_SIGNATURE = @"signature";
static NSString* const DATAKEY_STORIES_DATE = @"date";
static NSString* const DATAKEY_STORIES_STORIES = @"stories";
static NSString* const DATAKEY_STORIES_TOPSTORIES = @"top_stories";
