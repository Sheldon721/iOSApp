//
//  UserViewController.m
//  SF_GaoDeMAP
//
//  Created by李晓东 on 2017/12/14.
//  Copyright © 2017年 ShouNew.com. All rights reserved.
//

#import "UserViewController.h"
#import "UserCell.h"
#import "MessageViewController.h"
static NSString *u_cell = @"UserCell";
@interface UserViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;//表
@property(nonatomic,strong)NSArray *dataArray;//数据
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的";
    //加载数据表
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:u_cell bundle:nil] forCellReuseIdentifier:u_cell];
    [self.view addSubview:self.tableView];
    [self loadHeaderView];
    
    self.dataArray = @[@"信息中心",@"行走助手",@"反馈",@"关于",@"设置",@"退出"];
}
//界面显示的时候
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
//界面消失的时候
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//添加表头
- (void)loadHeaderView{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200)];
    self.tableView.tableHeaderView = headerView;
    //头像
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 100) / 2, 50, 100, 100)];
    icon.image = [UIImage imageNamed:@"user"];
    icon.layer.cornerRadius= 50;
    icon.layer.cornerRadius = 5;
    icon.layer.shadowOpacity = 0.5;// 阴影透明度
    icon.layer.shadowColor = [UIColor lightGrayColor].CGColor;// 阴影的颜色
    icon.layer.shadowRadius = 3;// 阴影扩散的范围控制
    [headerView addSubview:icon];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:u_cell forIndexPath:indexPath];
    cell.nameLabel.text = self.dataArray[indexPath.row];
    cell.icon.image = [UIImage imageNamed:@"历史"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0f;
}
@end
