//
//  HomeViewController.m
//  officialDemoNavi
//
//  Created by李晓东 on 2017/12/14.
//  Copyright © 2017年 李晓东. All rights reserved.
//

#import "HomeViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "UserViewController.h"
#import "SearchFiledView.h"
#import <AMapNaviKit/AMapNaviKit.h>
//搜索基础类
#import <AMapSearchKit/AMapSearchKit.h>
#import "SearchFootView.h"
#import "YFSearchViewController.h"
#import "MessageViewController.h"
@interface HomeViewController ()<MAMapViewDelegate,AMapNaviCompositeManagerDelegate,AMapSearchDelegate>
@property(nonatomic,strong)MAUserLocation *currentLocation;//目前定位
@property(nonatomic,strong)SearchFiledView *filedView;//输入框视图
@property(nonatomic,strong)UIButton *currentBtn;//按钮
@property(nonatomic,strong)MAMapView *mapView;//地图
@property (nonatomic, strong) AMapNaviCompositeManager *compositeManager;//搜索
@property(nonatomic,strong)AMapSearchAPI *search;//反编码
@property(nonatomic,strong)SearchFootView *footView;//底部视图
@property(nonatomic,copy)NSString *currentName;//当前位置名字
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    //设置地图缩放比例，即显示区域
    [_mapView setZoomLevel:15.1 animated:YES];
    //设置定位精度
    _mapView.desiredAccuracy = kCLLocationAccuracyBest;
    //设置定位距离
    _mapView.distanceFilter = 5.0f;
    _mapView.delegate = self;
    ///把地图添加至view
    [self.view addSubview:_mapView];
    
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    //反编码
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    //加载视图
    self.filedView = [SearchFiledView createFileView];
    self.filedView.frame = CGRectMake(8, 20, CGRectGetWidth(self.view.frame) - 16, 60);
    //返回输入数据
    __block typeof(self)weakSelf = self;
    self.filedView.inputStrBlock = ^() {
        
        [weakSelf.compositeManager presentRoutePlanViewControllerWithOptions:nil];  // 通过present的方式显示路线规划页面
    };
    //跳转控制器
    self.filedView.pushVCBlock = ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UserViewController *user = [[UserViewController alloc]init];
            [weakSelf.navigationController pushViewController:user animated:NO];
            
        });
    };
    [self.view addSubview:self.filedView];
    //裁剪圆角
    self.filedView.layer.cornerRadius= 5;
    //阴影
    self.filedView.layer.cornerRadius = 5;
    self.filedView.layer.shadowOpacity = 0.5;// 阴影透明度
    self.filedView.layer.shadowColor = [UIColor lightGrayColor].CGColor;// 阴影的颜色
    self.filedView.layer.shadowRadius = 3;// 阴影扩散的范围控制
    
    //message
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    messageBtn.frame = CGRectMake(8, 100, 40, 40);
    messageBtn.layer.cornerRadius = 20;
    messageBtn.layer.shadowOpacity = 0.5;// 阴影透明度
    messageBtn.layer.shadowColor = [UIColor lightGrayColor].CGColor;// 阴影的颜色
    messageBtn.layer.shadowRadius = 3;// 阴影扩散的范围控制
    [messageBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [messageBtn addTarget:self action:@selector(clickMessageBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:messageBtn];
    
    //回到原位按钮
    self.currentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.currentBtn.frame = CGRectMake(8, CGRectGetHeight(self.view.frame) - 130, 40, 40);
    [self.currentBtn setImage:[UIImage imageNamed:@"current"] forState:UIControlStateNormal];
    [self.currentBtn addTarget:self action:@selector(clickCurrentBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.currentBtn];
    
    //底部视图
    self.footView = [SearchFootView createFootView];
    self.footView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 80, CGRectGetWidth(self.view.frame), 80);
    self.footView.searchRoundBlock = ^{
        
        YFSearchViewController *vc = [[YFSearchViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [self.view addSubview:self.footView];
    
}

// init
- (AMapNaviCompositeManager *)compositeManager {
    if (!_compositeManager) {
        _compositeManager = [[AMapNaviCompositeManager alloc] init];  // 初始化
        _compositeManager.delegate = self;  // 如果需要使用AMapNaviCompositeManagerDelegate的相关回调（如自定义语音、获取实时位置等），需要设置delegate
    }
    return _compositeManager;
}


//界面显示的时候
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//按钮事件
- (void)clickCurrentBtn{
    
    _mapView.centerCoordinate = self.currentLocation.coordinate;
}

//消息界面
- (void)clickMessageBtn{
    
    MessageViewController *vc = [[MessageViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//显示位置
- (void)setCurrentName:(NSString *)currentName{
    
    _currentName = currentName;
    self.footView.nameLabel.text = currentName;
}

//位置反编码
-(void)reGeoCoding{
    
    if (_currentLocation) {
        //反编码位置获取
        AMapReGeocodeSearchRequest *request =[[AMapReGeocodeSearchRequest alloc] init];
        request.location =[AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
        request.requireExtension = YES;
        //开始请求
        [self.search AMapReGoecodeSearch:request];
        
    }
}

#pragma mark 定位更新回调
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation

{
    
    self.currentLocation = [userLocation.location copy];//获取目前位置
    //反编码
    [self reGeoCoding];
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        self.currentName = response.regeocode.formattedAddress;
    }
}

//反编码失败
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    self.currentName = @"";
}


// 导航到达目的地后的回调函数
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager didArrivedDestination:(AMapNaviMode)naviMode {
    NSLog(@"didArrivedDestination,%ld",(long)naviMode);
}

// 开始导航的回调函数
/*
 AMapNaviCompositeUserConfig *config = [[AMapNaviCompositeUserConfig alloc] init];
 [config setRoutePlanPOIType:AMapNaviRoutePlanPOITypeEnd location:[AMapNaviPoint locationWithLatitude:39.918058 longitude:116.397026] name:@"故宫" POIId:nil];  //传入终点
 [self.compositeManager presentRoutePlanViewControllerWithOptions:config];
 */
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager didStartNavi:(AMapNaviMode)naviMode {
    NSLog(@"didStartNavi,%ld",(long)naviMode);
}

@end
