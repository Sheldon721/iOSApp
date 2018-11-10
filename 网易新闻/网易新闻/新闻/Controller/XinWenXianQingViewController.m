//
//  XinWenXianQingViewController.m
//  网易新闻
//
//  Created by 李晓东 on 2017/7/13.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "XinWenXianQingViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <WebKit/WebKit.h>
#import "DengLuOrZhuCeController.h"
#import "PingLunController.h"
@interface XinWenXianQingViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    //获得最外层窗口
   // UIWindow *_window;
    WKWebView *_webView;
    NSArray* imageArray;
    UITextField *_textField;//输入框
    UITextView *_textView;//文本视图
    UIButton *_queDing;//发送按钮
    UIView *_xieGenTie;//写跟贴视图
    UIButton *_shouCang;//收藏
    UILabel *_pingLunLbl;//评论条数
    UIProgressView *_progressView;//进度条
}
@property (nonatomic ,strong) NSMutableArray *pingLunCount;
@end

@implementation XinWenXianQingViewController

- (FMDBTool *)dbTool{
    if (_dbTool == nil) {
        _dbTool = [FMDBTool shareTool];
    }
    return _dbTool;
}

- (NSMutableArray *)pingLunCount{
    if (_pingLunCount == nil) {
        _pingLunCount = [NSMutableArray array];
    }
    return _pingLunCount;
}

- (void)viewWillAppear:(BOOL)animated{
    self.pingLunCount = [self.dbTool selectPingLunAll:[NSString stringWithFormat:@"select *from b_ping where pl_title = '%@'",self.model.title]];
    if (self.pingLunCount.count == 0) {
        
    }
    else{
        _pingLunLbl.text = [NSString stringWithFormat:@"%ld",(long)self.pingLunCount.count];
    }

}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createWebView];
    [self createFooterView];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(fenXiang)];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)fenXiang{
    //此处功能  分享到QQ、微博、微信。
    //1、创建分享参数
    //判断是否有图片   没有则用本地图片
    if ([self.model.pic isEqualToString:@""]) {
        imageArray = @[[UIImage imageNamed:@"tabbar_picture@3x.png"]];
    }
    else{
        imageArray = @[[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.pic]]]];
    }
    
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:self.model.title
                                         images:imageArray
                                            url:[NSURL URLWithString:self.model.url]
                                          title:self.model.title
                                           type:SSDKContentTypeAuto];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"分享成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                               UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                               
                               [alert addAction:action];
                               [self presentViewController:alert animated:YES completion:nil];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"分享失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
                               UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                               
                               [alert addAction:action];
                               [self presentViewController:alert animated:YES completion:nil];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
}
- (void)createWebView{
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-40)];
    [self.view addSubview:_webView];
    [self showInWebView];
    //添加观察者模式
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    //
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0,kNaviHeight+kStatusHeight, kWidth,3)];
    _progressView.tintColor = [UIColor greenColor];
    _progressView.trackTintColor = [UIColor whiteColor];
    [_webView addSubview:_progressView];
}

//
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        if (object ==_webView) {
            [_progressView setAlpha:1.0f];
            [_progressView setProgress:_webView.estimatedProgress animated:YES];
            
            if(_webView.estimatedProgress >=1.0f) {
                
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [_progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [_progressView setProgress:0.0f animated:NO];
                }];
                
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object  change:change context:context];
        }
        
    }
}

- (void)showInWebView
{
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendString:@"<meta name=\"viewport\" content=\"initial-scale=1.0,maximum-scale=1.0,user-scalble=no\">"];
    [html appendFormat:@"<style type=\"text/css\">img{width:%lfpx;height:200px;} p{font-size:20px;}</style>",kWidth-20];
    [html appendString:@"</head>"];
    [html appendString:@"<body>"];
    [html appendFormat:@"<div style=\"font-size:24px; \"\"><strong>%@</strong></div>",self.model.title];
    [html appendString:self.model.content];
    [html appendString:@"</body>"];
    [html appendString:@"</html>"];
    
    [_webView loadHTMLString:html baseURL:nil];
    
}

//底部视图工具栏
- (void)createFooterView{
    UIView *_footerView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight-40, kWidth, 40)];
    _footerView.layer.borderWidth = 1;
    _footerView.layer.borderColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1].CGColor;
    //输入框的底视图
    UIView *textFooterView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, kWidth/2, 30)];
    textFooterView.backgroundColor = [UIColor whiteColor];
    textFooterView.layer.borderWidth = 1;
    textFooterView.layer.borderColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1].CGColor;
    textFooterView.layer.cornerRadius = 10;
    
    //输入框
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, kWidth/2-15, 30)];
    _textField.placeholder = @"写跟贴";
    _textField.delegate = self;
    [textFooterView addSubview:_textField];
    [_footerView addSubview:textFooterView];
    
    //评论
    UIButton *_pingLun = [UIButton buttonWithType:UIButtonTypeCustom];
    _pingLun.frame = CGRectMake(kWidth/2+30, 5, 50, 30);
    [_pingLun setImage:[UIImage imageNamed:@"552cc165df8f4_16.png"] forState:UIControlStateNormal];
    [_pingLun addTarget:self action:@selector(pingLun) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_pingLun];
    //评论条数
    _pingLunLbl = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2+65, 5, 30, 30)];
    
    [_footerView addSubview:_pingLunLbl];
    //收藏
    _shouCang = [UIButton buttonWithType:UIButtonTypeCustom];
    _shouCang.frame = CGRectMake(kWidth-50, 5, 30, 30);
    [_shouCang addTarget:self action:@selector(shouCang) forControlEvents:UIControlEventTouchUpInside];
    
    [self.dbTool selectTiaoJian:[NSString stringWithFormat:@"select *from b_cang where sc_title = '%@'",self.model.title] andCanShu:@"sc_title"];
    if ([self.dbTool.selectTitle isEqualToString:self.model.title]) {
        [_shouCang setImage:[UIImage imageNamed:@"552cc347445f9_16.png"] forState:UIControlStateNormal];
    }
    else{
        [_shouCang setImage:[UIImage imageNamed:@"552cc34f70431_16(1).png"] forState:UIControlStateNormal];
    }
    
    [_footerView addSubview:_shouCang];
    _footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_footerView];
}

#pragma mark - 点击文本框时调用
- (void)textFieldDidBeginEditing:(UITextField *)textField{
       // _window.backgroundColor = [UIColor redColor];
    //UIView *eee = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
   // eee.backgroundColor = [UIColor purpleColor];
    //[_window addSubview:eee];
    //获得最外层窗口
   // _window = [[UIApplication sharedApplication].windows lastObject];
    [self createXieGenTie];
    //模拟延迟 设置文本视图为第一响应者
    [self performSelector:@selector(tiao) withObject:nil afterDelay:0.5];
}
- (void)tiao{
    [_textField resignFirstResponder];
    [_textView becomeFirstResponder];
    
}

#pragma mark -创建写跟贴视图
- (void)createXieGenTie{
    //创建底视图
    _xieGenTie =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-270)];
    _xieGenTie.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    //创建工具视图
    UIView *gongJuView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight-470, kWidth, 200)];
    gongJuView.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1];
    //标题：写跟贴
    UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-40, 5, 80, 40)];
    [titleLbl setText:@"写跟贴"];
    [titleLbl setTextAlignment:NSTextAlignmentCenter];
    [gongJuView addSubview:titleLbl];
    //取消
    UIButton *quXiao = [UIButton buttonWithType:UIButtonTypeCustom];
    quXiao.frame = CGRectMake(10, 5, 40, 40);
    [quXiao setTitle:@"取消" forState:UIControlStateNormal];
    [quXiao setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [quXiao addTarget:self action:@selector(quXiao:) forControlEvents:UIControlEventTouchUpInside];
    [gongJuView addSubview:quXiao];
    //确定
    _queDing = [UIButton buttonWithType:UIButtonTypeCustom];
    _queDing.frame = CGRectMake(kWidth-50, 5, 40, 40);
    [_queDing setTitle:@"发送" forState:UIControlStateNormal];
    _queDing.enabled = NO;
    [_queDing addTarget:self action:@selector(queDing:) forControlEvents:UIControlEventTouchUpInside];
    [gongJuView addSubview:_queDing];
    //文本视图
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 50, kWidth-20, 100)];
    _textView.delegate = self;
    _textView.backgroundColor = [UIColor whiteColor];
    [gongJuView addSubview:_textView];
    [_xieGenTie addSubview:gongJuView];
    [self.view addSubview:_xieGenTie];
    
}
#pragma mark - 当文本视图改变时调用
- (void)textViewDidChange:(UITextView *)textView
{
    //判断文本视图是否有值  改变按钮状态
    if (![textView.text isEqualToString:@""]) {
        [_queDing setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _queDing.enabled = YES;
    }
    else{
        [_queDing setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _queDing.enabled = NO;
    }
}

#pragma mark - 点击取消时调用
- (void)quXiao:(UIButton *)sender{
    //删除写跟贴视图
    [_xieGenTie removeFromSuperview];
    [_textView resignFirstResponder];
}
#pragma mark - 点击发送时调用
- (void)queDing:(UIButton *)sender{
    //删除写跟贴视图
    [_xieGenTie removeFromSuperview];
    [_textView resignFirstResponder];
    //获取偏好设置
    NSUserDefaults *_user = [NSUserDefaults standardUserDefaults];
    //判断偏好设置中是否存在用户数据
    if ([_user objectForKey:@"Name"] && [_user objectForKey:@"Psw"] && [_user objectForKey:@"ZhangHao"]) {
        //添加评论数据到数据库
        [self.dbTool addShuJu:[NSString stringWithFormat:@"insert into b_ping(pl_image,pl_name,pl_content,pl_title) values ('%@','%@','%@','%@')",[_user objectForKey:@"Image"],[_user objectForKey:@"Name"],_textView.text,self.model.title]];
        [MBTool showMessage:@"评论成功" toView:nil];
        //更新评论条数
        self.pingLunCount = [self.dbTool selectPingLunAll:[NSString stringWithFormat:@"select *from b_ping where pl_title = '%@'",self.model.title]];
        _pingLunLbl.text = [NSString stringWithFormat:@"%ld",(long)self.pingLunCount.count];
    }
    else{
        
        UIAlertController *aC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您当前尚未登录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *queDing = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.hidesBottomBarWhenPushed = YES;
            //进入登录界面
            DengLuOrZhuCeController *denglu = [[DengLuOrZhuCeController alloc]init];
            //创建进入登录界面的条件
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 100;
            denglu.btn = btn;
            [self.navigationController pushViewController:denglu animated:NO];
            
        }];
        UIAlertAction *quXiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [aC addAction:queDing];
        [aC addAction:quXiao];
        [self presentViewController:aC animated:YES completion:nil];
    }
}

#pragma mark - 点击评论时调用
- (void)pingLun{
    self.hidesBottomBarWhenPushed = YES;
    PingLunController *pl = [[PingLunController alloc]init];
    pl.name = self.model.title;
    [self.navigationController pushViewController:pl animated:YES];
}

#pragma mark - 点击收藏时调用
- (void)shouCang{
    //查询数据
    [self.dbTool selectTiaoJian:[NSString stringWithFormat:@"select *from b_cang where sc_title = '%@'",self.model.title] andCanShu:@"sc_title"];
    //判断数据是否存在
    if([self.dbTool.selectTitle isEqualToString:self.model.title]){
        NSLog(@"%@",self.model.title);
        //删除数据库
        [self.dbTool deleteBiao:[NSString stringWithFormat:@"delete from b_cang where sc_title = '%@'",self.model.title]];
        [_shouCang setImage:[UIImage imageNamed:@"552cc34f70431_16(1).png"] forState:UIControlStateNormal];
        [MBTool showMessage:@"成功取消收藏" toView:nil];
    }
    else{
        //加入数据库
        [self.dbTool addShuJu:[NSString stringWithFormat:@"insert into b_cang (sc_title,sc_time,sc_src,sc_category,sc_pic,sc_content,sc_url,sc_weburl) values ('%@','%@','%@','%@','%@','%@','%@','%@')",self.model.title,self.model.time,self.model.src,self.model.category,self.model.pic,self.model.content,self.model.url,self.model.weburl]];
        [_shouCang setImage:[UIImage imageNamed:@"552cc347445f9_16.png"] forState:UIControlStateNormal];
        [MBTool showMessage:@"收藏成功" toView:nil];
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
