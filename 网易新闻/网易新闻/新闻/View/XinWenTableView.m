//
//  XinWenTableView.m
//  网易新闻
//
//  Created by 李晓东 on 2017/7/4.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "XinWenTableView.h"

SDCycleScrollView *cycleScrollView2;

@implementation XinWenTableView

+ (instancetype)tableViewWithFrame:(CGRect)frame delegate:(id<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>)delegate{
    //
    XinWenTableView *_xinWenTable = [[XinWenTableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    //创建轮播图
    cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, frame.size.width, 180) delegate:delegate placeholderImage:[UIImage imageNamed:@"placeholder"]];
    //设置轮播图片
    cycleScrollView2.localizationImageNamesGroup = @[@"http://n.sinaimg.cn/auto/transform/20170821/5xr6-fykcypq2556911.jpg",@"http://k.sinaimg.cn/n/news/transform/20170823/RhDC-fykcypq4705811.jpg/w320h240l8057b.jpg",@"http://n.sinaimg.cn/news/20170823/7FEt-fykcypq4224821.jpg",@"http://s.img.mix.sina.com.cn/auto/resize?size=235_156&img=http://n.sinaimg.cn/translate/20170823/4ofc-fykcpru9105142.jpg",@"http://s.img.mix.sina.com.cn/auto/resize?size=235_156&img=http://n.sinaimg.cn/translate/20170823/ihFh-fykcypq4331399.jpg"];
    //设置轮播图文字
    cycleScrollView2.titlesGroup = @[@"世界上最早高速公路秦朝建造",@"小偷被抓时担心游戏挂机会被举报",@"上千辆共享单车被丢弃广州城中村",@"台风“天鸽”来袭 深圳民众顶风前往码头观浪",@"长江支流香景源现“白沙奇雾”景观 缥缈如仙境"];
    
    //设置图片视图显示类型
    cycleScrollView2.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    //开启分页
    cycleScrollView2.showPageControl = YES;
    //当前分页控件小圆标颜色
    cycleScrollView2.currentPageDotColor = [UIColor redColor];
    
    //其他分页控件小圆标颜色
    cycleScrollView2.pageDotColor = [UIColor whiteColor];
    
    //设置轮播视图分也控件的位置
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    //设置为表头视图
    _xinWenTable.tableHeaderView = cycleScrollView2;
    _xinWenTable.dataSource = delegate;
    _xinWenTable.delegate = delegate;
    //隐藏单元格线
    _xinWenTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册单元格
    [_xinWenTable registerClass:[XinWenCell class] forCellReuseIdentifier:NSStringFromClass([XinWenCell class])];
    [_xinWenTable registerClass:[XinWenTwoCell class] forCellReuseIdentifier:NSStringFromClass([XinWenTwoCell class])];
    return _xinWenTable;
}
- (void)viewWillAppear:(BOOL)animated{
    [cycleScrollView2 adjustWhenControllerViewWillAppera];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
