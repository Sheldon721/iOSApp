//
//  YFSearchViewController.m
//  officialDemoNavi
//
//  Created by李晓东 on 2017/12/14.
//  Copyright © 2017年 李晓东. All rights reserved.
//

#import "YFSearchViewController.h"
#import "YFSearchShowView.h"
#import "YFHistoryTools.h"
#import "MapManager.h"
@interface YFSearchViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *field;//输入框
@property(nonatomic,strong)UIButton *currentBtn;//按钮
@property(nonatomic,strong)UIButton *returnBtn;//返回按钮
@end

@implementation YFSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //不管做什么地图操作都先定位自己的位置
    [self locationOnlySelf];
    
    //视图加载
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(16, 60, CGRectGetWidth(self.view.frame) - 32, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    self.field = [[UITextField alloc]initWithFrame:CGRectMake(16, 0, CGRectGetWidth(headerView.frame) - 16, 40)];
    self.field.borderStyle = UITextBorderStyleNone;
    self.field.font = [UIFont systemFontOfSize:14];
    self.field.delegate = self;
    self.field.placeholder = @"请输入地点";
    [headerView addSubview:self.field];
    
    //阴影
    headerView.layer.cornerRadius = 5;
    headerView.layer.shadowOpacity = 0.5;// 阴影透明度
    headerView.layer.shadowColor = [UIColor lightGrayColor].CGColor;// 阴影的颜色
    headerView.layer.shadowRadius = 3;// 阴影扩散的范围控制
    
    //搜索图标展示
    YFSearchShowView *showView = [YFSearchShowView createShowView];
    showView.frame = CGRectMake(16, 105, CGRectGetWidth(self.view.frame) - 32, 80);
    __block typeof(self)weakSelf = self;
    showView.searchBlock = ^(NSString *str) {
      
        //保存数据
        weakSelf.field.text = str;
        [[MapManager sharedManager] searchAroundWithKeyWords:str];
    };
    [self.view addSubview:showView];
    
    //回到原位按钮
    self.currentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.currentBtn.frame = CGRectMake(8, CGRectGetHeight(self.view.frame) - 80, 40, 40);
    [self.currentBtn setImage:[UIImage imageNamed:@"current"] forState:UIControlStateNormal];
    [self.currentBtn addTarget:self action:@selector(clickCurrentBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.currentBtn];
    
    //返回按钮
    self.returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.returnBtn.frame = CGRectMake(16, 20, 30, 30);
    self.returnBtn.layer.cornerRadius = 15;
    self.returnBtn.layer.shadowOpacity = 0.5;// 阴影透明度
    self.returnBtn.layer.shadowColor = [UIColor lightGrayColor].CGColor;// 阴影的颜色
    self.returnBtn.layer.shadowRadius = 3;// 阴影扩散的范围控制
    self.returnBtn.backgroundColor = [UIColor whiteColor];
    [self.returnBtn setImage:[UIImage imageNamed:@"ic_arrow_right"] forState:UIControlStateNormal];
    [self.returnBtn addTarget:self action:@selector(clickReturnBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.returnBtn];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    //默认定一次位置
    [self performSelector:@selector(clickCurrentBtn) withObject:nil afterDelay:1.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//显示自己的定位信息
-(void)locationOnlySelf{
    MapManager *manager = [MapManager sharedManager];
    manager.controller = self;
    [manager initMapView];
}

//按钮事件
- (void)clickCurrentBtn{
    
    //返回原点
    [MapManager sharedManager].returnCurrent = YES;
}

//返回按钮
- (void)clickReturnBtn{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.text.length <= 0) {
        
        return NO;//输入为空
    }
    [[MapManager sharedManager] searchAroundWithKeyWords:textField.text];
    [textField resignFirstResponder];
    return YES;
}
@end
