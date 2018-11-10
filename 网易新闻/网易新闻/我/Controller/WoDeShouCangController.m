//
//  WoDeShouCangController.m
//  网易新闻
//
//  Created by 李晓东 on 2017/8/29.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "WoDeShouCangController.h"
#import "ShouCangCell.h"
#import "XinWenXianQingViewController.h"
@interface WoDeShouCangController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tabelView;
    
}
@property (nonatomic ,strong) FMDBTool *dbTool;
@property (nonatomic ,strong) NSMutableArray *modelAry;
@end

@implementation WoDeShouCangController

- (FMDBTool *)dbTool{
    if (_dbTool == nil) {
        _dbTool = [FMDBTool shareTool];
    }
    return _dbTool;
}

- (NSMutableArray *)modelAry{
    if (_modelAry == nil) {
        _modelAry = [NSMutableArray array];
    }
    return _modelAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createBiaoShiTu];
    //取出数据库的数据
    self.modelAry = [self.dbTool selectAllShouCangXinWen:@"select *from b_cang"];
    //更新UI
    [_tabelView reloadData];
}

- (void)createBiaoShiTu{
    _tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, kStatusHeight+kNaviHeight, kWidth, kHeight-kSafeAreaBottomHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tabelView];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    [_tabelView registerClass:[ShouCangCell class] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.modelAry.count == 0){
        return 1;
    }
    else{
       return self.modelAry.count; 
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShouCangCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.modelAry.count == 0) {
        cell.textLabel.text = @"您未收藏任何新闻";
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        return cell;
    }
    else
    {
        XinWenModel *model = self.modelAry[indexPath.row];
        cell.textLabel.text = model.title;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.modelAry.count != 0) {
        XinWenXianQingViewController *xwxq = [[XinWenXianQingViewController alloc]init];
        xwxq.model = self.modelAry[indexPath.row];
        //push后不在显示tabbar控制器
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController showViewController:xwxq sender:nil];
    }
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
