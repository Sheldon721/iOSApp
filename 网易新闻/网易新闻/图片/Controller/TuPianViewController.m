//
//  TuPianViewController.m
//  网易新闻
//
//  Created by 李晓东 on 2017/6/20.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "TuPianViewController.h"
#import "TuPianLiuLanViewController.h"
@interface TuPianViewController ()
{
    UIScrollView *_scrollV;//滚动视图
    NSDictionary *_dictImg;//存图片字典
    NSDictionary *_dictTitle;//存图片标题字典
    NSDictionary *_dictAction;//存按钮方法字典
}
@property (nonatomic,strong) TuPianLiuLanViewController *liuLanViewC;
@end

@implementation TuPianViewController

- (TuPianLiuLanViewController *)liuLanViewC{
    if (_liuLanViewC == nil) {
        _liuLanViewC = [[TuPianLiuLanViewController alloc]init];
    }
    return _liuLanViewC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //UIImageView *imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"za4_img.jpg"]];
   // imgV.frame = CGRectMake(0, 64, kWidth, kHeight-108);
    //[self.view addSubview:imgV];
    //创建滚动视图
    [self createGunDongShiTu];
    
    
}
#pragma -mark创建滚动视图
- (void)createGunDongShiTu{
    _scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-108)];
    if (@available(ios 11.0,*)) {
        
    }
    else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _scrollV.contentSize = CGSizeMake(0, 50+220*5);
    [self createDict];
    [self createBtn];
    [self.view addSubview:_scrollV];
//NSLog(@"%@",[AFNTool wangLuoLianJieZhuangTai]?@"yes":@"no");
}
- (void)createDict{
    _dictImg = @{@"0":@[@"chongwu.png",@"dongman.png"],@"1":@[@"hunjia.png",@"jiaju.png"],@"2":@[@"meinv.png",@"meishi.png"],@"3":@[@"mingxing.png",@"qiche.png"],@"4":@[@"sheji.png",@"sheying.png"]};
    _dictTitle = @{@"0":@[@"宠物",@"动漫"],@"1":@[@"婚嫁",@"家居"],@"2":@[@"美女",@"美食"],@"3":@[@"明星",@"汽车"],@"4":@[@"设计",@"摄影"]};
    _dictAction = @{@"0":@[@"chongWu:",@"dongMan:"],@"1":@[@"hunJia:",@"jiaJu:"],@"2":@[@"meiNv:",@"meiShi:"],@"3":@[@"mingXing:",@"qiChe:"],@"4":@[@"sheJi:",@"sheYing:"]};
}
- (void)createBtn{
    for (int y = 0; y<5; y++) {
        for (int x = 0; x<2; x++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            UILabel *lbl = [[UILabel alloc]init];
            btn.frame = CGRectMake(kWidth*0.05+((kWidth -kWidth*0.05*2)/2+kWidth*0.05)*x, 20+220*y,(kWidth -kWidth*0.05*2)/2-kWidth*0.05, 200);
            [btn setImage:[UIImage imageNamed:[_dictImg objectForKey:[NSString stringWithFormat:@"%d",y]][x]] forState:UIControlStateNormal];
            //单击事件
            [btn addTarget:self action:NSSelectorFromString([_dictAction objectForKey:[NSString stringWithFormat:@"%d",y]][x]) forControlEvents:UIControlEventTouchUpInside];
            //设置文字
            lbl.frame = CGRectMake(((kWidth -kWidth*0.05*2)/2-kWidth*0.05)/2-35, 150, 70, 30);
            [lbl setText:[_dictTitle objectForKey:[NSString stringWithFormat:@"%d",y]][x]];
            //字体居中
            [lbl setTextAlignment:NSTextAlignmentCenter];
            [btn addSubview:lbl];
            [_scrollV addSubview:btn];
        }
    }
}
- (void)chongWu:(UIButton *)sender{
    
    [self navi:@"宠物"];
    
}
- (void)dongMan:(UIButton *)sender{
    
    [self navi:@"动漫"];

}
- (void)hunJia:(UIButton *)sender{
    
    [self navi:@"婚嫁"];
    
    
}
- (void)jiaJu:(UIButton *)sender{
    
    [self navi:@"家居"];
    
}
- (void)meiNv:(UIButton *)sender{
    
    [self navi:@"美女"];
   
}
- (void)meiShi:(UIButton *)sender{
    
    [self navi:@"美食"];
    
}
- (void)mingXing:(UIButton *)sender{
    
    [self navi:@"明星"];
    
}
- (void)qiChe:(UIButton *)sender{
    
    [self navi:@"汽车"];
    
}
- (void)sheJi:(UIButton *)sender{
    
    [self navi:@"设计"];
    
}
- (void)sheYing:(UIButton *)sender{
    
    [self navi:@"摄影"];
    
}
- (void)navi:(NSString *)sender{
    
    //push后不在显示tabbar控制器
    self.hidesBottomBarWhenPushed = YES;
    //判断图片数组是否为空  不为空则清空数组
    if (self.liuLanViewC.tuPianAry.count != 0) {
        [self.liuLanViewC.tuPianAry removeAllObjects];
    }
    [self.navigationController pushViewController:self.liuLanViewC animated:NO];
    self.liuLanViewC.title = sender;
    //模拟延迟
    [self performSelector:@selector(tiao) withObject:nil afterDelay:1];
    //返回后把tabbar控制器显示
    self.hidesBottomBarWhenPushed = NO;
}
- (void)tiao{
    
    [self.liuLanViewC jiaZaiBenDiShuJu];
    if (self.liuLanViewC.tuPianAry.count == 0) {
        [self.liuLanViewC.collectionView.mj_header beginRefreshing];
    
    }
    else{
        [self.liuLanViewC.collectionView reloadData];
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
