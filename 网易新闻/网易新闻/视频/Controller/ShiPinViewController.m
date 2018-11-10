//
//  ShiPinViewController.m
//  网易新闻
//
//  Created by 李晓东 on 2017/6/20.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "ShiPinViewController.h"
#import "PlayerCell.h"
#import "ShiPingModel.h"
#import "ShiPingFenLeiViewController.h"
@interface ShiPinViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_imgAry;//图片数组
    NSArray *_titleAry;//标题数组
    NSMutableArray *_modelAry;//储存模型的数组
    BOOL ref;//判断上下刷新
    int zhi;//请求起始值
    PlayerCell *_cell;
    int y;
    CGRect cellR;
    /** 存储所有cell的数组  */
    NSMutableArray *cellMutableArray;//存储cell
}
@end

@implementation ShiPinViewController
- (FMDBTool *)dbTool{
    if (_dbTool == nil) {
        _dbTool = [[FMDBTool alloc]init];
    }
    return _dbTool;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createAry];
    [self createBiaoShiTu];
    _modelAry = [NSMutableArray array];
    cellMutableArray = [NSMutableArray array];
    //创建视频表
    [self.dbTool createBiao:@"create table if not exists b_play(sp_id integer primary key autoincrement,sp_channel text not null,sp_title text not null,sp_description text not null,sp_cover text not null,sp_length float not null,sp_playCount text,sp_ptime text not null,sp_mp4_url text not null,sp_topicName text not null,sp_topicImg text not null)"];
    //删除表
    // [self.dbTool deleteBiao:@"drop table b_news"];
    [self benDiShuJu:@"无"];
    if (_modelAry.count == 0) {
        [_tableView.mj_header beginRefreshing];
    }
    else{
        
        [_tableView reloadData];
    }
    
    
}
#pragma -mark创建表视图
- (void)createBiaoShiTu{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kStatusHeight+kNaviHeight, kWidth, kHeight-kStatusHeight-kNaviHeight-kTabBarHeight) style:UITableViewStylePlain];
    //简单点说就是automaticallyAdjustsScrollViewInsets根据按所在界面的status bar，navigationbar，与tabbar的高度，自动调整scrollview的 inset,设置为no，不让viewController调整，我们自己修改布局即可
    if (@available(ios 11.0,*)) {
        
    }
    else{
       self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = [self createBiaoTouView];
    [_tableView registerClass:[PlayerCell class] forCellReuseIdentifier:@"cell"];
    //上下刷新控件
    _tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [AFNTool wangLuoLianJieZhuangTai:^(BOOL zhuang) {
            if (zhuang == YES) {
                ref = YES;
                //请求网络数据
                [self qingQiuShuJu:@"http://c.m.163.com/nc/video/home/0-10.html"];
            }
            else{
                [_tableView.mj_header endRefreshing];
                [self createTiShiKuang];
                
            }
        }];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [AFNTool wangLuoLianJieZhuangTai:^(BOOL zhuang) {
            if (zhuang == YES) {
                ref = NO;
                //请求网络数据
                zhi += 1;
                [self qingQiuShuJu:[NSString stringWithFormat:@"http://c.m.163.com/nc/video/home/%d-10.html",zhi]];
            }
            else{
                [_tableView.mj_footer endRefreshing];
                [self createTiShiKuang];
            }
        }];
    }];
}
#pragma -mark请求网络数据
- (void)qingQiuShuJu:(NSString *)str{
    [AFNTool GET:str parameters:nil success:^(id result) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        NSArray *ary = dict[@"videoList"];
        for (NSDictionary *dictModel in ary) {
            ShiPingModel *modelOne = [ShiPingModel mj_objectWithKeyValues:dictModel];
            //判断是否存在数据库   ／／不存在者存入数据库
            //查找数据库 是否存在此数据
            [self.dbTool selectTiaoJian:[NSString stringWithFormat:@"select *from b_play where sp_title = '%@'",modelOne.title] andCanShu:@"sp_title"];
            //不存在 则添加到数据库
            if (![self.dbTool.selectTitle isEqualToString:modelOne.title])
            {
                //判断是上拉还是下拉
                if (ref == YES) {
                    [_modelAry insertObject:modelOne atIndex:0];
                }
                else{
                    [_modelAry insertObject:modelOne atIndex:_modelAry.count];
                }
                
                [self.dbTool addShuJu:[NSString stringWithFormat:@"insert into b_play (sp_channel,sp_title,sp_description,sp_cover,sp_length,sp_playCount,sp_ptime,sp_mp4_url,sp_topicName,sp_topicImg) values ('%@','%@','%@','%@','%f','%@','%@','%@','%@','%@')",@"无",modelOne.title,modelOne.Description,modelOne.cover,modelOne.length,modelOne.playCount,modelOne.ptime,modelOne.mp4_url,modelOne.topicName,modelOne.topicImg]];
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新ui
            [_tableView reloadData];
            //结束上下刷新
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        });
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma -mark创建表头视图
- (UIView *)createBiaoTouView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, kStatusHeight+kNaviHeight, kWidth, 100)];
    
    view.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1];
    [self createBtn:view];
    return view;
}
#pragma -mark创建数组
- (void)createAry{
    _imgAry = @[@"jingpin.png",@"meiv.png",@"mengchong.png",@"qipa.png"];
    _titleAry = @[@"精品",@"美女",@"萌宠",@"奇葩"];
}
//创建按钮和标题
- (void)createBtn:(UIView *)view{
    for (int i = 0; i<4; i++) {
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(1+kWidth/4*i, 0, kWidth/4-1, 98)];
        view2.backgroundColor = [UIColor whiteColor];
        [view addSubview:view2];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame =CGRectMake((kWidth/4-10)/2-20, 10, 40, 40);
        btn.backgroundColor = [UIColor whiteColor];
        [btn setImage:[UIImage imageNamed:_imgAry[i]] forState:UIControlStateNormal];
        btn.tag = 100 +i;
        [btn addTarget:self action:@selector(tiaoZhuan:) forControlEvents:UIControlEventTouchUpInside];
        [view2 addSubview:btn];
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, kWidth/4-10, 30)];
        [lbl setText:_titleAry[i]];
        [lbl setTextColor:[UIColor blackColor]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [view2 addSubview:lbl];
        
    }
    
}
#pragma -mark加载本地数据
- (void)benDiShuJu:(NSString *)str{
    _modelAry = [self.dbTool selectShiPingAll:[NSString stringWithFormat:@"select *from b_play where sp_channel = '%@' order by sp_id desc",str]];
}
#pragma - mark 提示框
- (void)createTiShiKuang{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"检查网络设置" message:@"当前无网络，请检查您的网络设置" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)tiaoZhuan:(UIButton *)sender{
    if (sender.tag == 100) {
        [self present:@"精品" andUrlStr:@"VAP4BGTVD"];
    }
    else if (sender.tag == 101){
        [self present:@"美女" andUrlStr:@"VAP4BG6DL"];
    }
    else if (sender.tag == 102){
        [self present:@"萌宠" andUrlStr:@"VAP4BFR16"];
    }
    else if (sender.tag == 103){
        [self present:@"奇葩" andUrlStr:@"VAP4BFE3U"];
    }
}
- (void)present:(NSString *)title andUrlStr:(NSString *)str{
    ShiPingFenLeiViewController *spflvc = [[ShiPingFenLeiViewController alloc]init];
    spflvc.title = title;
    spflvc.urlStr = str;
    //push后不在显示tabbar控制器
    self.hidesBottomBarWhenPushed = YES;
    [self presentViewController:spflvc animated:YES completion:nil];
    //[self.navigationController showViewController:spflvc sender:nil];
    //返回后把tabbar控制器显示
    self.hidesBottomBarWhenPushed = NO;
}
#pragma -mark设置单元格每组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelAry.count;
}
#pragma -mark设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    _cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //设置cell的背景颜色
    _cell.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1];
    //设置选择cell时 cell无色
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    _cell.model = _modelAry[indexPath.row];
    _cell.indexPath = indexPath;
    _cell.tableView = tableView;
    [cellMutableArray addObject:_cell];
    _cell.cellMutableArray = cellMutableArray;
    return _cell;
}

#pragma -mark设置单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    return 285;
}
#pragma -mark 视图消失
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    for (PlayerCell *cell in cellMutableArray) {
        if (cell.playerState == LCZPlayerStatePlaying) {
            //还原播放器
            [cell restorenitialUI:nil];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////禁止自动转屏
//-(BOOL)shouldAutorotate
//{
//    return YES;
//}
////默认方向
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationPortrait;
//}
////设备支持方向
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskAll;
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
