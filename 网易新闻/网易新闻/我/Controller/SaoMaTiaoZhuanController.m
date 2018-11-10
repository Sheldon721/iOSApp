//
//  SaoMaTiaoZhuanController.m
//  网易新闻
//
//  Created by 李晓东 on 2017/8/25.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "SaoMaTiaoZhuanController.h"
#import <WebKit/WebKit.h>
@interface SaoMaTiaoZhuanController ()
{
    WKWebView *_webView;
    UIProgressView *_progressView;
}
@end

@implementation SaoMaTiaoZhuanController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    [self.view addSubview:_webView];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.url]];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建
    [_webView loadRequest:request];//加载
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
