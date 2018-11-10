//
//  MapManager.h
//  SF_GaoDeMAP
//
//  Created by李晓东 on 2017/10/6.
//  Copyright © 2017年 ShouNew.com. All rights reserved.
//

#import <Foundation/Foundation.h>
//基础定位类
#import <AMapFoundationKit/AMapFoundationKit.h>
//高德地图基础类
#import <MAMapKit/MAMapKit.h>
//搜索基础类
#import <AMapSearchKit/AMapSearchKit.h>
//高德导航类
#import <AMapNaviKit/AMapNaviKit.h>

typedef void(^MapBlock)();
@interface MapManager : NSObject
@property (nonatomic,strong)UIViewController *controller;
//地图对象
@property(nonatomic,strong)MAMapView *mapView;
//一个search对象，用于地理位置逆编码
@property(nonatomic,strong)AMapSearchAPI *search;
//当前定位
@property(nonatomic,strong)CLLocation *currentLocation;
//单独大头针
@property (nonatomic,strong)MAPointAnnotation *anomationPoint;
//步行导航视图
@property (nonatomic,strong)AMapNaviWalkView *walkView;
//步行导航管理员
@property (nonatomic,strong)AMapNaviWalkManager *walkManager;
//导航起点
@property (nonatomic,strong)AMapNaviPoint *startPoint;
//导航终点
@property (nonatomic,strong)AMapNaviPoint *endPoint;
//驾车导航视图
@property (nonatomic,strong)AMapNaviDriveView *driveView;
//驾车导航管理员
@property (nonatomic,strong)AMapNaviDriveManager *driveManager;
//目的地图片名
@property (nonatomic,strong)NSString *destinationImgName;
//定位大头针图片名
@property (nonatomic,strong)NSString *locationPointImgName;
//回到原来的位置
@property(nonatomic,assign)BOOL returnCurrent;
//初始化单例管理员对象
+(instancetype)sharedManager;
//初始化地图
-(void)initMapView;
//初始化搜索对象
-(void)initSearch;
//带回调的地图初始化方法
-(void)initMapViewWithBlock:(MapBlock)block;
//根据关键字搜索附近
-(void)searchAroundWithKeyWords:(NSString *)keywords;
//添加一个大头针
-(void)addAnomationWithCoor:(CLLocationCoordinate2D)coor;
//轨迹回放线
-(void)drawLineWithArray:(NSArray *)array;
//轨迹回放点
-(void)addAnomationWithArray:(NSArray *)array;
@end
