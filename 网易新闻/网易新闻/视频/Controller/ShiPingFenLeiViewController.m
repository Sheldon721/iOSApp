//
//  ShiPingFenLeiViewController.m
//  网易新闻
//
//  Created by 李晓东 on 2017/8/13.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "ShiPingFenLeiViewController.h"
#import "PlayerCell.h"
@interface ShiPingFenLeiViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    BOOL ref;
    int zhi;//请求起始值
    PlayerCell *cell2;
    NSMutableArray *cellMutableArray;//存储cell
}
@end

@implementation ShiPingFenLeiViewController
- (FMDBTool *)dbTool{
    if (_dbTool == nil) {
        _dbTool = [[FMDBTool alloc]init];
    }
    return _dbTool;
}
- (NSMutableArray *)fenLeiModelAry{
    if (_fenLeiModelAry == nil) {
        _fenLeiModelAry = [[NSMutableArray alloc]init];
    }
    return _fenLeiModelAry;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createBiaoShiTu];
    cellMutableArray = [NSMutableArray array];
    [self benDiShuJu:self.title];
    if (self.fenLeiModelAry.count == 0) {
        [_tableView.mj_header beginRefreshing];
    }
    else{
        [_tableView reloadData];
    }
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(returnShiPingViewController)];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGestureRecognizer];
}
//返回上一级控制器
- (void)returnShiPingViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)createBiaoShiTu{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kStatusHeight+kNaviHeight, kWidth, kHeight-kStatusHeight-kNaviHeight-kSafeAreaBottomHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[PlayerCell class] forCellReuseIdentifier:@"cell1"];
    //上下刷新控件
    _tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [AFNTool wangLuoLianJieZhuangTai:^(BOOL zhuang) {
            if (zhuang == YES) {
                ref = YES;
                //请求网络数据
                [self qingQiuShuJu:[NSString stringWithFormat:@"http://c.3g.163.com/nc/video/list/%@/y/0-20.html",_urlStr]];
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
                NSLog(@"%d",zhi);
                [self qingQiuShuJu:[NSString stringWithFormat:@"http://c.3g.163.com/nc/video/list/%@/y/%d-10.html",_urlStr,zhi]];
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
        NSArray *ary = dict[self.urlStr];
        for (NSDictionary *dictModel in ary) {
            ShiPingModel *modelOne = [ShiPingModel mj_objectWithKeyValues:dictModel];
            //判断是否存在数据库   ／／不存在者存入数据库
            [self.dbTool selectTiaoJian:[NSString stringWithFormat:@"select *from b_play where sp_title = '%@'",modelOne.title] andCanShu:@"sp_title"];
            //不存在 则添加到数据库
            if (![self.dbTool.selectTitle isEqualToString:modelOne.title])
            {
                
                //判断是上拉还是下拉
                if (ref == YES) {
                    [self.fenLeiModelAry insertObject:modelOne atIndex:0];
                }
                else{
                    [self.fenLeiModelAry insertObject:modelOne atIndex:self.fenLeiModelAry.count];
                }
                
                [self.dbTool addShuJu:[NSString stringWithFormat:@"insert into b_play (sp_channel,sp_title,sp_description,sp_cover,sp_length,sp_playCount,sp_ptime,sp_mp4_url,sp_topicName,sp_topicImg) values ('%@','%@','%@','%@','%f','%@','%@','%@','%@','%@')",self.title,modelOne.title,modelOne.Description,modelOne.cover,modelOne.length,modelOne.playCount,modelOne.ptime,modelOne.mp4_url,modelOne.topicName,modelOne.topicImg]];
                
                
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
#pragma -mark加载本地数据
- (void)benDiShuJu:(NSString *)str{
    self.fenLeiModelAry = [self.dbTool selectShiPingAll:[NSString stringWithFormat:@"select *from b_play where sp_channel = '%@' order by sp_id desc",str]];
    
}
#pragma - mark 提示框
- (void)createTiShiKuang{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"检查网络设置" message:@"当前无网络，请检查您的网络设置" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma -mark设置单元格每组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fenLeiModelAry.count;
}
#pragma -mark设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    //设置cell的背景颜色
    cell.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1];
    //设置选择cell时 cell无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.fenLeiModelAry[indexPath.row];
    cell.indexPath = indexPath;
    cell.tableView = tableView;
    [cellMutableArray addObject:cell];
    cell.cellMutableArray = cellMutableArray;
    return cell;
}

#pragma -mark设置单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 285;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    for (PlayerCell *cell in cellMutableArray) {
        if (cell.playerState == LCZPlayerStatePlaying) {
            //销毁播放器
            [cell destroyPlayer];
        }
    }
}
////禁止自动转屏
//-(BOOL)shouldAutorotate
//{
//    return NO;
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
