//
//  registrationViewController.m
//  快易查
//
//  Created by 刘超正 on 2017/11/22.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "registrationViewController.h"

@interface registrationViewController ()
{
    NSMutableArray *accountAry;
}
@property(nonatomic,strong) UITextField *numberTextField;//手机号码
@property(nonatomic,strong) UIButton *registrationButton;//下一步
@property(nonatomic,strong) UITextField *passwordField;//密码
@property(nonatomic,strong) NSString *file;//plist路径
@property(nonatomic,strong) NSFileManager *manager;
@end

@implementation registrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self  createHeaderUI];
    [self createMainUI];
    //创建文件管理器
    self.manager = [NSFileManager defaultManager];
    //获取沙盒路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //创建plist文件
    self.file = [path stringByAppendingPathComponent:@"account.plist"];
    // Do any additional setup after loading the view.
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
    title.text = @"注册";
    //分割线
    UIView *dividingLine = [[UIView alloc]init];
    [self.view addSubview:dividingLine];
    dividingLine.backgroundColor = RGBColor(199, 199, 199, 1);
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
    [dividingLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    
}

#pragma mark -点击取消时调用
- (void)cancelMethod:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -主控件
- (void)createMainUI{
    //提示
    UILabel *promptingLabel = [[UILabel alloc]init];
    [self.view addSubview:promptingLabel];
    promptingLabel.text = @"请输入手机号码进行注册";
    [promptingLabel setTextColor:RGBColor(100, 99, 100, 1)];
    //背景框
    UIView *dividingLine = [[UIView alloc]init];
    [self.view addSubview:dividingLine];
    dividingLine.layer.borderWidth = 1;
    dividingLine.layer.borderColor = RGBColor(192, 191 , 198, 1).CGColor;
    //手机号码
    self.numberTextField = [[UITextField alloc]init];
    [dividingLine addSubview:self.numberTextField];
    self.numberTextField.placeholder = @"请输入手机号码";
    //添加通知监听文本框的值
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.numberTextField];
    //背景框2
    UIView *dividingLineTwo = [[UIView alloc]init];
    [self.view addSubview:dividingLineTwo];
    dividingLineTwo.layer.borderWidth = 1;
    dividingLineTwo.layer.borderColor = RGBColor(192, 191 , 198, 1).CGColor;
    //密码
    self.passwordField = [[UITextField alloc]init];
    [dividingLineTwo addSubview:self.passwordField];
    self.passwordField.placeholder = @"请输入密码";
    //添加通知监听文本框的值
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.passwordField];
    //完成按钮
    self.registrationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.registrationButton];
    [self.registrationButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.registrationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.registrationButton.backgroundColor = RGBColor(199, 199, 199, 1);
    self.registrationButton.enabled = NO;
    //添加单击事件
    [self.registrationButton addTarget:self action:@selector(registrationMethod:) forControlEvents:UIControlEventTouchUpInside];
    //约束
    [promptingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(90);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@30);
    }];
    [dividingLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptingLabel.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.equalTo(@40);
    }];
    [self.numberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(dividingLine);
        make.left.equalTo(dividingLine).offset(10);
    }];
    [dividingLineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dividingLine.mas_bottom).offset(20);
        make.left.right.equalTo(dividingLine);
        make.height.equalTo(@40);
    }];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(dividingLineTwo);
        make.left.equalTo(dividingLineTwo).offset(10);
    }];
    [self.registrationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dividingLineTwo.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@40);
    }];
}

#pragma mark - 点击完成时调用
- (void)registrationMethod:(UIButton *)sender{
    NSArray *ary = [NSArray arrayWithObjects:self.numberTextField.text,self.passwordField.text, nil];
    if ([self.manager fileExistsAtPath:self.file] == YES) {
        accountAry = [NSMutableArray arrayWithContentsOfFile:self.file];
    }
    else{
        accountAry = [NSMutableArray array];
    }
    [accountAry addObject:ary];
    NSLog(@"acc%@",accountAry);
    //写入文件
    [accountAry writeToFile:self.file atomically:YES];
    //提示框
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"注册成功", @"HUD message title");
    [hud hideAnimated:YES afterDelay:1.f];
    //延迟1.2秒跳转
    [self performSelector:@selector(pushMethod) withObject:self afterDelay:1.2];
}

#pragma mark - 文本框响应事件
- (void)textFieldTextDidChange{
    if ([self.numberTextField.text isEqualToString:@""] || [self.passwordField.text isEqualToString:@""]) {
        self.registrationButton.enabled = NO;
        self.registrationButton.backgroundColor = RGBColor(199, 199, 199, 1);
    }
    else{
        self.registrationButton.enabled = YES;
        self.registrationButton.backgroundColor = RGBColor(224, 50, 47, 1);
    }
}

#pragma mark - 跳转
- (void)pushMethod{
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
