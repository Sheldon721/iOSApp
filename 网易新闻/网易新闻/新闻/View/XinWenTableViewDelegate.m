//
//  XinWenTableViewDelegate.m
//  网易新闻
//
//  Created by 李晓东 on 2017/7/4.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "XinWenTableViewDelegate.h"
#import "SDAutoLayout.h"
#import "XinWenXianQingViewController.h"
#import "XinWenLunBoViewController.h"
@implementation XinWenTableViewDelegate
- (NSMutableArray *)modelAry{
    if (_modelAry == nil) {
        _modelAry = [[NSMutableArray alloc]init];
    }
    return  _modelAry;
}
#pragma -mark UITableViewDelagate


#pragma -mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Class currentClass = [XinWenCell class];
    XinWenModel *model = self.modelAry[indexPath.row];
    if ([model.pic isEqualToString:@""]) {
        currentClass = [XinWenTwoCell class];
    }
    XinWenCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass) forIndexPath:indexPath];
    
    cell.model = model;
    return cell;
}
#pragma -mark设置单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Class currentClass = [XinWenCell class];
    XinWenModel *model = self.modelAry[indexPath.row];
    if ([model.pic isEqualToString:@""]) {
        currentClass = [XinWenTwoCell class];
    }
    
    
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[UIScreen mainScreen].bounds.size.width];
}

#pragma -mark点击单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //push后不在显示tabbar控制器
    XinWenXianQingViewController *xwxq = [[XinWenXianQingViewController alloc]init];
    xwxq.model = self.modelAry[indexPath.row];
    //push后不在显示tabbar控制器
    self.xwC.hidesBottomBarWhenPushed = YES;
    [self.xwC.navigationController showViewController:xwxq sender:nil];
    //返回后把tabbar控制器显示
    self.xwC.hidesBottomBarWhenPushed = NO;
    
    

}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    XinWenLunBoViewController *xwlb = [[XinWenLunBoViewController alloc]init];
    if (index == 0) {
        xwlb.url = @"http://db.auto.sina.com.cn/photo/g99337-2.html#129953373";
    }
    else if (index == 1){
        xwlb.url = @"http://slide.news.sina.com.cn/s/slide_1_2841_198607.html#p=1";
    }
    else if (index == 2){
        xwlb.url = @"http://slide.news.sina.com.cn/s/slide_1_86058_198444.html#p=1";
    }
    else if (index == 3){
        xwlb.url = @"http://slide.news.sina.com.cn/s/slide_1_86058_198575.html/d/1#p=1";
    }
    else if (index == 4){
        xwlb.url = @"http://slide.news.sina.com.cn/slide_1_86058_198531.html#p=1";
    }
    //push后不在显示tabbar控制器
    self.xwC.hidesBottomBarWhenPushed = YES;
    [self.xwC.navigationController showViewController:xwlb sender:nil];
    //返回后把tabbar控制器显示
    self.xwC.hidesBottomBarWhenPushed = NO;
}

#pragma mark - 单元格显示时调用
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    ///配置 CATransform3D 动画内容
    CATransform3D  transform;
    transform.m34 = 1.0/-800;
    //定义 Cell的初始化状态
    cell.layer.transform = transform;
    //定义Cell 最终状态 并且提交动画
    [UIView beginAnimations:@"transform" context:NULL];
    [UIView setAnimationDuration:1];
    cell.layer.transform = CATransform3DIdentity;
    cell.frame = CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    [UIView commitAnimations];
}


@end
