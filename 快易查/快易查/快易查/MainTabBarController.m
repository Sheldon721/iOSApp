//
//  MainTabBarController.m
//  快易查
//
//  Created by 刘超正 on 2017/11/17.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //寄快递
    SendSpecialDeliveryViewController *sendSpecialDelivery = [[SendSpecialDeliveryViewController alloc]init];
    [self setupChildViewController:sendSpecialDelivery title:@"寄快递" imageName:@"5AF3A3D1D677D33AB220D0D437CAB20D" selectedImage:@"5AF3A3D1D677D33AB220D0D437CAB20D"];
    //查询快递
    QueryCourierViewController *queryCourier = [[QueryCourierViewController alloc]init];
    [self setupChildViewController:queryCourier title:@"查询" imageName:@"0D22820C33680485F9216446495F9167" selectedImage:@"0D22820C33680485F9216446495F9167"];
    //快递电话
    CourierPhoneViewController *courierPhone = [[CourierPhoneViewController alloc]init];
    [self setupChildViewController:courierPhone title:@"快递电话" imageName:@"4E2B022E0DA38F8EB70C63839EC1F4C9" selectedImage:@"4E2B022E0DA38F8EB70C63839EC1F4C9"];
}

//设置按钮信息
-(void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImage:(NSString *)selectedImage{
    //设置控制器属性
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarController.tabBar.unselectedItemTintColor = [UIColor redColor];
    //包装一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:childVc];
    if ([title isEqualToString:@"寄快递"]) {
        childVc.navigationItem.title = @"速易查";
    }
    //设置导航栏title字体类型和大小
    [nav.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:20],NSForegroundColorAttributeName:[UIColor whiteColor],}];
    nav.navigationBar.barTintColor = RGBColor(222, 49, 46, 1);
    
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
