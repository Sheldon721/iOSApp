//
//  TableViewDelagate.m
//  快易查
//
//  Created by 刘超正 on 2017/11/17.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "TableViewDelagate.h"
#import "SendSpecialDeliveryCell.h"
#import "QueryCourierCell.h"
#import "PersonalCenterCell.h"
#import "CourierPhoneCell.h"
#import "CourierPhoneModel.h"
#import "QueryCourierModel.h"
#import "LogisticsDetailsViewController.h"
@implementation TableViewDelagate{
    QueryCourierCell *_queryCourierCell;
    UIButton *sendButton;//预约寄件按钮
    NSInteger sectionX;
}

#pragma mark - 每组中的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.sendSpecialDeliveryTableView.tableView) {
        return 2;
    }
    else if (tableView == self.queryCourierTableView.tableView){
        return 1;
    }
    else if (tableView == self.courierPhoneTableView.tableView){
        //sectionX = section;
        NSString *str = self.courierPhoneTableView.sectionAry[section];
        NSMutableArray *ary = [self.courierPhoneTableView.modelDict objectForKey:str];
        return ary.count;
    }
    else{
        return 5;
    }
}

#pragma mark - 设置分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.courierPhoneTableView.tableView) {

        return self.courierPhoneTableView.sectionAry.count;
    }
    else{
        return 1;
    }
}

#pragma mark - 设置分组
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.courierPhoneTableView.tableView) {
        NSString *str = self.courierPhoneTableView.sectionAry[section];
        NSMutableArray *ary = [self.courierPhoneTableView.modelDict objectForKey:str];
        if (ary.count == 0) {
            return nil;
        }
        else{
            return self.courierPhoneTableView.sectionAry[section];
        }
        
    }
    else{
        return nil;
    }
}

#pragma mark -设置分区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.courierPhoneTableView.tableView) {
        NSString *str = self.courierPhoneTableView.sectionAry[section];
        NSMutableArray *ary = [self.courierPhoneTableView.modelDict objectForKey:str];
        if (ary.count == 0) {
            return 0.1;
        }
        else{
            return 30;
        }
    }
    else if (tableView == self.queryCourierTableView.tableView){
        return 180;
    }
    else{
        return 0.1;
    }
}

#pragma mark - 设置索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView == self.courierPhoneTableView.tableView) {
        if (self.courierPhoneTableView.modelDict.count == 0) {
            return nil;
        }
        else{
            return self.courierPhoneTableView.sectionAry;
        }
    }
    else{
        return nil;
    }
}
#pragma mark - 单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.sendSpecialDeliveryTableView.tableView) {
        SendSpecialDeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"send" forIndexPath:indexPath];
        //添加箭头
       // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //选中无颜色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.postingImgV.backgroundColor = RGBColor(57, 187, 119, 1);
            cell.imgViewTitle.text = @"寄";
            cell.address.placeholder = @"请输入寄件人详细地址";
        }
        else{
            cell.postingImgV.backgroundColor = RGBColor(222, 44, 46, 1);
            cell.imgViewTitle.text = @"收";
            cell.address.placeholder = @"请输入收件人详细地址";
        }
        //添加通知监听文本框的值
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(addressTextDidChange)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:cell.address];
        return cell;
    }
    else if (tableView == self.queryCourierTableView.tableView){
        _queryCourierCell = [tableView dequeueReusableCellWithIdentifier:@"query" forIndexPath:indexPath];
        //单元格背景颜色
        _queryCourierCell.backgroundColor = RGBColor(250, 250, 248, 1);
        //选中无颜色
        _queryCourierCell.selectionStyle = UITableViewCellSelectionStyleNone;
        //添加通知监听文本框的值
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldTextDidChange)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:_queryCourierCell.waybillBox];
        //查询按钮响应事件
        [_queryCourierCell.enquiries addTarget:self action:@selector(queryLogisticsInformation:) forControlEvents:UIControlEventTouchUpInside];
        return _queryCourierCell;
    }
    else if (tableView == self.courierPhoneTableView.tableView){
        CourierPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courier" forIndexPath:indexPath];
        //选中无颜色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *str = self.courierPhoneTableView.sectionAry[indexPath.section];
        NSMutableArray *ary = [self.courierPhoneTableView.modelDict objectForKey:str];
        cell.model = ary[indexPath.row];
        return cell;
    }
    else{
        return nil;
    }
}

#pragma mark - 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.sendSpecialDeliveryTableView.tableView) {
        return 60;
    }
    else if (tableView == self.queryCourierTableView.tableView){
        return 200;
    }
    else if (tableView == self.courierPhoneTableView.tableView){
        return 80;
    }
    else{
        return 60;
    }
}


#pragma mark - 头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.queryCourierTableView.tableView) {
        SDCycleScrollView *sCycleScrollView = [[SDCycleScrollView alloc]init];
        sCycleScrollView.delegate = self;
        //设置轮播图片
        sCycleScrollView.localizationImageNamesGroup = @[@"http://img.zto.cn/ServiceFiles/636460353424972348.jpg",@"http://www.sf-express.com/.gallery/other/24Hbanner-1349-487.jpg",@"http://www.yundaex.com/cn/images/banner/index_banner_10.png",@"http://www.ems.com.cn/images/slider/lunbo.png"];
        //设置轮播图文字
       // sCycleScrollView.titlesGroup = @[@"世界上最早高速公路秦朝建造",@"小偷被抓时担心游戏挂机会被举报",@"上千辆共享单车被丢弃广州城中村",@"台风“天鸽”来袭 深圳民众顶风前往码头观浪",@"长江支流香景源现“白沙奇雾”景观 缥缈如仙境"];
        
        //设置图片视图显示类型
        sCycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        //开启分页
        sCycleScrollView.showPageControl = YES;
        //当前分页控件小圆标颜色
        sCycleScrollView.currentPageDotColor = [UIColor redColor];
        
        //其他分页控件小圆标颜色
        sCycleScrollView.pageDotColor = [UIColor whiteColor];
        
        //设置轮播视图分也控件的位置
        sCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        return sCycleScrollView;
    }
    else{
        return nil;
    }
}

#pragma mark - 尾部视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.sendSpecialDeliveryTableView.tableView) {
        return 500;
    }
    return 0;
}

#pragma mark - 尾部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == self.sendSpecialDeliveryTableView.tableView) {
        UIView *footerView = [[UIView alloc]init];
        //寄件按钮
        sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendButton.backgroundColor = RGBColor(199, 199, 199, 1);
        [sendButton setTitle:@"预约寄件" forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(sendMethod:) forControlEvents:UIControlEventTouchUpInside];
        sendButton.enabled = NO;
        [footerView addSubview:sendButton];
        //分割线
        UIView *dividingLine = [[UIView alloc]init];
        dividingLine.backgroundColor = RGBColor(242, 241, 242, 1);
        [footerView addSubview:dividingLine];
        //温馨提示
        UILabel *warmTipsLabel = [[UILabel alloc]init];
        warmTipsLabel.numberOfLines = 0;
        [footerView addSubview:warmTipsLabel];
        warmTipsLabel.text = @"温馨提示：请填写正确的联系方式，预约成功后我们的工作人员将会在2小时内联系您";
        [warmTipsLabel setTextColor:RGBColor(158, 158, 158, 1)];
        [warmTipsLabel setFont:[UIFont systemFontOfSize:14]];
        //设置行高
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:warmTipsLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:20];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [warmTipsLabel.text length])];
        warmTipsLabel.attributedText = attributedString;
        [warmTipsLabel sizeToFit];
        //居中
        [warmTipsLabel setTextAlignment:NSTextAlignmentCenter];
        //添加约束
        [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(footerView).offset(70);
            make.left.equalTo(footerView).offset(50);
            make.right.equalTo(footerView).offset(-50);
            make.height.equalTo(@50);
        }];
        [dividingLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sendButton.mas_bottom).offset(50);
            make.left.equalTo(footerView).offset(30);
            make.right.equalTo(footerView).offset(-30);
            make.height.equalTo(@1);
        }];
        [warmTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dividingLine.mas_bottom).offset(10);
            make.left.right.equalTo(dividingLine);
            
        }];
        
        return footerView;
    }
    else{
        return nil;
    }
}

#pragma mark - 单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.courierPhoneTableView.tableView) {
        NSString *str = self.courierPhoneTableView.sectionAry[indexPath.section];
        NSMutableArray *ary = [self.courierPhoneTableView.modelDict objectForKey:str];
        CourierPhoneModel *model = ary[indexPath.row];
        //调用系统电话
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",model.tel]] options:@{} completionHandler:nil];

    }
    else{
        NSLog(@"12321321");
    }
    
}


//----------------------------------------------------------------

#pragma mark - 查询按钮响应事件
- (void)queryLogisticsInformation:(UIButton *)sender{
    //71198885561329
    [AFNTool GET:[NSString stringWithFormat:@"http://api.jisuapi.com/express/query?appkey=%@&type=auto&number=%@",appKey,_queryCourierCell.waybillBox.text] parameters:nil success:^(id result) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        NSDictionary *dict2 = dict[@"result"];
        NSMutableArray *modelAry = [QueryCourierModel mj_objectArrayWithKeyValuesArray:dict2[@"list"]];
        
        //返回主线程。跳转控制器
       // dispatch_sync(dispatch_get_main_queue(), ^{
        LogisticsDetailsViewController *ldVC = [[LogisticsDetailsViewController alloc]init];
        ldVC.navigationItem.title = @"查看物流";
        ldVC.modelAry = modelAry;
        self.queryCourierTableView.hidesBottomBarWhenPushed = YES;
        [self.queryCourierTableView.navigationController pushViewController:ldVC animated:YES];
        self.queryCourierTableView.hidesBottomBarWhenPushed = NO;
      //  });
//        NSLog(@"%ld",modelAry.count);
//        for (QueryCourierModel *model in modelAry) {
//            NSLog(@"%@-%@",model.time,model.status);
//        }
    } failure:^(NSError *error) {
        
    }];
   // NSLog(@"24234%@",_queryCourierCell.waybillBox.text);
    
}

#pragma mark - 预约寄件响应方法
- (void)sendMethod:(UIButton *)sender{
    [self.sendSpecialDeliveryTableView.tableView endEditing:YES];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"预约成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:action];
    [self.sendSpecialDeliveryTableView presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - 寄快递文本框值改变时调用
- (void)addressTextDidChange{
    //获取第一个文本框的值
    NSIndexPath *indexOne = [NSIndexPath indexPathForRow:0 inSection:0];
    SendSpecialDeliveryCell *cellOne = [self.sendSpecialDeliveryTableView.tableView cellForRowAtIndexPath:indexOne];
    //获取第二个文本框的值
    NSIndexPath *indexTwo = [NSIndexPath indexPathForRow:1 inSection:0];
    SendSpecialDeliveryCell *cellTwo = [self.sendSpecialDeliveryTableView.tableView cellForRowAtIndexPath:indexTwo];
    if ([cellOne.address.text isEqualToString:@""] || [cellTwo.address.text isEqualToString:@""]) {
        sendButton.backgroundColor = RGBColor(199, 199, 199, 1);
        sendButton.enabled = NO;
        
    }
    else{
        sendButton.backgroundColor = RGBColor(224, 50, 47, 1);
        sendButton.enabled = YES;
    }
}

#pragma mark -查询快递文本框值改变时调用
- (void)textFieldTextDidChange{
    if ([_queryCourierCell.waybillBox.text isEqualToString:@""]) {
        _queryCourierCell.enquiries.backgroundColor = RGBColor(199, 199, 199, 1);
        _queryCourierCell.enquiries.enabled = NO;
    }
    else{
        _queryCourierCell.enquiries.backgroundColor = RGBColor(224, 50, 47, 1);
        _queryCourierCell.enquiries.enabled = YES;
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
