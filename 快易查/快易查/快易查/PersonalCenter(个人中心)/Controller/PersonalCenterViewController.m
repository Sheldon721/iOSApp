//
//  PersonalCenterViewController.m
//  快易查
//
//  Created by 刘超正 on 2017/11/17.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "PersonalCenterCell.h"
#import "LoginViewController.h"
#import "feedbackViewController.h"
@interface PersonalCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UIButton *loginButton;
@property(nonatomic,strong) NSArray *notLogged;
@property(nonatomic,strong) NSUserDefaults *userDefaults;
@property(nonatomic,assign) BOOL state; //登录状态
@end

@implementation PersonalCenterViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    if ([self.userDefaults objectForKey:@"Image"] && [self.userDefaults objectForKey:@"Tel"] && [self.userDefaults objectForKey:@"Psw"]) {
        NSLog(@"%@",[self.userDefaults objectForKey:@"Image"]);
        self.loginButton.enabled = NO;
        [self.loginButton setImage:[UIImage imageNamed:[self.userDefaults objectForKey:@"Image"]] forState:UIControlStateNormal];
        [self.loginButton setTitle:[self.userDefaults objectForKey:@"Tel"] forState:UIControlStateNormal];
        self.notLogged = [NSArray arrayWithObjects:@"意见反馈",@"帮助",@"清除缓存",@"注销", nil];
        [self.tableView reloadData];
        self.state = YES;
    }
    else{
        self.notLogged = [NSArray arrayWithObjects:@"意见反馈",@"帮助",@"清除缓存",@"未登录", nil];
        [self.tableView reloadData];
        self.state = NO;
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //创建tableView
    [self createTableView];
}

#pragma mark - 创建tableView
- (void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGBColor(240, 193, 183, 1);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[PersonalCenterCell class] forCellReuseIdentifier:@"personal"];
    self.tableView.scrollEnabled = NO;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 60;
    //设置表头视图
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth * 0.5, 150)];
    //登录按钮
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerView addSubview:self.loginButton];
    self.loginButton.frame = CGRectMake(kWidth * 0.5 *0.5 - 45, 30, 100, 100);
    [self.loginButton setImage:[UIImage imageNamed:@"user_defaultavatar"] forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton setTitle:@"登录快易查" forState:UIControlStateNormal];
    //设置图片和文字位置
    [self.loginButton setTitleEdgeInsets:UIEdgeInsetsMake(50, -self.loginButton.imageView.bounds.size.width, 5, 0)];
    [self.loginButton setImageEdgeInsets:UIEdgeInsetsMake(5, 25, 45, 25)];
    //设置文字大小
    [self.loginButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    //设置颜色
    [self.loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //分割线
    UIView *dividingLine = [[UIView alloc]initWithFrame:CGRectMake(0, 149, headerView.frame.size.width, 1)];
    [headerView addSubview:dividingLine];
    dividingLine.backgroundColor = RGBColor(240, 220, 208, 1);
    
    self.tableView.tableHeaderView = headerView;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.notLogged.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personal" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.postingImgV.backgroundColor = [UIColor redColor];
        cell.title.text = self.notLogged[0];
    }
    else if (indexPath.row == 1){
        cell.postingImgV.backgroundColor = [UIColor yellowColor];
        cell.title.text = self.notLogged[1];
    }
    else if (indexPath.row == 2){
        cell.postingImgV.backgroundColor = [UIColor grayColor];
        cell.title.text = self.notLogged[2];
    }
    else{
        cell.postingImgV.backgroundColor = [UIColor purpleColor];
        cell.title.text = self.notLogged[3];
    }
    return cell;
}

#pragma mark - 点击cell事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        feedbackViewController *fVC = [[feedbackViewController alloc]init];
        [self presentViewController:fVC animated:YES completion:nil];
    }
    else if (indexPath.row == 1){
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"请联系管理员" message:@"QQ:XXXXXXXXXX" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:action];
        [self presentViewController:alertC animated:YES completion:nil];
    }
    else if (indexPath.row == 2){
        [self qingChuHuanCun];
    }
    else if (indexPath.row == 3){
        if (self.state == YES) {
            [self.userDefaults removeObjectForKey:@"Image"];
            [self.userDefaults removeObjectForKey:@"Tel"];
            [self.userDefaults removeObjectForKey:@"Psw"];
            self.loginButton.enabled = YES;
            self.notLogged = [NSArray arrayWithObjects:@"意见反馈",@"帮助",@"清除缓存",@"未登录", nil];
            [self.loginButton setImage:[UIImage imageNamed:@"user_defaultavatar"] forState:UIControlStateNormal];
            [self.loginButton setTitle:@"登录快易查" forState:UIControlStateNormal];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - 清除缓存
- (void)qingChuHuanCun{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
    NSString *cachesDir = [paths lastObject];
    //计算缓存
    CGFloat fl = [self folderSizeAtPath:cachesDir];
    //创建提示框
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"是否清空快易查本地缓存数据？" message:[NSString stringWithFormat:@"缓存大小:%0.2lfM",fl] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *queDing = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cleanCaches:cachesDir];
    }];
    UIAlertAction *quXiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:queDing];
    [alertC addAction:quXiao];
    [self presentViewController:alertC animated:YES completion:nil];
}
//计算目录大小
- (CGFloat)folderSizeAtPath:(NSString *)path{
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        // 目录下的文件计算大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        //SDWebImage的缓存计算
        size += [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        // 将大小转化为M
        return size / 1024.0 / 1024.0;
    }
    return 0;
}
//清除缓存
- (void)cleanCaches:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childrenFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childrenFiles) {
            // 拼接路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            // 将文件删除
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    //SDWebImage的清除功能
    [[SDImageCache sharedImageCache] clearMemory];
    [SDCycleScrollView clearImagesCache];
}

#pragma mark - 点击登录按钮时调用
- (void)loginMethod:(UIButton *)sender{
    LoginViewController *lVC = [[LoginViewController alloc]init];
    [self presentViewController:lVC animated:YES completion:nil];
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
