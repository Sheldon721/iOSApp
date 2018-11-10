//
//  YindaoyeController.m
//  网易新闻
//
//  Created by 李晓东 on 2017/6/20.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "YindaoyeController.h"
#import "TabBarController.h"
@interface YindaoyeController ()
{
    NSTimer *_timer;
}
@end

@implementation YindaoyeController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    [self.view addSubview:imgV];
    imgV.image = [UIImage imageNamed:@"yindaoye.png"];
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(jiShi) userInfo:nil repeats:NO];
}
- (void)jiShi{
    TabBarController *tabbar = [[TabBarController alloc]init];
    [self presentViewController:tabbar animated:YES completion:nil];
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
