//
//  LoginViewController.m
//  快易查
//
//  Created by 刘超正 on 2017/11/19.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "LoginViewController.h"
#import "registrationViewController.h"
@interface LoginViewController ()
@property(nonatomic,strong) UITextField *telTextField; //手机号码
@property(nonatomic,strong) UITextField *passwordTextField; //密码
@property(nonatomic,strong) UIButton *loginButton;//登录按钮
@property(nonatomic,strong) NSFileManager *fileManager;//文件管理器
@property(nonatomic,strong) NSString *file;//plist路径
@end

@implementation LoginViewController

- (NSFileManager *)fileManager{
    if (_fileManager == nil) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self createHeaderUI];
    //
    [self createMainUI];
    //获取沙盒路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //拼接plist文件路径
    self.file = [path stringByAppendingPathComponent:@"account.plist"];
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
    title.text = @"登录";
    //注册按钮
    UIButton *registrationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:registrationButton];
    [registrationButton setTitle:@"注册" forState:UIControlStateNormal];
    [registrationButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [registrationButton addTarget:self action:@selector(registrationMethod:) forControlEvents:UIControlEventTouchUpInside];
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
    [registrationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.width.equalTo(@40);
    }];
}

- (void)createMainUI{
    //手机号码
    self.telTextField = [[UITextField alloc]init];
    [self.view addSubview:self.telTextField];
    self.telTextField.placeholder = @"请输入手机号码";
    //添加通知监听文本框的值
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.telTextField];
    //分割线
    UIView *dividingLineOne = [[UIView alloc]init];
    [self.view addSubview:dividingLineOne];
    dividingLineOne.backgroundColor = RGBColor(239, 238, 242, 1);
    //登录密码
    self.passwordTextField = [[UITextField alloc]init];
    [self.view addSubview:self.passwordTextField];
    self.passwordTextField.placeholder = @"请输入登录密码";
    [self.passwordTextField setSecureTextEntry:YES];
    //添加通知监听文本框的值
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.passwordTextField];
    //分割线2
    UIView *dividingLineTwo = [[UIView alloc]init];
    [self.view addSubview:dividingLineTwo];
    dividingLineTwo.backgroundColor = RGBColor(239, 238, 242, 1);
    //登录按钮
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton.backgroundColor = RGBColor(199, 199, 199, 1);
    [self.view addSubview:self.loginButton];
    [self.loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.enabled = NO;
    [self.loginButton addTarget:self action:@selector(loginMethod:) forControlEvents:UIControlEventTouchUpInside];
    //QQ
    UIButton *qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:qqButton];
    [qqButton setTitle:@"QQ登录" forState:UIControlStateNormal];
    [qqButton setTitleColor:RGBColor(78, 135, 243, 1) forState:UIControlStateNormal];
    [qqButton setImage:[UIImage imageNamed:@"分享至QQ"] forState:UIControlStateNormal];
    //设置图片和文字位置
    [qqButton setTitleEdgeInsets:UIEdgeInsetsMake(50, -40, 5, 0)];
    [qqButton setImageEdgeInsets:UIEdgeInsetsMake(5, 25, 45, 25)];
    //设置文字大小
    [qqButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    
    //微信
    UIButton *weiXinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:weiXinButton];
    [weiXinButton setTitle:@"微信登录" forState:UIControlStateNormal];
    [weiXinButton setTitleColor:RGBColor(131, 204, 114, 1) forState:UIControlStateNormal];
    [weiXinButton setImage:[UIImage imageNamed:@"分享至微信"] forState:UIControlStateNormal];
    //设置图片和文字位置
    [weiXinButton setTitleEdgeInsets:UIEdgeInsetsMake(50, -40, 5, 0)];
    [weiXinButton setImageEdgeInsets:UIEdgeInsetsMake(5, 25, 45, 25)];
    //设置文字大小
    [weiXinButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    //新浪微博
    UIButton *weiBoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:weiBoButton];
    [weiBoButton setTitle:@"微博登录" forState:UIControlStateNormal];
    [weiBoButton setTitleColor:RGBColor(246, 119, 119, 1) forState:UIControlStateNormal];
    [weiBoButton setImage:[UIImage imageNamed:@"微博"] forState:UIControlStateNormal];
    //设置图片和文字位置
    [weiBoButton setTitleEdgeInsets:UIEdgeInsetsMake(50, -40, 5, 0)];
    [weiBoButton setImageEdgeInsets:UIEdgeInsetsMake(5, 25, 45, 25)];
    //设置文字大小
    [weiBoButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    //约束
    [self.telTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(90);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.equalTo(@30);
    }];
    [dividingLineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.telTextField.mas_bottom).offset(5);
        make.left.right.equalTo(self.telTextField);
        make.height.equalTo(@1);
    }];
    [self.passwordTextField  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dividingLineOne.mas_bottom).offset(30);
        make.right.left.equalTo(dividingLineOne);
        make.height.equalTo(@30);
    }];
    [dividingLineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(5);
        make.left.right.equalTo(self.passwordTextField);
        make.height.equalTo(@1);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dividingLineTwo.mas_bottom).offset(50);
        make.left.right.equalTo(dividingLineTwo);
        make.height.equalTo(@50);
    }];
    [qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(50);
        make.height.width.equalTo(@80);
    }];
    [weiXinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(kWidth/2-40);
        make.height.width.equalTo(@80);
    }];
    [weiBoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).offset(50);
        make.right.equalTo(self.view).offset(-50);
        make.height.width.equalTo(@80);
    }];
    
}
#pragma mark - 点击取消时调用
- (void)cancelMethod:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 点击注册时调用
- (void)registrationMethod:(UIButton *)sender{
    registrationViewController *rVC = [[registrationViewController alloc]init];
    [self presentViewController:rVC animated:YES completion:nil];
}
#pragma mark - 点击登录时调用
- (void)loginMethod:(UIButton *)sender{
    //判断是否登陆成功 1:成功。0 失败
    int i = 0;
    //获取所有账户
    NSMutableArray *accountAllArray = [NSMutableArray arrayWithContentsOfFile:self.file];
    //判断账户是否存在
    for (NSArray *accountAry in accountAllArray) {
        if ([self.telTextField.text isEqualToString:accountAry[0]] && [self.passwordTextField.text isEqualToString:accountAry[1]]) {
            i = 1;
            //写入偏好设置
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            [userDefaults setObject:@"user_defaultavatar" forKey:@"Image"];
            [userDefaults setObject:self.telTextField.text forKey:@"Tel"];
            [userDefaults setObject:self.passwordTextField.text forKey:@"Psw"];
            //同步执行
            [userDefaults synchronize];
            //提示框
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"登录成功", @"HUD message title");
            [hud hideAnimated:YES afterDelay:1.f];
            //延迟1.2秒跳转
            [self performSelector:@selector(pushMethod) withObject:self afterDelay:1.2];
            return ;
        }
        else{
            NSLog(@"登录失败");
        }
    }
    if (i != 1) {
        //提示框
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"账号或密码错误，请重新输入！", @"HUD message title");
        [hud hideAnimated:YES afterDelay:1.f];
    }
}

#pragma mark - 跳转
- (void)pushMethod{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 文本框值改变时调用
- (void)textFieldTextDidChange{
    if ([self.telTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]   ) {
        self.loginButton.backgroundColor = RGBColor(199, 199, 199, 1);
        self.loginButton.enabled = NO;
    }
    else{
        self.loginButton.backgroundColor = RGBColor(224, 50, 47, 1);
        self.loginButton.enabled = YES;
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
