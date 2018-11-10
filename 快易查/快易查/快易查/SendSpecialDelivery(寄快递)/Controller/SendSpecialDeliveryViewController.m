//
//  SendSpecialDeliveryViewController.m
//  快易查
//
//  Created by 刘超正 on 2017/11/17.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "SendSpecialDeliveryViewController.h"
#import "SendSpecialDeliveryCell.h"
@interface SendSpecialDeliveryViewController ()

/** tableView代理 */
@property (nonatomic,strong) TableViewDelagate *tableViewDelagate;
@end

@implementation SendSpecialDeliveryViewController

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
    [self.tableView registerClass:[SendSpecialDeliveryCell class] forCellReuseIdentifier:@"send"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.scrollEnabled = NO;
    //传值 判断是哪个控制器中的tableview
    self.tableViewDelagate.sendSpecialDeliveryTableView = self;
    [self.view addSubview:self.tableView];
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
