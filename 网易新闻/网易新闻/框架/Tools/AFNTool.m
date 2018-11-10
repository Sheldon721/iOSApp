//
//  AFNTool.m
//  网易新闻
//
//  Created by 李晓东 on 2017/7/4.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "AFNTool.h"

@implementation AFNTool

+(void)POST:(NSString *)URLString parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure{
    //创建管理者对象
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    //设置返回的序列化 为二进制
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"--%@",responseObject);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)GET:(NSString *)URLString parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+(void)wangLuoLianJieZhuangTai:(void (^)(BOOL))zha{
    //检查网络连接状态
    //AFNetworkReachabilityManager 网络连接监控管理类
    //开启网络状态监控器
    //sharedManager:获取唯一的单例对象
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    //获取网络连接的判断结果
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"通过WIFI连接网络");
                zha(YES);
                
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"无网络连接");
                zha(NO);
            }
                
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                NSLog(@"通过4G网络连接");
                zha(YES);
            }
            default:
                
                break;
        }
    }];
}
@end
