//
//  FMDBTool.h
//  网易新闻
//
//  Created by 李晓东 on 2017/7/7.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "XinWenModel.h"
#import "TuPianModel.h"
#import "ShiPingModel.h"
#import "YongHuModel.h"
#import "PingLunModel.h"
@interface FMDBTool : NSObject
@property (nonatomic ,strong)FMDatabaseQueue *dbQueue;//表示一个单独的数据库，用了执行SQL语句
@property (nonatomic ,strong)NSString *selectTitle;//
@property (nonatomic ,strong)XinWenModel *xinWenModel;//新闻对象模型
@property (nonatomic ,strong)TuPianModel *tuPianModel;//图片对象模型
@property (nonatomic ,strong)ShiPingModel *shiPingModel;//视频对象模型
@property (nonatomic ,strong)YongHuModel *yongHuModel;//用户对象模型
@property (nonatomic ,strong)PingLunModel *pingLunModel;//评论对象模型
//创建单例
+ (id)shareTool;
//创建数据库
- (void)createShuJuKu;
//创建表
- (void)createBiao:(NSString *)str;
//删除表
- (void)deleteBiao:(NSString *)str;
//添加数据
- (void)addShuJu:(NSString *)str;
//条件查询数据
- (void)selectTiaoJian:(NSString *)str andCanShu:(NSString *)sender;
//查询新闻频道所有数据
- (NSMutableArray *)selectPinDaoAll:(NSString *)str;
//查询图片数据
- (NSMutableArray *)selectTuPianAll:(NSString *)str;
//查找视频数据
- (NSMutableArray *)selectShiPingAll:(NSString *)str;
//查找用户数据
- (NSMutableArray *)selectYongHuAll:(NSString *)str;
//查询收藏的新闻数据
- (NSMutableArray *)selectAllShouCangXinWen:(NSString *)str;
//查询评论数据
- (NSMutableArray *)selectPingLunAll:(NSString *)str;
@end
