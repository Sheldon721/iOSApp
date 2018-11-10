//
//  QueryCourierViewController.m
//  快易查
//
//  Created by 刘超正 on 2017/11/17.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "QueryCourierViewController.h"
#import "QueryCourierCell.h"
@interface QueryCourierViewController ()
/** tableView代理 */
@property (nonatomic,strong) TableViewDelagate *tableViewDelagate;

@end

@implementation QueryCourierViewController

#pragma mark - tableView代理懒加载
- (TableViewDelagate *)tableViewDelagate{
    if (_tableViewDelagate == nil) {
        _tableViewDelagate = [[TableViewDelagate alloc]init];
    }
    return _tableViewDelagate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建tableView
    [self createTableView];
}

#pragma mark - 创建tableView
- (void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kStatusHeight+kNaviHeight, kWidth, kHeight-kStatusHeight-kNaviHeight-kTabBarHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGBColor(250, 250, 249, 1);
    self.tableView.delegate = self.tableViewDelagate;
    self.tableView.dataSource = self.tableViewDelagate;
    [self.tableView registerClass:[QueryCourierCell class] forCellReuseIdentifier:@"query"];
    self.tableView.scrollEnabled = NO;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //传值
    self.tableViewDelagate.queryCourierTableView = self;
    [self.view addSubview:self.tableView];
    
    //单击手势  隐藏键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.tableView addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - 单击tableView时调用。隐藏键盘
- (void)tap{
    [self.tableView endEditing:YES];
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
