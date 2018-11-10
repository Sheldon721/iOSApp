//
//  WoViewController.m
//  网易新闻
//
//  Created by 李晓东 on 2017/6/20.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "WoViewController.h"
#import "WoCell.h"
#import "DengLuOrZhuCeController.h"
#import "ZhiNengWenDaController.h"
#import "SaoYiSaoController.h"
#import "WoDeShouCangController.h"

@interface WoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_woTableView;
    NSUserDefaults *_user;//偏好设置
    
}
@property (nonatomic, strong) NSMutableArray *cellAry;
@property (nonatomic, strong) FMDBTool *dbTool;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CADisplayLink *displayLink;//计时器

//使用波形曲线y=Asin(ωx+φ)+k进行绘制
@property (assign ,nonatomic)CGFloat zoomY;// 波纹振幅A
@property (assign ,nonatomic)CGFloat translateX;// 波浪水平位移 Φ
@property (assign ,nonatomic)CGFloat currentWavePointY;// 波浪当前的高度 k
@end

@implementation WoViewController

- (FMDBTool *)dbTool{
    if (_dbTool == nil) {
        _dbTool = [[FMDBTool alloc]init];
    }
    return _dbTool;
}
- (CAShapeLayer *)shapeLayer{
    if (_shapeLayer == nil) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = [UIColor colorWithRed:213/255.0 green:43/255.0 blue:51/255.0 alpha:.8].CGColor;
    }
    return _shapeLayer;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(ios 11.0,*)) {
        
    }
    else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //创建用户表
    [self.dbTool createBiao:@"create table if not exists b_user(yh_id integer primary key autoincrement,yh_name text not null,yh_zhanghao text not null,yh_pws text not null)"];
    //删除表
    //[self.dbTool deleteBiao:@"drop table b_user"];
}
//隐藏导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //保存账号密码
    _user = [NSUserDefaults standardUserDefaults];
    //判断偏好设置中是否存在用户数据
    if ([_user objectForKey:@"Name"] && [_user objectForKey:@"Psw"] && [_user objectForKey:@"ZhangHao"]) {
        self.zhuangTai = YES;
    }
    else{
        self.zhuangTai = NO;
    }
    if (self.zhuangTai == YES) {
        _cellAry = [NSMutableArray arrayWithObjects:@"我的收藏",@"智能问答",@"扫一扫",@"清理缓存",@"注销", nil];
    }
    else{
        _cellAry = [NSMutableArray arrayWithObjects:@"我的收藏",@"智能问答",@"扫一扫",@"清理缓存",@"未登录", nil];
    }
    //创建表视图
    [self createBiaoShiTu];
   // NSLog(@"%@",);
   
}
#pragma mark - 创建表视图
- (void)createBiaoShiTu{
    _woTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-self.tabBarController.tabBar.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:_woTableView];
    _woTableView.delegate = self;
    _woTableView.dataSource = self;
    _woTableView.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1];
    [_woTableView registerClass:[WoCell class] forCellReuseIdentifier:@"cell"];
    //设置表头视图
    UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 200)];
    viewHeader.backgroundColor = [UIColor colorWithRed:223.0/255 green:66.0/255 blue:66.0/255 alpha:1];
    //绘制水波纹动画
    [viewHeader.layer addSublayer:self.shapeLayer];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(Wave:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    //设置波纹高度
    self.currentWavePointY = 50;
    //设置振幅
    self.zoomY = 10.0;
    
    
    if (self.zhuangTai == YES) {
        //头像
        self.touXiang = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2-50, viewHeader.frame.size.height/2-60, 100, 100)];
        [self.touXiang sd_setImageWithURL:[NSURL URLWithString:[_user objectForKey:@"Image"]] placeholderImage:[UIImage imageNamed:@"user_defaultavatar@2x.png"]];
        self.touXiang.layer.cornerRadius = 50;
        self.touXiang.layer.masksToBounds = YES;
        //昵称
        self.niChen = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-70, viewHeader.frame.size.height-50, 140, 40)];
        self.niChen.text = [_user objectForKey:@"Name"];
        [self.niChen setTextAlignment:NSTextAlignmentCenter];
        [self.niChen setFont:[UIFont systemFontOfSize:20]];
        [viewHeader addSubview:self.touXiang];
        [viewHeader addSubview:self.niChen];
    }
    else{
        //登陆按钮
        self.dengLu = [UIButton buttonWithType:UIButtonTypeCustom];
        self.dengLu.frame = CGRectMake(10, viewHeader.frame.size.height/2-20, 100, 40);
        [self.dengLu setTitle:@"立即登录" forState:UIControlStateNormal];
        [self.dengLu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.dengLu.tag = 100;
        [self.dengLu addTarget:self action:@selector(dengLuOrZhuCe:) forControlEvents:UIControlEventTouchUpInside];
        //注册按钮
        self.zhuCe = [UIButton buttonWithType:UIButtonTypeCustom];
        self.zhuCe.frame = CGRectMake(kWidth-110, viewHeader.frame.size.height/2-20, 100, 40);
        [self.zhuCe setTitle:@"注册" forState:UIControlStateNormal];
        [self.zhuCe setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.zhuCe.tag = 101;
        [self.zhuCe addTarget:self action:@selector(dengLuOrZhuCe:) forControlEvents:UIControlEventTouchUpInside];
        //添加在视图上
        [viewHeader addSubview:self.zhuCe];
        [viewHeader addSubview:self.dengLu];
    }
   
    
    _woTableView.tableHeaderView = viewHeader;
}

#pragma mark - 水波纹
- (void)Wave:(CADisplayLink *)link{
    self.translateX += 0.1;
    //实例化贝塞尔曲线
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    //设置起点
    [bezierPath moveToPoint:CGPointMake(0, self.currentWavePointY)];
    //初始化y值
    CGFloat y = 0.0f;
    CGFloat z = 0.0f;
    //绘制点
    for (int x = 0; x<=self.view.frame.size.width; x++) {
        //正弦函数 y=Asin(ωx+φ）+ k
        y = self.zoomY * sin(2*M_PI/self.view.frame.size.width * x + self.translateX) + self.currentWavePointY;
        [bezierPath addLineToPoint:CGPointMake(x, y)];
        z = self.zoomY * sin(2*M_PI/self.view.frame.size.width * x + self.translateX+15) + self.currentWavePointY;
    }
    //附加一条直线到接收器的路径
    [bezierPath addLineToPoint:CGPointMake(self.view.frame.size.width, 200)];
    [bezierPath addLineToPoint:CGPointMake(0, 200)];
    [bezierPath closePath];
    self.shapeLayer.path = bezierPath.CGPath;
}

#pragma mark - 登陆／注册
- (void)dengLuOrZhuCe:(UIButton *)sender{
    self.hidesBottomBarWhenPushed = YES;
    DengLuOrZhuCeController *dlzc = [[DengLuOrZhuCeController alloc]init];
    if (sender.tag == 100) {
        dlzc.title = @"登录网易新闻";
    }
    else{
        dlzc.title = @"注册网易通行证";
    }
    dlzc.woC = self;
    dlzc.btn = sender;
    [self.navigationController pushViewController:dlzc animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}











- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
#pragma mark - dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return self.cellAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //设置向右的箭头
    if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.cellAry[indexPath.section];
    return cell;
}
#pragma mark - 单击cell事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self shouCang];
    }
    else if (indexPath.section == 1) {
        if (self.zhuangTai == YES) {
            [self zhiNengWenDa];
        }
        else{
            [self dengLuZhuangTai:@"提示" andMessage:@"您当前尚未登录"];
        }
        
    }
    else if (indexPath.section == 2){
        [self saoYiSao];
    }
    else if (indexPath.section == 3){
        [self qingChuHuanCun];
    }
    else{
        if (self.zhuangTai == YES) {
            [self zhuXiao];
        }
        else{
            
        }
        
    }
}
#pragma mark - 弹窗
- (void)dengLuZhuangTai:(NSString *)title andMessage:(NSString *)message{
    UIAlertController *aC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *queDing = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.hidesBottomBarWhenPushed = YES;
        //进入登录界面
        DengLuOrZhuCeController *denglu = [[DengLuOrZhuCeController alloc]init];
        //创建进入登录界面的条件
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 100;
        denglu.btn = btn;
        [self.navigationController pushViewController:denglu animated:NO];
        self.hidesBottomBarWhenPushed = NO;
        
    }];
    UIAlertAction *quXiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [aC addAction:queDing];
    [aC addAction:quXiao];
    [self presentViewController:aC animated:YES completion:nil];
}
#pragma mark - 我的收藏
- (void)shouCang{
    self.hidesBottomBarWhenPushed = YES;
    WoDeShouCangController *wdsc = [[WoDeShouCangController alloc]init];
    wdsc.title = @"我的收藏";
    [self.navigationController pushViewController:wdsc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
#pragma mark - 智能问答
- (void)zhiNengWenDa{
    self.hidesBottomBarWhenPushed = YES;
    ZhiNengWenDaController *znwd = [[ZhiNengWenDaController alloc]init];
    znwd.title = @"智能问答";
    [self.navigationController pushViewController:znwd animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}
#pragma mark - 扫一扫
- (void)saoYiSao{
    self.hidesBottomBarWhenPushed = YES;
    SaoYiSaoController *sys = [[SaoYiSaoController alloc]init];
    sys.title = @"扫一扫";
    [self.navigationController pushViewController:sys animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}
#pragma mark - 清除缓存
- (void)qingChuHuanCun{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
    NSString *cachesDir = [paths lastObject];
    //计算缓存
    CGFloat fl = [self folderSizeAtPath:cachesDir];
    //创建提示框
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"确定清空网易新闻本地缓存数据？" message:[NSString stringWithFormat:@"缓存大小:%0.2lfM",fl] preferredStyle:UIAlertControllerStyleActionSheet];
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

#pragma mark - 注销
- (void)zhuXiao{
    //删除偏好设置存的数据
    [_user removeObjectForKey:@"Name"];
    [_user removeObjectForKey:@"Psw"];
    [_user removeObjectForKey:@"ZhangHao"];
    //
    WoViewController *wo = [[WoViewController alloc]init];
    [self.navigationController pushViewController:wo animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    //销毁计时器
    self.displayLink.paused = NO;
    [self.displayLink invalidate];
    self.displayLink = nil;
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
