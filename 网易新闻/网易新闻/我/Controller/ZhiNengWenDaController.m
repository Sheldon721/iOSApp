//
//  ZhiNengWenDaController.m
//  网易新闻
//
//  Created by 李晓东 on 2017/8/24.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "ZhiNengWenDaController.h"
#import "FaChuCell.h"
#import "JieShouCell.h"
#import "WenDaModel.h"
@interface ZhiNengWenDaController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITextField *_textField;
    UIView *_footerView;
    UITableView *_tableView;
    NSMutableArray *_modelAry;
    int i;
}
@end

@implementation ZhiNengWenDaController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _modelAry = [NSMutableArray array];
    [self createBiaoShiTu];
    [self createFooterView];
    
    // Do any additional setup after loading the view.
}
#pragma mark - 表视图
- (void)createBiaoShiTu{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-50) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1];;
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[FaChuCell class] forCellReuseIdentifier:@"faCell"];
    [_tableView registerClass:[JieShouCell class] forCellReuseIdentifier:@"jieCell"];
    [_tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}

#pragma mark - datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WenDaModel *model =  _modelAry[indexPath.row];
    //判断是接收的消息还是发送的消息
    if (model.zhuanTai == YES) {
        FaChuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"faCell" forIndexPath:indexPath];
        cell.model = model;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        JieShouCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jieCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        return cell;
    }
    
    
}

#pragma -mark设置单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Class currentClass;
    WenDaModel *model = _modelAry[indexPath.row];
    if (model.zhuanTai == YES) {
        currentClass = [FaChuCell class];
    }
    else{
        currentClass = [JieShouCell class];
    }
    
    
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[UIScreen mainScreen].bounds.size.width];
}


#pragma mark - 发送消息界面
- (void)createFooterView{
    _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight-50, kWidth, 50)];
    _footerView.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1];
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(5, 5, kWidth-10, 40)];
    _textField.delegate = self;
    _textField.backgroundColor = [UIColor whiteColor];
    
    //注册通知监听器，监听键盘弹起事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //注册通知监听器，监听键盘收起事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [_footerView addSubview:_textField];
    [self.view addSubview:_footerView];
}

#pragma mark -键盘弹出调用该方法
- (void)keyboardWillShow:(NSNotification *)notificationP{
    i++;
    if (i==1) {
        //开始视图升起动画
        [UIView beginAnimations:@"keyboardWillShow" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        //获取原视图位置
        CGRect rect = _footerView.frame;
        //用当前位置的y坐标减去键盘高度
        rect.origin.y = rect.origin.y-271;
        //设置视图位置
        _footerView.frame = rect;
        //结束动画
        [UIView commitAnimations];
    }
    
}
#pragma mark -键盘收起调用该方法
- (void)keyboardWillHide:(NSNotification *)notificationP{
    i = 0;
    //开始视图下降动画
    [UIView beginAnimations:@"keyboardWillHide" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //获取原视图位置
    CGRect rect = _footerView.frame;
    rect.origin.y = rect.origin.y+271;
    //设置视图位置
    _footerView.frame = rect;
    //结束动画
    [UIView commitAnimations];
}

#pragma mark - 点击return时调用
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (![textField.text isEqualToString:@""]) {
        WenDaModel *model = [[WenDaModel alloc]init];
        //发送状态
        model.zhuanTai = YES;
        model.content = textField.text;
        [_modelAry addObject:model];
        [_tableView reloadData];
        //----------------请求数据-------------
        NSString *str = [NSString stringWithFormat:@"http://api.jisuapi.com/iqa/query?appkey=%@&question=%@",xwAppKey,textField.text];
        NSString *q = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [AFNTool GET:q parameters:nil success:^(id result) {
            
            WenDaModel *model2 = [[WenDaModel alloc]init];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
            NSDictionary *dictR = dict[@"result"];
            model2.content = dictR[@"content"];
            //接收状态
            model2.zhuanTai = NO;
            [_modelAry addObject:model2];
            //更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        textField.text = @"";
        [textField resignFirstResponder];
    }
    
    return YES;
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
