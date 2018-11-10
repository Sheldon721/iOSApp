//
//  feedbackViewController.m
//  快易查
//
//  Created by 刘超正 on 2017/11/22.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "feedbackViewController.h"

@interface feedbackViewController ()
{
    UIView *_dividingLine;
}
@property(nonatomic,strong) UIButton *submit;
@end

@implementation feedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createHeaderUI];
    [self createMainUI];
}

#pragma mark - 头部
- (void)createHeaderUI{
    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:cancelButton];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelMethod:) forControlEvents:UIControlEventTouchUpInside];
    //title
    UILabel *title = [[UILabel alloc]init];
    [self.view addSubview:title];
    title.text = @"意见反馈";
    //分割线
    _dividingLine = [[UIView alloc]init];
    [self.view addSubview:_dividingLine];
    _dividingLine.backgroundColor = RGBColor(199, 199, 199, 1);
    //约束
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).offset(20);
        make.height.width.equalTo(@40);
        
    }];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    [_dividingLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@1);
    }];
}

- (void)createMainUI{
    //输入框
    UITextView *textView = [[UITextView alloc]init];
    textView.layer.borderWidth = 1;
    textView.layer.borderColor = RGBColor(199, 199, 199, 1).CGColor;
    [textView setFont:[UIFont systemFontOfSize:20]];
    [self.view addSubview:textView];
    //提交反馈按钮
    self.submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.submit];
    [self.submit setTitle:@"提交反馈" forState:UIControlStateNormal];
    [self.submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submit.backgroundColor = RGBColor(199, 199, 199, 1);
    //约束
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dividingLine.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(@300);
    }];
    [self.submit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_bottom).offset(40);
        make.left.right.equalTo(textView);
        make.height.equalTo(@40);
    }];
}


#pragma mark - 点击取消时调用
- (void)cancelMethod:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
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
