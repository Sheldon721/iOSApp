//
//  TuPianLiuLanViewController.m
//  网易新闻
//
//  Created by 李晓东 on 2017/8/4.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "TuPianLiuLanViewController.h"
#import "TuPianLiuLanLayout.h"
#import "TuPianLiuLanViewCell.h"
#import "TuPianModel.h"
#import "TuPianCaoZuoViewController.h"
@interface TuPianLiuLanViewController ()<TuPianLiuLanLayoutDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
  
    BOOL _refresh;//判断是上拉刷新还是下拉
    int _pn;
    int _rn;

}
@property (nonatomic ,strong) FMDBTool *dbTool;//数据库操作对象

@end

@implementation TuPianLiuLanViewController

- (FMDBTool *)dbTool{
    if (_dbTool == nil) {
        _dbTool = [[FMDBTool alloc]init];
        _pn = 20;
    }
    return _dbTool;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    
    
    //创建新闻表
    [self.dbTool createBiao:@"create table if not exists b_photo(tp_id integer primary key autoincrement,tp_channel text not null,tp_title text not null,tp_width text not null,tp_height text not null,tp_url text not null)"];
    //删除表
    //[self.dbTool deleteBiao:@"drop table b_photo"];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //创建瀑布流视图
    [self createPuBuLiuView];
    if (_tuPianAry == nil) {
        //实例化数组
        _tuPianAry = [NSMutableArray array];
    }
    
    [_collectionView reloadData];
    
}

#pragma -mark创建瀑布流视图
- (void)createPuBuLiuView{
    //创建瀑布流Layout
    TuPianLiuLanLayout *layout = [[TuPianLiuLanLayout alloc]init];
    layout.delegate = self;
    //创建瀑布流
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kStatusHeight+kNaviHeight, kWidth, kHeight-kStatusHeight-kNaviHeight-kSafeAreaBottomHeight) collectionViewLayout:layout];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    //注册单元格
    [_collectionView registerClass:[TuPianLiuLanViewCell class] forCellWithReuseIdentifier:@"cell"];
    //给瀑布流视图添加上拉和下拉刷新控件
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _refresh = YES;
        //判断网络状态  有网加载网络数据  无网加载本地数据
      [AFNTool wangLuoLianJieZhuangTai:^(BOOL zhuang) {
          if (zhuang == YES) {
              [self qingQiuShuJu:[NSString stringWithFormat:@"http://image.baidu.com/wisebrowse/data?tag1=%@&tag2=全部&pn=0&rn=20",self.title]];
          }
          else{
              [_collectionView.mj_header endRefreshing];
              [self createTiShiKuang];
          }
      }];
        
        
    }];
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //
        _refresh = NO;
        //判断网络状态  有网加载网络数据  
        [AFNTool wangLuoLianJieZhuangTai:^(BOOL zhuang) {
        
            if (zhuang == YES) {
                _pn+= 5;
                _rn = 10;
                [self qingQiuShuJu:[NSString stringWithFormat:@"http://image.baidu.com/wisebrowse/data?tag1=%@&tag2=全部&pn=%d&rn=%d",self.title,_pn,_rn]];
                
            }
            else{
                [_collectionView.mj_header endRefreshing];
                [self createTiShiKuang];
            }
        }];

    }];
}

#pragma -mark加载本地数据
- (void)jiaZaiBenDiShuJu{
    _tuPianAry = [self.dbTool selectTuPianAll:[NSString stringWithFormat:@"select *from b_photo where tp_channel = '%@' order by tp_id desc",self.title]];
    

}
#pragma - mark 提示框
- (void)createTiShiKuang{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"检查网络设置" message:@"当前无网络，请检查您的网络设置" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma -mark请求数据
- (void)qingQiuShuJu:(NSString *)str{
    
    //参数有中文  则要进行转码
    NSString *q = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [AFNTool GET:q parameters:nil success:^(id result) {

        NSDictionary *dictAll = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        NSArray *aryTu = dictAll[@"imgs"];
        for (NSDictionary *dict in aryTu) {
            TuPianModel *modelOne = [TuPianModel mj_objectWithKeyValues:dict];
            //查找数据库中是否含有此图片
            [self.dbTool selectTiaoJian:[NSString stringWithFormat:@"select *from b_photo where tp_url = '%@'",modelOne.small_url] andCanShu:@"tp_url"];
            //不存在则存入数据库
            if (![self.dbTool.selectTitle isEqualToString:modelOne.small_url]) {
                //判断是上拉还是下拉刷新  下拉则在数组的0位置插入数据  上拉则在数组的最后位置插入数据
                if (_refresh == YES) {
                    [_tuPianAry insertObject:modelOne atIndex:0];
                }
                else{
                    [_tuPianAry insertObject:modelOne atIndex:_tuPianAry.count];
                }
                [self.dbTool addShuJu:[NSString stringWithFormat:@"insert into b_photo (tp_channel,tp_title,tp_width,tp_height,tp_url) values ('%@','%@','%@','%@','%@')",self.title,modelOne.title,modelOne.small_width,modelOne.small_height,modelOne.small_url]];
            }
        }
        //返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [_collectionView reloadData];
            //结束上下拉刷新
            [_collectionView.mj_header endRefreshing];
            [_collectionView.mj_footer endRefreshing];
        });
    } failure:^(NSError *error) {
        NSLog(@"--%@--",error);
    }];
}
/**
 *  返回每个item的高度
 */
#pragma mark-TuPianLiuLanLayoutDelegate
- (CGFloat)waterFallLayout:(TuPianLiuLanLayout *)waterFallLayout heightForItemAtIndex:(NSUInteger)index width:(CGFloat)width{
    TuPianModel *model = _tuPianAry[index];
    CGFloat shopHeight = [model.small_height doubleValue];
    return shopHeight;
}
#pragma mark-dataSource
//设置每组中的数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _tuPianAry.count;
}

//设置单元格
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TuPianLiuLanViewCell *cell = (TuPianLiuLanViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (_tuPianAry.count != 0) {
        TuPianModel *model = _tuPianAry[indexPath.row];
         cell.model = model;
    }
    
   
    return cell;
}
//单击cell调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TuPianCaoZuoViewController *tpcz = [[TuPianCaoZuoViewController alloc]init];
    tpcz.tuPianAry = _tuPianAry;
    tpcz.indexPath = indexPath;
    [self presentViewController:tpcz animated:YES completion:nil];
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
