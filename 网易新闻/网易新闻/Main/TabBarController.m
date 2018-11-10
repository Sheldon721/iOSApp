//
//  TabBarController.m
//  网易新闻
//
//  Created by 李晓东 on 2017/6/20.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "TabBarController.h"
#import "NavigationController.h"

@interface TabBarController ()
{
    NSMutableArray *ary;
}
@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    [self initController];
}
//初始化控制器
- (void)initController{
    self.xinWen = [[XinWenViewController alloc]init];
    [self setupChildViewController:self.xinWen title:@"網易" imageName:@"tabbar_news@3x.png" selectedImage:@"tabbar_news_hl@3x.png"];
    TuPianViewController *tuPian = [[TuPianViewController alloc]init];
    [self setupChildViewController:tuPian title:@"图片" imageName:@"tabbar_picture@3x.png" selectedImage:@"tabbar_picture_hl@3x.png"];
    ShiPinViewController *shiPin = [[ShiPinViewController alloc]init];
    [self setupChildViewController:shiPin title:@"视频" imageName:@"tabbar_video@3x.png" selectedImage:@"tabbar_video_hl@3x.png"];
    WoViewController *wo = [[WoViewController alloc]init];
    [self setupChildViewController:wo title:@"我" imageName:@"tabbar_setting@3x.png" selectedImage:@"tabbar_setting_hl@3x.png"];
}
//设置按钮信息
-(void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImage:(NSString *)selectedImage{
    //设置控制器属性
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //包装一个导航控制器
    NavigationController *nav = [[NavigationController alloc]initWithRootViewController:childVc];
    [self addChildViewController:nav];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
