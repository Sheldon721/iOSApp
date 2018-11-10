//
//  XinWenModel.h
//  网易新闻
//
//  Created by 李晓东 on 2017/7/7.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XinWenModel : NSObject

@property (nonatomic,strong) NSString *title;//标题
@property (nonatomic,strong) NSString *time;//时间
@property (nonatomic,strong) NSString *src;//来源
@property (nonatomic,strong) NSString *category;//分类
@property (nonatomic,strong) NSString *pic;//图片
@property (nonatomic,strong) NSString *content;//内容
@property (nonatomic,strong) NSString *url;//原文手机网址
@property (nonatomic,strong) NSString *weburl;//原文PC网址
@end
