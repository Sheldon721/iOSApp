//
//  zhihuDailyAPI.h
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/16.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

#define API_Url @"http://news-at.zhihu.com/api/4/news/"
#define API_Url_NewsLatest @"http://news-at.zhihu.com/api/4/news/latest"
#define API_Url_NewsBefore @"http://news.at.zhihu.com/api/4/news/before/"
#define API_Url_StartImage @"http://news-at.zhihu.com/api/4/start-image/"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Stories;
@class Story;

@interface APIDataSource : NSObject
+ (instancetype)dataSource;

#pragma mark - NewsLatest & NewsBefore
@property (strong, nonatomic) NSArray<Stories*>* topStories;
@property (strong, nonatomic) NSString* date;
@property (strong, nonatomic) NSArray* stories;
@property (assign, nonatomic) BOOL isRequesting;

- (void)newsLatest:(void (^)(BOOL needsToReload))completion;
- (void)newsBefore:(NSString*)date completion:(void (^)(void))completion;

#pragma mark - StartImage
@property (strong, nonatomic) UIImage* startImage;
@property (strong, nonatomic) NSString* startImageAuthor;
- (void)startImage:(void (^)(void))completion;

#pragma mark - News
@property (strong, nonatomic) Story* story;
- (void)news:(NSUInteger)identifier completion:(void (^)(void))completion;
@end
