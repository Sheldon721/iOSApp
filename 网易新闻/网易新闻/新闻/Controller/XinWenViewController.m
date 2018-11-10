//
//  XinWenViewController.m
//  网易新闻
//
//  Created by 李晓东 on 2017/6/20.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "XinWenViewController.h"
#import "XInWenNaviCell.h"
#import "XinWenTableView.h"
#import "XinWenTableViewDelegate.h"
#import "XinWenModel.h"
#import "XinWenLeiXingModel.h"
@interface XinWenViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *_naviAry;//导航视图上的信息按钮
    NSString *_fileNavi;//新闻类型文件路径
    NSString *_fileNotSelectedNavi;//未选新闻类型文件路径
    NSMutableArray *_notSelectedAry;//未选的按钮
    NSMutableArray *_wholeAry;//储存全部的按钮
    UIScrollView *_naviScrollView;//滚动视图
    UICollectionView *_collectionView;
    UIView *_xinWenLeiXing;//显示全部新闻类型的视图
    NSString *_btnStr;//储存点击的按钮标题
    UIButton *_oneBtn;//设置第一个按钮颜色
    BOOL _ref;//用于判断上下拉刷新
    int start;//请求起始条数
    int num;//请求终始条数
    NSFileManager *_fileManager;//文件管理器
    NSString *_yiDong;//移动的数据
    NSMutableArray *_btnAry;
}
@property (nonatomic ,strong) XinWenTableViewDelegate *tableDelegate;
@property (nonatomic ,strong) XinWenTableView *XinWenTableView;
@property (nonatomic ,strong) FMDBTool *dbTool;//数据库操作对象
@property (nonatomic ,strong) UIButton *btnT; //用于设置按钮的字体颜色
@property (nonatomic ,strong) NSMutableArray *modelAry;//存储模型对象


@end

@implementation XinWenViewController
static NSString *shiJi;
- (FMDBTool *)dbTool{
    if (_dbTool == nil) {
        _dbTool = [[FMDBTool alloc]init];
        start = 20;
    }
    return _dbTool;
}
- (NSMutableArray *)modelAry{
    if (_modelAry == nil) {
        _modelAry = [[NSMutableArray alloc]init];
    }
    return _modelAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _btnAry = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //获取沙盒 Document目录
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    _fileNavi = [path stringByAppendingPathComponent:@"navi.plist"];
    _fileNotSelectedNavi = [path stringByAppendingPathComponent:@"notNavi.plist"];
    //文件管理器
    _fileManager = [NSFileManager defaultManager];
    //判断文件是否存在   不存在初始化一个  存在加载文件
    if ([_fileManager fileExistsAtPath:_fileNavi] == NO) {
        _naviAry = [NSMutableArray arrayWithObjects:@"头条",@"新闻",@"财经",@"体育",@"娱乐",@"军事",@"教育",@"科技",@"NBA", nil];
    }
    else{
        _naviAry = [NSMutableArray arrayWithContentsOfFile:_fileNavi];
    }
    
    [self createNaviShiTU:_naviAry.count];
    //创建➕号按钮
    [self createJiaHao];
    //创建表视图
    [self createBiaoShiTu];
    //创建数据库
    [self.dbTool createShuJuKu];
    //创建新闻表
    [self.dbTool createBiao:@"create table if not exists b_news(xw_id integer primary key autoincrement,xw_channel text not null,xw_title text not null,xw_time text not null,xw_src text not null,xw_category text not null,xw_pic text,xw_content text not null,xw_url text not null,xw_weburl text not null)"];
    //创建评论表
    [self.dbTool createBiao:@"create table if not exists b_ping(pl_id integer primary key autoincrement,pl_image text not null,pl_name text not null,pl_content text not null,pl_title text not null)"];
    //创建收藏表
    [self.dbTool createBiao:@"create table if not exists b_cang(sc_id integer primary key autoincrement,sc_title text not null,sc_time text not null,sc_src text not null,sc_category text not null,sc_pic text,sc_content text not null,sc_url text not null,sc_weburl text not null)"];
    //删除表
//    [self.dbTool deleteBiao:@"drop table b_news"];
    _btnStr = _naviAry[0];
    [self benDiShuJu:_btnStr];
    //判断数据库中是否存在数据    不存在则加载网络数据  存在加载本地数据
    if (self.modelAry.count == 0) {
        [_XinWenTableView.mj_header beginRefreshing];
    }
    else{
        //传值  更新ui
        self.tableDelegate.modelAry = self.modelAry;
        [_XinWenTableView reloadData];
    }
    [self btnColor:_oneBtn];
    
}
#pragma -mark创建导航视图
- (void)createNaviShiTU:(NSInteger)zhi{
    //创建滚动视图
    _naviScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kStatusHeight+kNaviHeight, kWidth-40, 40)];
    //创建按钮
    [self createBtn:zhi];
    [self.view addSubview:_naviScrollView];
    //_naviScrollView.sd_layout.topEqualToView(self.navigationController.navigationBar).widthIs(kWidth).heightIs(40);
    _naviScrollView.backgroundColor = [UIColor whiteColor];
    //简单点说就是automaticallyAdjustsScrollViewInsets根据按所在界面的status bar，navigationbar，与tabbar的高度，自动调整scrollview的 inset,设置为no，不让viewController调整，我们自己修改布局即可
    if (@available(ios 11.0,*)) {
        
    }
    else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
   // self.automaticallyAdjustsScrollViewInsets = NO;
    //_naviScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    //设置滚动视图大小
    _naviScrollView.contentSize = CGSizeMake(10+55*zhi, 0);
    //关闭水平滚动条
    _naviScrollView.showsHorizontalScrollIndicator = NO;

    
}
#pragma -mark创建新闻类型按钮
- (void)createBtn:(NSInteger)zhi{
    for (int i= 0; i<zhi; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20+55*i, 0, 40, 40);
        [btn setTitle:_naviAry[i] forState:UIControlStateNormal];
        
        btn.tag = 100 + i;
        
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        if (i==0) {
            _oneBtn = btn;
        }
        [_btnAry addObject:btn];
        [btn addTarget:self action:@selector(naviBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_naviScrollView addSubview:btn];
    }
    
}
- (void)naviBtn:(UIButton *)sender{
        if (sender.tag == 100) {
           
            //加载数据
            [self sheZhi:sender];
            
        }
        else if (sender.tag == 101){
            
            //加载数据
            [self sheZhi:sender];
            
        }
        else if (sender.tag == 102){
            
            //加载数据
            [self sheZhi:sender];
        }
        else if (sender.tag == 103){
           
            //加载数据
            [self sheZhi:sender];
        }
        else if (sender.tag == 104){
            
            //加载数据
            [self sheZhi:sender];
        }
        else if (sender.tag == 105){
            
            //加载数据
            [self sheZhi:sender];
        }
        else if (sender.tag == 106){
            
            //加载数据
            [self sheZhi:sender];
        }
        else if (sender.tag == 107){
            
            //加载数据
            [self sheZhi:sender];
        }
        else if (sender.tag == 108){
            
            //加载数据
            [self sheZhi:sender];
        }
        else if (sender.tag == 109){
            
            //加载数据
            [self sheZhi:sender];
        }
        else if (sender.tag == 110){
           
            //加载数据
            [self sheZhi:sender];
        }
        else if (sender.tag == 111){
            
            //加载数据
            [self sheZhi:sender];
        }
        else if (sender.tag == 112){
            
            //加载数据
            [self sheZhi:sender];
        }
        else if (sender.tag == 113){
            
            //加载数据
            [self sheZhi:sender];
        }
    

}
#pragma -mark加载频道数据
- (void)sheZhi:(UIButton *)sender{
    CGPoint offsetPoint = _naviScrollView.contentOffset;
    offsetPoint.x = sender.center.x - kWidth / 2;
    //左边超出处理
    if (offsetPoint.x < 0) {
        offsetPoint.x = 0;
    }
    CGFloat maxX = _naviScrollView.contentSize.width - kWidth+40;
    //右边超出处理
    if (offsetPoint.x > maxX) {
        offsetPoint.x = maxX;
    }
    //设置滚动视图偏移量
    [_naviScrollView setContentOffset:offsetPoint animated:YES];
    
    
    //判断数组不为空  则清空数组
    if (self.modelAry.count != 0) {
        [self.modelAry removeAllObjects];
    }
    _btnStr = sender.titleLabel.text;
    //判断数据库中是否存在数据    不存在则加载网络数据  存在加载本地数据
    [self benDiShuJu:_btnStr];
    if (self.modelAry.count == 0) {
        [_XinWenTableView.mj_header beginRefreshing];
    }
    else{
        //传值  更新ui
        self.tableDelegate.modelAry = self.modelAry;
        [_XinWenTableView reloadData];
    }
    
    //设置按钮颜色
    [self btnColor:sender];

}
#pragma -mark设置按钮颜色
- (void)btnColor:(UIButton *)sender{
    [self.btnT setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.btnT = sender;
    
    [self.btnT setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

#pragma -mark请求数据
- (void)qingQiuShuJu:(NSString *)str{
   
    //参数有中文  则要进行转码
    NSString *q = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [AFNTool GET:q parameters:nil success:^(id result) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        //新闻类型模型
        XinWenLeiXingModel *leiXingModel = [XinWenLeiXingModel mj_objectWithKeyValues:dict[@"result"]];
        for (XinWenModel *modelOne in leiXingModel.list) {
            //查找数据库 是否存在此数据
            [self.dbTool selectTiaoJian:[NSString stringWithFormat:@"select *from b_news where xw_title = '%@'",modelOne.title] andCanShu:@"xw_title"];
            //不存在 则添加到数据库
            if (![self.dbTool.selectTitle isEqualToString:modelOne.title]) {
                //判断是上拉还是下拉刷新  下拉则在数组的0位置插入数据  上拉则在数组的最后位置插入数据
                if (_ref == YES) {
                    [self.modelAry insertObject:modelOne atIndex:0];
                }
                else{
                    [self.modelAry insertObject:modelOne atIndex:self.modelAry.count];
                }
                //存储到数据库
                [self.dbTool addShuJu:[NSString stringWithFormat:@"insert into b_news (xw_channel,xw_title,xw_time,xw_src,xw_category,xw_pic,xw_content,xw_url,xw_weburl) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@')",leiXingModel.channel,modelOne.title,modelOne.time,modelOne.src,modelOne.category,modelOne.pic,modelOne.content,modelOne.url,modelOne.weburl]];
                
                
            }
            
        }
        //推送一条通知
        [self registerNotification:1 andTitle:self.dbTool.xinWenModel.title andTime:self.dbTool.xinWenModel.time];
        //返回主界面更新
        dispatch_async(dispatch_get_main_queue(), ^{
            //传值  更新ui
            self.tableDelegate.modelAry = self.modelAry;
            //刷新表格
            [_XinWenTableView reloadData];
            // 结束刷新
            [self.XinWenTableView.mj_footer endRefreshing];
            [self.XinWenTableView.mj_header endRefreshing];
        });
        
        
        
        
    } failure:^(NSError *error) {
        NSLog(@"请求失败");
    }];
}
#pragma -mark创建加号按钮
- (void)createJiaHao{
    UIButton *jiaHao = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    jiaHao.backgroundColor = [UIColor whiteColor];
    [jiaHao setImage:[UIImage imageNamed:@"jia.png"] forState:UIControlStateNormal];
    [jiaHao setTintColor:[UIColor darkGrayColor]];
    jiaHao.frame =CGRectMake(kWidth-40, kNaviHeight+kStatusHeight, 40, 40);
    [self.view addSubview:jiaHao];
    [jiaHao addTarget:self action:@selector(gengGaiXinWenLeiXing) forControlEvents:UIControlEventTouchUpInside];
}
- (void)gengGaiXinWenLeiXing{
    
    //准备动画
    [UIView beginAnimations:@"animation" context:nil];
    //动画时长
    [UIView setAnimationDuration:1.0f];
    //设置动画效果 淡入淡出
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //设置转场方式
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    //执行动画
    [UIView commitAnimations];
    //判断文件是否存在
    if ([_fileManager fileExistsAtPath:_fileNotSelectedNavi] == NO) {
        _notSelectedAry = [NSMutableArray arrayWithObjects:@"股票",@"星座",@"女性",@"健康",@"育儿", nil];
    }
    else{
        _notSelectedAry = [NSMutableArray arrayWithContentsOfFile:_fileNotSelectedNavi];
    }
    _wholeAry = [NSMutableArray arrayWithObjects:_naviAry,_notSelectedAry, nil];
    //创建新闻类型视图
    [self createXinWenLeiXingShiTu];
    //设置导航栏的背景颜色
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //隐藏标签页控制器
    self.tabBarController.tabBar.hidden=YES;
    
    
}
#pragma -mark创建新闻类型视图
- (void)createXinWenLeiXingShiTu{
    //创建流布局设置类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置为垂直布局方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小
    layout.itemSize = CGSizeMake(60, 30);
    //
    [layout setSectionInset:UIEdgeInsetsMake(20, 20, 20, 20)];
    //
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    // 添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    [_collectionView addGestureRecognizer:longPress];
    //注册单元格
    [_collectionView registerClass:[XInWenNaviCell class] forCellWithReuseIdentifier:@"cell"];
    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cell"];
    //创建新闻类型视图
    _xinWenLeiXing = [[UIView alloc]initWithFrame:CGRectMake(0, kNaviHeight+kStatusHeight, kWidth, kHeight-kNaviHeight+kStatusHeight)];
    
    [_xinWenLeiXing addSubview:_collectionView];
    [self.view addSubview:_xinWenLeiXing];
    _xinWenLeiXing.backgroundColor = [UIColor whiteColor];
}
#pragma -mark设置单元格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        
        return [_wholeAry[section] count];
    }
    else{
        return [_wholeAry[section] count];
    }
    
}
#pragma -mark设置单元格
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XInWenNaviCell *cell = (XInWenNaviCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSArray *ary = _wholeAry[indexPath.section];
    cell.naviLbl.text = ary[indexPath.row];
    return cell;
}
#pragma -mark设置分组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
#pragma -mark设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 30;
}
#pragma -mark设置header的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kWidth, 40);
}
#pragma -mark设置头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        UILabel *woDe = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 40)];
        woDe.text = @"我的频道";
        woDe.font = [UIFont systemFontOfSize:20];
        [headerView addSubview:woDe];
        //
        UILabel *paiXu = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, 100, 40)];
        paiXu.text = @"拖拽可以排序";
        paiXu.font = [UIFont systemFontOfSize:14];
        [paiXu setTextColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1]];
        [headerView addSubview:paiXu];
        //
        UIView *wanChengView = [[UIView alloc]initWithFrame:CGRectMake(kWidth-80, 10, 60, 30)];
        wanChengView.layer.cornerRadius = 15;
        wanChengView.layer.borderWidth = 1;
        wanChengView.layer.borderColor = [[UIColor colorWithRed:255.0/255 green:99.0/255 blue:74.0/255 alpha:1] CGColor];
        [headerView addSubview:wanChengView];
        //
        UIButton *wanChengBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        wanChengBtn.frame = CGRectMake(kWidth-80, 10, 60, 30);
        [wanChengBtn setTitleColor:[UIColor colorWithRed:255.0/255 green:99.0/255 blue:74.0/255 alpha:1] forState:UIControlStateNormal];
        [wanChengBtn setTitle:@"完成" forState:UIControlStateNormal];
        [wanChengBtn addTarget:self action:@selector(wanCheng:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:wanChengBtn];
        
    }
    else{
        UILabel *tuiJian = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 40)];
        tuiJian.text = @"频道推荐";
        tuiJian.font = [UIFont systemFontOfSize:20];
        [headerView addSubview:tuiJian];
        UILabel *tianJia = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, 100, 40)];
        tianJia.text = @"拖拽可以排序";
        tianJia.font = [UIFont systemFontOfSize:14];
        [tianJia setTextColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1]];
        [headerView addSubview:tianJia];
    }
    return headerView;
}
#pragma -mark长按调用的方法
- (void)handlelongGesture:(UILongPressGestureRecognizer *)recognizer{
    //判断系统版本
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
       // [self action:longPress];
    } else {
        [self iOS9_Action:recognizer];
    }
}
#pragma -mark允许row移动
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回YES允许row移动
    return YES;
}
#pragma -mark移动完成时
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //当前组
    NSString *sourceKey = _wholeAry[sourceIndexPath.section];
    //目标组
    NSString *destinationKey = _wholeAry[destinationIndexPath.section];
    if (sourceKey == destinationKey) {
       //----------------------同一组移动时----------------------
       //取出移动row数据
       _yiDong = _wholeAry[sourceIndexPath.section][sourceIndexPath.row];
       //从数据源中移除该数据
       [_wholeAry[sourceIndexPath.section] removeObject:_yiDong];
       //将数据插入到数据源中的目标位置
       [_wholeAry[sourceIndexPath.section] insertObject:_yiDong atIndex:destinationIndexPath.row];
        //判断是哪一组 就写入哪个plist文件
        if (sourceIndexPath.section == 0) {
            [_wholeAry[sourceIndexPath.section] writeToFile:_fileNavi atomically:YES];
        }
        else{
            [_wholeAry[sourceIndexPath.section] writeToFile:_fileNotSelectedNavi atomically:YES];
        }
    }
    else{
       //------------------------不同组移动时---------------------
        //取出移动row数据
        _yiDong = _wholeAry[sourceIndexPath.section][sourceIndexPath.row];
        //从数据源中移除该数据
        [_wholeAry[sourceIndexPath.section] removeObject:_yiDong];
        //将数据插入到数据源中的目标位置
        [_wholeAry[destinationIndexPath.section] insertObject:_yiDong atIndex:destinationIndexPath.row];
        //判断从哪组移动
        if (sourceIndexPath.section == 0) {
            //第一组移动到第二组
            [_wholeAry[sourceIndexPath.section] writeToFile:_fileNavi atomically:YES];
            [_wholeAry[destinationIndexPath.section] writeToFile:_fileNotSelectedNavi atomically:YES];
        }
        else{
            //第二组移动到第一组
            [_wholeAry[destinationIndexPath.section] writeToFile:_fileNavi atomically:YES];
            [_wholeAry[sourceIndexPath.section] writeToFile:_fileNotSelectedNavi atomically:YES];
        }
    }
}
#pragma -mark长按手势调用
- (void)iOS9_Action:(UILongPressGestureRecognizer *)longPress
{
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        { //手势开始
            //判断手势落点位置是否在row上
            NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:[longPress locationInView:_collectionView]];
            if (indexPath == nil) {
                break;
            }
            UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:indexPath];
            [self.view bringSubviewToFront:cell];
            //iOS9方法 移动cell
            [_collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
        { // 手势改变
            // iOS9方法 移动过程中随时更新cell位置
            [_collectionView updateInteractiveMovementTargetPosition:[longPress locationInView:_collectionView]];
        }
            break;
        case UIGestureRecognizerStateEnded:
        { // 手势结束
            // iOS9方法 移动结束后关闭cell移动
            [_collectionView endInteractiveMovement];
        }
            break;
        default: //手势其他状态
            [_collectionView cancelInteractiveMovement];
            break;
    }
}
#pragma -mark完成按钮调用
- (void)wanCheng:(UIButton *)sender{
    //设置导航栏的背景颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:223.0/255 green:47.0/255 blue:48.0/255 alpha:1];
    //
    [_btnAry removeAllObjects];
    // 删除原滚动视图
    [_naviScrollView removeFromSuperview];
    //创建新滚动视图  更新新闻类型
    [self createNaviShiTU:_naviAry.count];
    //删除新闻类型视图
    [_xinWenLeiXing removeFromSuperview];
    //显示标签页控制器
    self.tabBarController.tabBar.hidden=NO;
   //-----------------判断移动的按钮是不是更改前的按钮：1.按钮没有移动到第二组则更新按钮颜色。 2.若到第二组 则加载第一组按钮的第一个并设置颜色 且判断是否存在本地数据  不存在则刷新加载
    int ci = 0;//用于判断按钮有没有移动到第二组
    int ciShu = 0;//用于拿到和原按钮一样的按钮
    //循环判断原按钮等不等于当前移动的按钮  等于就更新新按钮的颜色
    for (NSString *str in _naviAry) {
        ciShu++;
        if ([str isEqualToString:_btnStr]) {
            [self btnColor:_btnAry[ciShu-1]];
            ciShu = 0;
            ci = 1;
        }
        
    }
    if (ci==0) {
        [self btnColor:_btnAry[0]];
       
        [self benDiShuJu:_naviAry[0]];
        _btnStr = _naviAry[0];
        //判断数据库中是否存在数据    不存在则加载网络数据  存在加载本地数据
        if (self.modelAry.count == 0) {
            [_XinWenTableView.mj_header beginRefreshing];
        }
        else{
            //传值  更新ui
            self.tableDelegate.modelAry = self.modelAry;
            [_XinWenTableView reloadData];
        }
        ci = 0;
    }
}

#pragma -mark创建表视图 显示新闻详情
- (void)createBiaoShiTu{
    self.tableDelegate = [[XinWenTableViewDelegate alloc]init];
    self.tableDelegate.xwC = self;
    [self setXinWenTableView:[XinWenTableView tableViewWithFrame:CGRectMake(0, kNaviHeight+kStatusHeight+40, kWidth,kHeight-(kNaviHeight+kStatusHeight+40)-kTabBarHeight)   delegate:self.tableDelegate]];
    [self.view addSubview:self.XinWenTableView];
    [self xiaLaJiaZai];
    
}
#pragma -mark上、下拉加载
- (void)xiaLaJiaZai{
    // 默认的下拉刷新和上拉加载
    self.XinWenTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _ref = YES;
        //判断网络状态  有网加载网络数据  无网加载本地数据
        [AFNTool wangLuoLianJieZhuangTai:^(BOOL zhuang) {
            if (zhuang == YES) {
                //请求新闻数据
                [self qingQiuShuJu:[NSString stringWithFormat:@"http://api.jisuapi.com/news/get?channel=%@&start=0&num=20&appkey=%@",_btnStr,xwAppKey]];
            }
            else{
                [self.XinWenTableView.mj_header endRefreshing];
                [self createTiShiKuang];
            }
        }];
        
 
    }];
    //
    self.XinWenTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _ref = NO;
        [AFNTool wangLuoLianJieZhuangTai:^(BOOL zhuang) {
            if (zhuang == YES) {
                start += 5;
                num = 10;
                //请求新闻数据
                [self qingQiuShuJu:[NSString stringWithFormat:@"http://api.jisuapi.com/news/get?channel=%@&start=%d&num=%d&appkey=%@",_btnStr,start,num,xwAppKey]];
            }
            else{
                [self.XinWenTableView.mj_footer endRefreshing];
                [self createTiShiKuang];
            }
        }];

        
    }];
}
#pragma -mark加载本地数据
- (void)benDiShuJu:(NSString *)str{
    self.modelAry = [self.dbTool selectPinDaoAll:[NSString stringWithFormat:@"select *from b_news where xw_channel = '%@' order by xw_id desc",str]];
}
#pragma - mark 提示框
- (void)createTiShiKuang{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"检查网络设置" message:@"当前无网络，请检查您的网络设置" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:nil];
}
#pragma -mark使用 UNNotification 本地通知
-(void)registerNotification:(NSInteger )alerTime andTitle:(NSString *)title andTime:(NSString *)time{
    
    // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    
    //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:title arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:time
                                                         arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    
    // 在 alertTime 后推送本地推送
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                  triggerWithTimeInterval:alerTime repeats:NO];
    
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"FiveSecond"
                                                                          content:content trigger:trigger];
    
    //添加推送成功后的处理！
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"本地通知" message:@"成功添加推送" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//        [alert addAction:cancelAction];
//        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }];
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
