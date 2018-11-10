//
//  CourierPhoneViewController.m
//  快易查
//
//  Created by 刘超正 on 2017/11/17.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "CourierPhoneViewController.h"
#import "CourierPhoneCell.h"
#import "CourierPhoneModel.h"
@interface CourierPhoneViewController (){
    NSMutableArray *aArray;
    NSMutableArray *bArray;
    NSMutableArray *cArray;
    NSMutableArray *dArray;
    NSMutableArray *eArray;
    NSMutableArray *fArray;
    NSMutableArray *gArray;
    NSMutableArray *hArray;
    NSMutableArray *iArray;
    NSMutableArray *jArray;
    NSMutableArray *kArray;
    NSMutableArray *lArray;
    NSMutableArray *mArray;
    NSMutableArray *nArray;
    NSMutableArray *oArray;
    NSMutableArray *pArray;
    NSMutableArray *qArray;
    NSMutableArray *rArray;
    NSMutableArray *sArray;
    NSMutableArray *tArray;
    NSMutableArray *uArray;
    NSMutableArray *vArray;
    NSMutableArray *wArray;
    NSMutableArray *xArray;
    NSMutableArray *yArray;
    NSMutableArray *zArray;
}
/** tableView代理 */
@property (nonatomic,strong) TableViewDelagate *tableViewDelagate;


@end

@implementation CourierPhoneViewController

#pragma mark - tableView代理懒加载
- (TableViewDelagate *)tableViewDelagate{
    if (_tableViewDelagate == nil) {
        _tableViewDelagate = [[TableViewDelagate alloc]init];
    }
    return _tableViewDelagate;
}
#pragma mark - 懒加载数组。 存储分组中的A~Z
- (NSArray *)sectionAry{
    if (_sectionAry == nil) {
        _sectionAry = [NSArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z", nil];
    }
    return _sectionAry;
}

- (NSMutableDictionary *)modelDict{
    if (_modelDict == nil) {
        _modelDict = [NSMutableDictionary dictionary];
    }
    return _modelDict;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
    
    //监测网络状态
    [self monitoringNetworkStatus];
}

#pragma mark - 创建tableView
- (void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kStatusHeight+kNaviHeight, kWidth, kHeight-kStatusHeight-kNaviHeight-kTabBarHeight) style:UITableViewStyleGrouped];
    //self.tableView.backgroundColor = RGBColor(250, 250, 249, 1);
    self.tableView.delegate = self.tableViewDelagate;
    self.tableView.dataSource = self.tableViewDelagate;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[CourierPhoneCell class] forCellReuseIdentifier:@"courier"];
   // [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //传值
    self.tableViewDelagate.courierPhoneTableView = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - 监测网络状态。
- (void)monitoringNetworkStatus{
    aArray = [NSMutableArray array];
    bArray = [NSMutableArray array];
    cArray = [NSMutableArray array];
    dArray = [NSMutableArray array];
    eArray = [NSMutableArray array];
    fArray = [NSMutableArray array];
    gArray = [NSMutableArray array];
    hArray = [NSMutableArray array];
    iArray = [NSMutableArray array];
    jArray = [NSMutableArray array];
    kArray = [NSMutableArray array];
    lArray = [NSMutableArray array];
    mArray = [NSMutableArray array];
    nArray = [NSMutableArray array];
    oArray = [NSMutableArray array];
    pArray = [NSMutableArray array];
    qArray = [NSMutableArray array];
    rArray = [NSMutableArray array];
    sArray = [NSMutableArray array];
    tArray = [NSMutableArray array];
    uArray = [NSMutableArray array];
    vArray = [NSMutableArray array];
    wArray = [NSMutableArray array];
    xArray = [NSMutableArray array];
    yArray = [NSMutableArray array];
    zArray = [NSMutableArray array];
    //监测网络状态
    [AFNTool wangLuoLianJieZhuangTai:^(BOOL zhuang) {
        if (zhuang == YES) {
            //请求网络数据
            [self requestNetworkData];
        }
        else{
            //提示当前无网络
        }
    }];
}
#pragma mark - 请求网络数据
- (void)requestNetworkData{
    [AFNTool GET:[NSString stringWithFormat:@"http://api.jisuapi.com/express/type?appkey=%@",appKey] parameters:nil success:^(id result) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        NSMutableArray *modelAry = [CourierPhoneModel mj_objectArrayWithKeyValuesArray:dict[@"result"]];
        for (CourierPhoneModel *model in modelAry) {
            if (![model.tel isEqualToString:@""]) {
                if ([model.letter isEqualToString:@"A"]) {
                    [aArray addObject:model];
                }
                else if ([model.letter isEqualToString:@"B"]){
                    [bArray addObject:model];
                }
                else if ([model.letter isEqualToString:@"C"]){
                    [cArray addObject:model];
                }
                else if ([model.letter isEqualToString:@"D"]){
                    [dArray addObject:model];
                }
                else if ([model.letter isEqualToString:@"E"]){
                    [eArray addObject:model];
                }
                else if ([model.letter isEqualToString:@"F"]){
                    [fArray addObject:model];
                }
                else if ([model.letter isEqualToString:@"G"]){
                    [gArray addObject:model];
                }
                else if ([model.letter isEqualToString:@"H"]){
                    [hArray addObject:model];
                }
                else if ([model.letter isEqualToString:@"I"]){
                    [iArray addObject:model];
                }
                else if ([model.letter isEqualToString:@"J"]){
                    [jArray addObject:model];
                }
                else if ([model.letter isEqualToString:@"K"]){
                    [kArray addObject:model];
                }
                else if ([model.letter isEqualToString:@"L"]){
                    [lArray addObject:model];
                }
                else if ([model.letter isEqualToString:@"M"]){
                    [mArray addObject:model];
                }
                else if ([model.letter isEqualToString:@"N"]){
                    [nArray addObject:model];
                }
                else if ([model.letter isEqualToString:@"O"]){
                    [oArray addObject:model];
                }
                else if ([model.letter isEqualToString:@"P"]){
                    [pArray addObject:model];
                }
                else if ([model.letter isEqualToString:@"Q"]){
                    [qArray addObject:model];
                }
                else if ([model.letter isEqualToString:@"R"]){
                    [rArray addObject:model];
                }
                else if ([model.letter isEqualToString:@"S"]){
                    [sArray addObject:model];
                }
                else if ([model.letter isEqualToString:@"T"]){
                    [tArray addObject:model];
                }
                else if ([model.letter isEqualToString:@"U"]){
                    [uArray addObject:model];
                }
                else if ([model.letter isEqualToString:@"V"]){
                    [vArray addObject:model];
                }
                else if ([model.letter isEqualToString:@"W"]){
                    [wArray addObject:model];
                }
                else if ([model.letter isEqualToString:@"X"]){
                    [xArray addObject:model];
                }
                else if ([model.letter isEqualToString:@"Y"]){
                    [yArray addObject:model];
                }
                else if ([model.letter isEqualToString:@"Z"]){
                    [zArray addObject:model];
                }
            }
            
            
        }
        [_modelDict setValue:aArray forKey:@"a"];
        [_modelDict setValue:bArray forKey:@"b"];
        [_modelDict setValue:cArray forKey:@"c"];
        [_modelDict setValue:dArray forKey:@"d"];
        [_modelDict setValue:eArray forKey:@"e"];
        [_modelDict setValue:fArray forKey:@"f"];
        [_modelDict setValue:gArray forKey:@"g"];
        [_modelDict setValue:hArray forKey:@"h"];
        [_modelDict setValue:iArray forKey:@"i"];
        [_modelDict setValue:jArray forKey:@"j"];
        [_modelDict setValue:kArray forKey:@"k"];
        [_modelDict setValue:lArray forKey:@"l"];
        [_modelDict setValue:mArray forKey:@"m"];
        [_modelDict setValue:nArray forKey:@"n"];
        [_modelDict setValue:oArray forKey:@"o"];
        [_modelDict setValue:pArray forKey:@"p"];
        [_modelDict setValue:qArray forKey:@"q"];
        [_modelDict setValue:rArray forKey:@"r"];
        [_modelDict setValue:sArray forKey:@"s"];
        [_modelDict setValue:tArray forKey:@"t"];
        [_modelDict setValue:uArray forKey:@"u"];
        [_modelDict setValue:vArray forKey:@"v"];
        [_modelDict setValue:wArray forKey:@"w"];
        [_modelDict setValue:xArray forKey:@"x"];
        [_modelDict setValue:yArray forKey:@"y"];
        [_modelDict setValue:zArray forKey:@"z"];
        
        //更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSError *error) {
        
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
