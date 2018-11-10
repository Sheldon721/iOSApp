//
//  TuPianCaoZuoViewController.m
//  网易新闻
//
//  Created by 李晓东 on 2017/8/9.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "TuPianCaoZuoViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
@interface TuPianCaoZuoViewController ()
{
    UIView *_jieMian;
    UIImageView *_imgV;
    int recognizer;//存储索引值
    UILabel *_title;//标题显示数量
    NSArray* imageArray;
    NSString *tuTitle;//分享时的标题
}
@end

@implementation TuPianCaoZuoViewController
-(NSMutableArray *)tuPianAry{
    if (_tuPianAry == nil) {
        _tuPianAry = [[NSMutableArray alloc]init];
    }
    return _tuPianAry;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    recognizer = (int)self.indexPath.row;

    [self createJieMian];
    [self createImg];
  
}
- (void)createJieMian{
    //返回
    UIButton *fanHui = [UIButton buttonWithType:UIButtonTypeCustom];
    fanHui.frame = CGRectMake(5, kStatusHeight, 60, 40);
    [fanHui setTitle:@"返回" forState:UIControlStateNormal];
    [fanHui setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fanHui addTarget:self action:@selector(fanHui) forControlEvents:UIControlEventTouchUpInside];
    //标题
    _title = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-40, kStatusHeight, 80, 40)];
    [_title setText:[NSString stringWithFormat:@"%d/%ld",recognizer+1,(long)self.tuPianAry.count]];
    [_title setTextAlignment:NSTextAlignmentCenter];
   
    [_title setTextColor:[UIColor whiteColor]];
    //分享
    UIButton *fenXiang = [UIButton buttonWithType:UIButtonTypeCustom];
    fenXiang.frame = CGRectMake(kWidth-50, kStatusHeight, 40, 40);
    [fenXiang setTitle:@"分享" forState:UIControlStateNormal];
    [fenXiang setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fenXiang addTarget:self action:@selector(fenXiang) forControlEvents:UIControlEventTouchUpInside];
    //下载
    UIButton *xiaZai = [UIButton buttonWithType:UIButtonTypeCustom];
    xiaZai.frame = CGRectMake(5, kHeight-50-kSafeAreaBottomHeight, 40, 40);
    [xiaZai setImage:[UIImage imageNamed:@"arrow237.png"] forState:UIControlStateNormal];
    [xiaZai addTarget:self action:@selector(xiaZai) forControlEvents:UIControlEventTouchUpInside];
    _jieMian = [[UIView alloc]initWithFrame:self.view.frame];
    [_jieMian addSubview:fanHui];
    [_jieMian addSubview:_title];
    [_jieMian addSubview:fenXiang];
    [_jieMian addSubview:xiaZai];
    [self.view addSubview:_jieMian];
}
- (void)createImg{
    _imgV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 80, kWidth-40, kHeight-160)];
    _imgV.userInteractionEnabled = YES;
    self.model = self.tuPianAry[self.indexPath.row];
    [_imgV sd_setImageWithURL:[NSURL URLWithString:self.model.small_url] placeholderImage:[UIImage imageNamed:@"tabbar_picture@3x.png"]];
    [self.view addSubview:_imgV];
    [self createShouShi];
}
//返回
- (void)fanHui{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//分享
- (void)fenXiang{
    //此处功能  分享到QQ、微博、微信。
    //1、创建分享参数
    //判断是否有图片   没有则用本地图片
    
        imageArray = @[[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.small_url]]]];
    if ([self.model.title isEqualToString:@""]) {
        tuTitle = @"图片";
    }
    else{
        tuTitle = self.model.title;
    }
    
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:tuTitle
                                         images:imageArray
                                            url:[NSURL URLWithString:self.model.small_url]
                                          title:tuTitle
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
                               [self alertView:@"分享成功" andMessage:nil andActionTitle:@"确定"];

                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               //
                               [self alertView:@"分享失败" andMessage:nil andActionTitle:@"确定"];
                               
                               
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}

}
//下载
- (void)xiaZai{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定是否要保存到相册吗？" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //存入相册
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.small_url]]], self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;{
    //
    [self alertView:@"提示" andMessage:@"保存成功" andActionTitle:@"确定"];
}
#pragma -mark提示框
- (void)alertView:(NSString *)title andMessage:(NSString *)message andActionTitle:(NSString *)at{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:at style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma -mark创建手势
- (void)createShouShi{
    //左轻扫
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftRecognizer)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    [_imgV addGestureRecognizer:left];
    //右轻扫
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightRecognizer)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [_imgV addGestureRecognizer:right];
    //单击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dianJi)];
    [_imgV addGestureRecognizer:tap];
}
- (void)leftRecognizer{
    if (recognizer != _tuPianAry.count-1) {
        recognizer += 1;
        [_title setText:[NSString stringWithFormat:@"%d/%ld",recognizer+1,(long)self.tuPianAry.count]];
        self.model = self.tuPianAry[recognizer];
        [_imgV sd_setImageWithURL:[NSURL URLWithString:self.model.small_url] placeholderImage:[UIImage imageNamed:@"tabbar_picture@3x.png"]];
    }
   
}
- (void)rightRecognizer{
    if (recognizer != 0) {
        recognizer -= 1;
        [_title setText:[NSString stringWithFormat:@"%d/%ld",recognizer+1,(long)self.tuPianAry.count]];
        self.model = self.tuPianAry[recognizer];
        [_imgV sd_setImageWithURL:[NSURL URLWithString:self.model.small_url] placeholderImage:[UIImage imageNamed:@"tabbar_picture@3x.png"]];
    }
}
- (void)dianJi{
    if (_jieMian.hidden == NO) {
        _jieMian.hidden = YES;
    }
    else{
        _jieMian.hidden = NO;
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
