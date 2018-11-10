//
//  SFViewController.m
//  云音乐
//
//  Created by 李晓东 on 2017/9/20.
//  Copyright © 2017年 李晓东. All rights reserved.
//

#import "SFViewController.h"

@interface SFViewController ()<TencentSessionDelegate>
{
    TencentOAuth *_tencentOAuth;//QQ登陆
    NSUserDefaults *_user;
    //登录按钮
    UIButton *_dengLu;
    UIImageView *_imgView;
    //网名
    UILabel *_title;
}
@end

@implementation SFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _user = [NSUserDefaults standardUserDefaults];
    [self createUI];
    
    if ([_user objectForKey:@"Image"] && [_user objectForKey:@"Name"]) {
        _dengLu.alpha = 0;
        [_imgView sd_setImageWithURL:[NSURL URLWithString:[_user objectForKey:@"Image"]]];
        _title.text = [_user objectForKey:@"Name"];
    }
    else{
    
        
    }
    
    
    // Do any additional setup after loading the view.
}

- (void)createUI{
    //登录按钮
    _dengLu = [[UIButton alloc]initWithFrame:CGRectMake(kWidth*0.25, 100, 80, 80)];
    [self.view addSubview:_dengLu];
    [_dengLu setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [_dengLu addTarget:self action:@selector(dengLu) forControlEvents:UIControlEventTouchUpInside];
    //头像
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth*0.25, 100, 80, 80 )];
    [self.view addSubview:_imgView];
    //设置圆角
    _imgView.layer.cornerRadius = 40;
    _imgView.layer.masksToBounds = YES;
    //网名
    _title = [[UILabel alloc]initWithFrame:CGRectMake(kWidth*0.25-60, 190, 200, 30)];
    [self.view addSubview:_title];
    [_title setTextAlignment:NSTextAlignmentCenter];
}

- (void)dengLu{
    _tencentOAuth = [[TencentOAuth alloc]initWithAppId:@"1106390309" andDelegate:self];
    //设置应用需要用户授权的API列表
    NSArray *permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, nil];
    // 这里调起登录
    [_tencentOAuth authorize:permissions];
}
// 获取用户信息
- (void)getUserInfoResponse:(APIResponse *)response {
    
    if (response && response.retCode == URLREQUEST_SUCCEED) {
        _dengLu.alpha = 0;
        
        NSDictionary *userInfo = [response jsonResponse];
        NSString *nickName = userInfo[@"nickname"];
        NSString *figureurl = userInfo[@"figureurl"];
        
        [_imgView sd_setImageWithURL:[NSURL URLWithString:figureurl]];
        [_title setText:nickName];
        
        //保存账号密码
        
        
        
        [_user setObject:figureurl forKey:@"Image"];
        [_user setObject:nickName forKey:@"Name"];
        //同步执行
        [_user synchronize];
        // 后续操作...
        //返回根控制器
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } else {
        NSLog(@"QQ auth fail ,getUserInfoResponse:%d", response.detailRetCode);
    }
}


//登录成功：
- (void)tencentDidLogin
{
    if (_tencentOAuth.accessToken.length > 0) {
        // 获取用户信息
        [_tencentOAuth getUserInfo];
        
    } else {
        NSLog(@"登录不成功 没有获取accesstoken");
    }
}

//非网络错误导致登录失败：
- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled) {
        NSLog(@"用户取消登录");
    } else {
        NSLog(@"登录失败");
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
