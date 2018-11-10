//
//  WenDaModel.h
//  网易新闻
//
//  Created by 李晓东 on 2017/8/24.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WenDaModel : NSObject
@property (nonatomic ,strong) NSString *content;//内容
@property (nonatomic ,assign) BOOL zhuanTai;//用于判断是发送还是接收的数据
@end
