//
//  AFNTool.h
//  快易查
//
//  Created by 刘超正 on 2017/11/17.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^SuccessBlock) (id result);// 成功调用的block
typedef void(^FailureBlock) (NSError *error);//失败调用的block
@interface AFNTool : NSObject
+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;
//监测网络状态
+(void)wangLuoLianJieZhuangTai:(void(^)(BOOL zhuang))zha;
@end
