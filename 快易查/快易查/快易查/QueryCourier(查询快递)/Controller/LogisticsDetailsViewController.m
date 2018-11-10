//
//  LogisticsDetailsViewController.m
//  快易查
//
//  Created by 刘超正 on 2017/11/19.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "LogisticsDetailsViewController.h"
#import "LogisticsDetailsCell.h"
#import "QueryCourierModel.h"
@interface LogisticsDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation LogisticsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //创建tableView
    [self createTableView];
}

#pragma mark - 创建tableView
- (void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kStatusHeight+kNaviHeight, kWidth, kHeight-kStatusHeight-kNaviHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[LogisticsDetailsCell class] forCellReuseIdentifier:@"logistics"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LogisticsDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"logistics" forIndexPath:indexPath];
    cell.model = self.modelAry[indexPath.row];
    if (indexPath.row == 0) {
        cell.time.textColor = RGBColor(254, 132, 36, 1);
        cell.status.textColor = RGBColor(254, 132, 36, 1);
        cell.straightLine.backgroundColor = RGBColor(254, 132, 36, 1);
        cell.dot.backgroundColor = RGBColor(254, 132, 36, 1);
    }
    
    return cell;
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
