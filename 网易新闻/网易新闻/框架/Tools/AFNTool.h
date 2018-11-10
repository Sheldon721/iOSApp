//
//  AFNTool.h
//  网易新闻
//
//  Created by 李晓东 on 2017/7/4.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef void(^SuccessBlock) (id result);// 成功调用的block
typedef void(^FailureBlock) (NSError *error);//失败调用的block
@interface AFNTool : NSObject

+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;
//监测网络状态
+(void)wangLuoLianJieZhuangTai:(void(^)(BOOL zhuang))zha;
@end
