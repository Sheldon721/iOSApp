//
//  AppDelegate.m
//  网易新闻
//
//  Created by 李晓东 on 2017/6/20.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "AppDelegate.h"
#import "YindaoyeController.h"
#import "TabBarController.h"
#import "XinWenXianQingViewController.h"
@interface AppDelegate ()<UNUserNotificationCenterDelegate>
{
    TabBarController *_tabbar;
    NSString *_title;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //
    if (@available(ios 11.0,*)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
    }
    
    
    //注册本地通知
    // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    //监听回调事件
    center.delegate = self;
    
    //iOS 10 使用以下方法注册，才能得到授权
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              // Enable or disable features based on authorization.
                          }];
    
    //获取当前的通知设置，UNNotificationSettings 是只读对象，不能直接修改，只能通过以下方法获取
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        
    }];
    
    
    
    
    
    
    
    
    
    
    /**初始化ShareSDK应用
     @param activePlatforms
     使用的分享平台集合
     @param importHandler (onImport)
     导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作
     @param configurationHandler (onConfiguration)
     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
     */
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformTypeMail),
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ),
                                        ]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"3701934564"
                                           appSecret:@"6a6727dde40d8496abf6a7805e507ca1"
                                         redirectUri:@"http://hui.2018ka.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxd40ee3374186e86c"
                                       appSecret:@"10a19566a5ec1aab783f7e66c188e558"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1106223379"
                                      appKey:@"qyIKvsPZGUFSU7X7"
                                    authType:SSDKAuthTypeBoth];
                 break;
             
             default:
                 break;
         }
     }];
    
    
    
    ///
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //-----------------------判断程序是否是第一次使用，是就显示引导页-----
    //从沙盒获取版本号
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@",NSHomeDirectory());
    NSString *key = @"CFBundleVersion";
    NSString *currentVersion = [user objectForKey:key];
    //从info.plist文件中读取应用程序版本号
    NSString *CFVersion = [[NSBundle mainBundle].infoDictionary objectForKey:key];
    //判断版本号是否相同
    if ([currentVersion isEqualToString:CFVersion]) {
        //相同  跳转主页
        _tabbar = [[TabBarController alloc]init];
        self.window.rootViewController = _tabbar;
    }
    else{
        //不相同  显示引导页
        YindaoyeController *yinDaoYe = [[YindaoyeController alloc]init];
        self.window.rootViewController = yinDaoYe;
        //把新版本号写入沙盒
        [user setObject:CFVersion forKey:key];
        //立即写入
        [user synchronize];
    }
    [self.window makeKeyAndVisible];
    
   
    
    
    
    
    return YES;
}

//openURL:
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [TencentOAuth HandleOpenURL:url];
}

//handleOpenURL:
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url];
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    [TencentOAuth HandleOpenURL:url];
    return YES;
}
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
//    [TencentOAuth HandleOpenURL:url];
//}

#pragma mark - UNUserNotificationCenterDelegate
//在展示通知前进行处理，即有机会在展示通知前再修改通知内容。
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    //1. 处理通知
    
    //2. 处理完成后条用 completionHandler ，用于指示在前台显示通知的形式
    completionHandler(UNNotificationPresentationOptionAlert);
}
//点击通知 跳转控制器
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    //延迟5秒后跳转  用户杀死app后 需要先初始化主界面 才能跳转  否则app闪退
    [self performSelector:@selector(tiao:) withObject:response.notification.request.content.title afterDelay:1];
    
}
- (void)tiao:(NSString *)str{
    FMDBTool *dbTool = [[FMDBTool alloc]init];
    XinWenXianQingViewController *xwxq = [[XinWenXianQingViewController alloc]init];
    xwxq.model = dbTool.xinWenModel;
    //push后不在显示tabbar控制器
    _tabbar.xinWen.hidesBottomBarWhenPushed = YES;
    [_tabbar.xinWen.navigationController pushViewController:xwxq animated:YES];
    _tabbar.xinWen.hidesBottomBarWhenPushed = NO;

}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
