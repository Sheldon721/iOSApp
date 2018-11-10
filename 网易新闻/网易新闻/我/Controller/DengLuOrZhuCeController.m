//
//  DengLuOrZhuCeController.m
//  网易新闻
//
//  Created by 李晓东 on 2017/8/23.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "DengLuOrZhuCeController.h"
#import "YongHuModel.h"

@interface DengLuOrZhuCeController ()<TencentSessionDelegate>
{
    UIImageView *_zhangHaoImg;//账号图片
    UITextField *_zhangHao;//账号文本框
    UIView *_viewXian;//账号下的分割线
    UIImageView *_miMaImg;//密码图片
    UITextField *_miMa;//密码文本框
    UIView *_viewXian2;//密码下的分割线
    UIButton *_queDing;//登陆或注册
    UITextField *_niChen;//昵称文本框
    UITextField *_queRenMiMa;//确认密码文本框
    BOOL _cunZai;//判断账号密码是否存在
    TencentOAuth *_tencentOAuth;//QQ登陆
}
@property (nonatomic, strong) FMDBTool *dbTool;
@property (nonatomic, strong) NSMutableArray *modelAry;//存储用户信息的数组
@end

@implementation DengLuOrZhuCeController

- (FMDBTool *)dbTool{
    if (_dbTool == nil) {
        _dbTool = [[FMDBTool alloc]init];
    }
    return _dbTool;
}
- (NSMutableArray *)modelAry{
    if (_modelAry == nil) {
        _modelAry = [NSMutableArray array];
    }
    return _modelAry;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createKongJian];
    if (self.btn.tag == 100) {
        [self createDengLuJieMian];
    }
    else{
        [self createZhuCeJieMian];
    }
    // Do any additional setup after loading the view.
}
#pragma mark - 登陆界面
- (void)createDengLuJieMian{
    //账号
    _zhangHaoImg.frame = CGRectMake(20, kStatusHeight+kNaviHeight+20, 40, 40);
    _zhangHaoImg.image = [UIImage imageNamed:@"login_username_icon@2x.png"];
    [self.view addSubview:_zhangHaoImg];
    
    _zhangHao.frame = CGRectMake(70, kStatusHeight+kNaviHeight+20, kWidth-100, 40);
    _zhangHao.placeholder = @"请输入账号";
    //设置为处于编辑状态的时候才显示 清除按钮
    _zhangHao.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_zhangHao];
    
    _viewXian.frame = CGRectMake(20, kStatusHeight+kNaviHeight+70, kWidth-20, 1);
    _viewXian.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1];
    [self.view addSubview:_viewXian];
    
    //密码
    _miMaImg.frame = CGRectMake(20, kStatusHeight+kNaviHeight+80, 40, 40);
    _miMaImg.image = [UIImage imageNamed:@"login_password_icon@2x.png"];
    [self.view addSubview:_miMaImg];
    
    _miMa.frame = CGRectMake(70, kStatusHeight+kNaviHeight+80, kWidth-100, 40);
    _miMa.placeholder = @"密码";
    //设置为密文
    _miMa.secureTextEntry = YES;
    //设置为处于编辑状态的时候才显示 清除按钮
    _miMa.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_miMa];
    
    _viewXian2.frame = CGRectMake(20, kStatusHeight+kNaviHeight+130, kWidth-20, 1);
    _viewXian2.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1];
    [self.view addSubview:_viewXian2];
    
    //登陆
    _queDing.frame = CGRectMake(20, kStatusHeight+kNaviHeight+160, kWidth-40, 40);
    [_queDing setTitle:@"登录" forState:UIControlStateNormal];
    _queDing.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1];
    [_queDing.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [_queDing addTarget:self action:@selector(yanZheng) forControlEvents:UIControlEventTouchUpInside];
    _queDing.enabled = NO;
    //监听账号的值时时改变
    [self tongZhi:_zhangHao andAction:@"textFieldDidChangeValue"];
    
    //监听密码的值时时改变
    [self tongZhi:_miMa andAction:@"textFieldDidChangeValue"];
    //设置为圆角
    _queDing.layer.cornerRadius = 20;
    [self.view addSubview:_queDing];
    
    //第三方QQ登陆
    UIButton *QQBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    QQBtn.frame = CGRectMake(kWidth/2-40, kStatusHeight+kNaviHeight+230, 80, 80);
    //QQBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:QQBtn];
    [QQBtn setImage:[UIImage imageNamed:@"分享至QQ"] forState:UIControlStateNormal];
    //QQBtn.currentBackgroundImage = [UIImage imageNamed:@"qq@2x.png"];
    //[QQBtn setTitle:@"qq" forState:UIControlStateNormal];
    [QQBtn addTarget:self action:@selector(qqDengLu) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - QQ登陆
- (void)qqDengLu{
    _tencentOAuth = [[TencentOAuth alloc]initWithAppId:@"1106223379" andDelegate:self];
    //设置应用需要用户授权的API列表
    NSArray *permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, nil];
    // 这里调起登录
    [_tencentOAuth authorize:permissions];
    
}

// 获取用户信息
- (void)getUserInfoResponse:(APIResponse *)response {
    
    if (response && response.retCode == URLREQUEST_SUCCEED) {
        
        NSDictionary *userInfo = [response jsonResponse];
//        NSMutableString *str = [NSMutableString stringWithFormat:@""];
//        for (id key in response.jsonResponse) {
//            [str appendString: [NSString stringWithFormat:
//                                @"%@:%@\n", key, [response.jsonResponse objectForKey:key]]];
//            NSLog(@"%@",str);
//        }
        NSString *nickName = userInfo[@"nickname"];
        NSString *figureurl = userInfo[@"figureurl"];
       // NSLog(@"%@-%@",nickName,figureurl);
        //保存账号密码
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:figureurl forKey:@"Image"];
        [user setObject:nickName forKey:@"Name"];
        [user setObject:@"QQ" forKey:@"Psw"];
        [user setObject:@"QQ" forKey:@"ZhangHao"];
        //同步执行
        [user synchronize];
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


#pragma mark - 注册界面
- (void)createZhuCeJieMian{
    //昵称
    _niChen = [[UITextField alloc]init];
    [self createZhuCeKongJian:_niChen andFrame:CGRectMake(40, 114, kWidth-80, 50) andPlaceholder:@"请输入昵称"];
    [self tongZhi:_niChen andAction:@"zhuCeTextFieldDidChangeValue"];
    //账号
    [self createZhuCeKongJian:_zhangHao andFrame:CGRectMake(40, 184, kWidth-80, 50) andPlaceholder:@"请输入账号"];
    [self tongZhi:_zhangHao andAction:@"zhuCeTextFieldDidChangeValue"];
    //密码
    [self createZhuCeKongJian:_miMa andFrame:CGRectMake(40, 254, kWidth-80, 50) andPlaceholder:@"请输入密码"];
    [self tongZhi:_miMa andAction:@"zhuCeTextFieldDidChangeValue"];
    //确认密码
    _queRenMiMa = [[UITextField alloc]init];
    [self createZhuCeKongJian:_queRenMiMa andFrame:CGRectMake(40, 324, kWidth-80, 50) andPlaceholder:@"请确认密码"];
    [self tongZhi:_queRenMiMa andAction:@"zhuCeTextFieldDidChangeValue"];
    //注册
    _queDing.frame = CGRectMake(40, 414, kWidth-80, 40);
    [_queDing setTitle:@"注册" forState:UIControlStateNormal];
    _queDing.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1];
    [_queDing.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [_queDing addTarget:self action:@selector(zhuCe) forControlEvents:UIControlEventTouchUpInside];
    _queDing.enabled = NO;
    [self.view addSubview:_queDing];
}
//注册控件
- (void)createZhuCeKongJian:(UITextField *)field andFrame:(CGRect)frame andPlaceholder:(NSString *)placeholder{
    field.frame = frame;
    field.borderStyle = UITextBorderStyleRoundedRect;
    //设置边框大小和颜色
    field.layer.borderWidth = 1.0f;
    field.layer.borderColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1].CGColor;
    field.placeholder = placeholder;
    //设置为处于编辑状态的时候才显示 清除按钮
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:field];
}
#pragma mark - 基本界面
- (void)createKongJian{
    //账号
    _zhangHaoImg = [[UIImageView alloc]init];
    _zhangHao = [[UITextField alloc]init];
    _viewXian = [[UIView alloc]init];
    
    //密码
    _miMaImg = [[UIImageView alloc]init];
    _miMa = [[UITextField alloc]init];
    _viewXian2 = [[UIView alloc]init];
    
    //登陆或注册
    _queDing = [UIButton buttonWithType:UIButtonTypeCustom];
    
    

}

#pragma mark - 监听textFiel的值时时改变通知
- (void)tongZhi:(UITextField *)field andAction:(NSString *)action1{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:NSSelectorFromString(action1)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:field];
}

#pragma mark - 登录中的文本框值改变调用
- (void)textFieldDidChangeValue{
    //判断两个文本框是否同时不为空   是改变按钮背景颜色  否则不改变
    if ([_zhangHao.text isEqualToString:@""] || [_miMa.text isEqualToString:@""]) {
        _queDing.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1];
    }
    else{
        _queDing.backgroundColor = [UIColor colorWithRed:223.0/255 green:66.0/255 blue:66.0/255 alpha:1];
        _queDing.enabled = YES;
    }

}
#pragma mark - 注册中的文本框值改变调用
- (void)zhuCeTextFieldDidChangeValue{
    //判断两个文本框是否同时不为空   是改变按钮背景颜色  否则不改变
    if ([_zhangHao.text isEqualToString:@""] || [_miMa.text isEqualToString:@""] || [_niChen.text isEqualToString:@""] || [_queRenMiMa.text isEqualToString:@""]) {
        _queDing.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1];
    }
    else{
        _queDing.backgroundColor = [UIColor colorWithRed:223.0/255 green:66.0/255 blue:66.0/255 alpha:1];
        _queDing.enabled = YES;
    }
}
#pragma mark - 登录
- (void)yanZheng{
    //验证账号密码是否正确
    //获取所有用户信息
    self.modelAry = [self.dbTool selectYongHuAll:@"select *from b_user"];
    //循环判断此用户是否存在
    for (YongHuModel *model in self.modelAry) {
        if ([_zhangHao.text isEqualToString:model.zhangH] && [_miMa.text isEqualToString:model.miMa]) {
            //账号密码存在
            _cunZai = YES;
            //保存账号密码
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:model.name forKey:@"Name"];
            [user setObject:model.miMa forKey:@"Psw"];
            [user setObject:model.zhangH forKey:@"ZhangHao"];
            //同步执行
            [user synchronize];
            //登录成功
            //返回根控制器
            [self.navigationController popToRootViewControllerAnimated:YES];

        }
    }
    if (_cunZai == NO) {
        [self createTiShiKuang:@"登录失败" andMessage:@"账号或密码错误，请重新输入"];
    }
    
}
#pragma mark - 注册
- (void)zhuCe{
    //查找数据库 是否存在此昵称
    [self.dbTool selectTiaoJian:[NSString stringWithFormat:@"select *from b_user where yh_name = '%@'",_niChen.text] andCanShu:@"yh_name"];
    NSString *name = self.dbTool.selectTitle;
    //查找数据库 是否存在此账号
    [self.dbTool selectTiaoJian:[NSString stringWithFormat:@"select *from b_user where yh_zhanghao = '%@'",_zhangHao.text] andCanShu:@"yh_zhanghao"];
    NSString *zhangH = self.dbTool.selectTitle;
    if ([name isEqualToString:_niChen.text]) {
        //提示昵称已存在
        [self createTiShiKuang:@"昵称已存在,请重新输入" andMessage:@"注册失败"];
    }
    else if ([zhangH isEqualToString:_zhangHao.text]){
        //提示账号已存在
        [self createTiShiKuang:@"账号已存在,请重新输入" andMessage:@"注册失败"];
    }
    else if (![_queRenMiMa.text isEqualToString:_miMa.text]){
        //提示密码不相同
        [self createTiShiKuang:@"密码不相同,请重新输入" andMessage:@"注册失败"];
    }
    else{
        //写入数据库
        [self.dbTool addShuJu:[NSString stringWithFormat:@"insert into b_user (yh_name,yh_zhanghao,yh_pws) values ('%@','%@','%@')",_niChen.text,_zhangHao.text,_miMa.text]];
        UIAlertController *aC = [UIAlertController alertControllerWithTitle:@"注册成功" message:@"去登录？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *queDing = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.hidesBottomBarWhenPushed = YES;
            //进入登录界面
            DengLuOrZhuCeController *denglu = [[DengLuOrZhuCeController alloc]init];
            //创建进入登录界面的条件
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 100;
            denglu.btn = btn;
            [self.navigationController showViewController:denglu sender:nil];
        }];
        UIAlertAction *quXiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        } ];
        [aC addAction:quXiao];
        [aC addAction:queDing];
        [self presentViewController:aC animated:YES completion:nil];
        //清空文本框
        _niChen.text = @"";
        _zhangHao.text = @"";
        _miMa.text = @"";
        _queRenMiMa.text = @"";
    }
    
}
#pragma mark - 提示框
- (void)createTiShiKuang:(NSString *)title andMessage:(NSString *)message{
    UIAlertController *aC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *queDing = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [aC addAction:queDing];
    [self presentViewController:aC animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
