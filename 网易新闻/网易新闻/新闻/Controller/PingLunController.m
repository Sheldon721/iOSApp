//
//  PingLunController.m
//  网易新闻
//
//  Created by 李晓东 on 2017/8/29.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "PingLunController.h"
#import "PingLunCell.h"
@interface PingLunController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
}
@property (nonatomic ,strong) FMDBTool *dbTool;
@property (nonatomic ,strong) NSMutableArray *modelAry;
@end

@implementation PingLunController

- (FMDBTool *)dbTool{
    if (_dbTool == nil) {
        _dbTool = [FMDBTool shareTool];
    }
    return _dbTool;
}

-(NSMutableArray *)modelAry{
    if (_modelAry == nil) {
        _modelAry = [NSMutableArray array];
    }
    return _modelAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self createBiaoShiTu];
    self.modelAry = [self.dbTool selectPingLunAll:[NSString stringWithFormat:@"select *from b_ping where pl_title = '%@'",self.name]];
    [_tableView reloadData];
}

- (void)createBiaoShiTu{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kStatusHeight+kNaviHeight, kWidth, kHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[PingLunCell class] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PingLunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.modelAry[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma -mark设置单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PingLunModel *model = self.modelAry[indexPath.row];

    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[PingLunCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
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
