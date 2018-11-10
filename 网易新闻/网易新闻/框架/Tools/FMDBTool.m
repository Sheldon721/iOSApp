//
//  FMDBTool.m
//  网易新闻
//
//  Created by 李晓东 on 2017/7/7.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "FMDBTool.h"
#import "XinWenModel.h"
#import "XinWenLeiXingModel.h"

@implementation FMDBTool


//-----------------创建单例---------------------------
static FMDBTool *_tool = nil;

+ (id)shareTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tool = [[self alloc]init];
    });
    
    return _tool;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tool = [[super allocWithZone:zone]init];
    });
    
    return _tool;
}
//----------------------------------------------

- (void)createShuJuKu{
    //获取沙盒路径 数据库路径
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/ShuJuKu.db"];
    NSLog(@"%@",filePath);
    //创建数据库
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    
}

//
- (void)createBiao:(NSString *)str{
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db open];
        BOOL createTable = [db executeUpdate:str];
        if (createTable) {
            NSLog(@"创建表成功");
        }
        else{
            NSLog(@"创建表失败");
        }
        [db close];
    }];
    
}

//
- (void)deleteBiao:(NSString *)str{
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
       [db open];
       BOOL deleTable = [db executeUpdate:str];
        if (deleTable) {
            NSLog(@"删除成功");
        }
        else{
            NSLog(@"删除失败");
        }
        [db close];;
    }];
}

//
- (void)addShuJu:(NSString *)str{
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db open];
        BOOL add = [db executeUpdate:str];
        if (add) {
            NSLog(@"添加成功");
        }
        else{
            NSLog(@"添加失败");
        }
        [db close];
    }];
}

//
- (void)selectTiaoJian:(NSString *)str andCanShu:(NSString *)sender{
    self.selectTitle = @"";
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db open];
        FMResultSet *rs = [db executeQuery:str];
        while ([rs next]) {
            self.selectTitle = [rs stringForColumn:sender];
        }
        [db close];
    }];

}

-(NSMutableArray *)selectPinDaoAll:(NSString *)str{
    __block NSMutableArray *_ary;
    if (_ary == nil) {
        _ary = [[NSMutableArray alloc]init];
    }
    //删除原数据
    [_ary removeAllObjects];
    
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db open];
        FMResultSet *rs = [db executeQuery:str];
        while ([rs next]) {
            self.xinWenModel = [[XinWenModel alloc]init];
            self.xinWenModel.title = [rs stringForColumn:@"xw_title"];
            self.xinWenModel.time  = [rs stringForColumn:@"xw_time"];
            self.xinWenModel.src  = [rs stringForColumn:@"xw_src"];
            self.xinWenModel.category  = [rs stringForColumn:@"xw_category"];
            self.xinWenModel.pic  = [rs stringForColumn:@"xw_pic"];
            self.xinWenModel.content  = [rs stringForColumn:@"xw_content"];
            self.xinWenModel.url  = [rs stringForColumn:@"xw_url"];
            self.xinWenModel.weburl  = [rs stringForColumn:@"xw_weburl"];
            [_ary addObject:self.xinWenModel];
        }
        [db close];
    }];
    return _ary;
}

- (NSMutableArray *)selectTuPianAll:(NSString *)str{
    __block NSMutableArray *_ary;
    if (_ary == nil) {
        _ary = [[NSMutableArray alloc]init];
    }
    //删除原数据
    [_ary removeAllObjects];
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db open];
        FMResultSet *rs = [db executeQuery:str];
        while ([rs next]) {
            self.tuPianModel = [[TuPianModel alloc]init];
            self.tuPianModel.title = [rs stringForColumn:@"tp_title"];
            self.tuPianModel.small_width = [rs stringForColumn:@"tp_width"];
            self.tuPianModel.small_height = [rs stringForColumn:@"tp_height"];
            self.tuPianModel.small_url = [rs stringForColumn:@"tp_url"];
            [_ary addObject:self.tuPianModel];
        }
        [db close];
    }];
    return _ary;
}

- (NSMutableArray *)selectShiPingAll:(NSString *)str{
    __block NSMutableArray *_ary;
    if (_ary == nil) {
        _ary = [[NSMutableArray alloc]init];
    }
    //删除原数据
    [_ary removeAllObjects];
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db open];
        FMResultSet *rs = [db executeQuery:str];
        while ([rs next]) {
            self.shiPingModel = [[ShiPingModel alloc]init];
            self.shiPingModel.title = [rs stringForColumn:@"sp_title"];
            self.shiPingModel.Description = [rs stringForColumn:@"sp_description"];
            self.shiPingModel.cover = [rs stringForColumn:@"sp_cover"];
            self.shiPingModel.length = (float)[rs doubleForColumn:@"sp_length"];
            self.shiPingModel.playCount = [rs stringForColumn:@"sp_playCount"];
            self.shiPingModel.ptime = [rs stringForColumn:@"sp_ptime"];
            self.shiPingModel.mp4_url = [rs stringForColumn:@"sp_mp4_url"];
            self.shiPingModel.topicName = [rs stringForColumn:@"sp_topicName"];
            self.shiPingModel.topicImg = [rs stringForColumn:@"sp_topicImg"];
            [_ary addObject:self.shiPingModel];
        }
        [db close];
    }];
    return _ary;
}

//
- (NSMutableArray *)selectYongHuAll:(NSString *)str{
    __block NSMutableArray *_ary;
    if (_ary == nil) {
        _ary = [[NSMutableArray alloc]init];
    }
    //删除原数据
    [_ary removeAllObjects];
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db open];
        FMResultSet *rs = [db executeQuery:str];
        while ([rs next]) {
        self.yongHuModel = [[YongHuModel alloc]init];
        self.yongHuModel.name = [rs stringForColumn:@"yh_name"];
        self.yongHuModel.zhangH = [rs stringForColumn:@"yh_zhanghao"];
        self.yongHuModel.miMa = [rs stringForColumn:@"yh_pws"];
        [_ary addObject:self.yongHuModel];
        }
        [db close];
    }];
    return _ary;
}

- (NSMutableArray *)selectAllShouCangXinWen:(NSString *)str{
    __block NSMutableArray *_ary;
    if (_ary == nil) {
        _ary = [[NSMutableArray alloc]init];
    }
    //删除原数据
    [_ary removeAllObjects];
    
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db open];
        FMResultSet *rs = [db executeQuery:str];
        while ([rs next]) {
            self.xinWenModel = [[XinWenModel alloc]init];
            self.xinWenModel.title = [rs stringForColumn:@"sc_title"];
            self.xinWenModel.time  = [rs stringForColumn:@"sc_time"];
            self.xinWenModel.src  = [rs stringForColumn:@"sc_src"];
            self.xinWenModel.category  = [rs stringForColumn:@"sc_category"];
            self.xinWenModel.pic  = [rs stringForColumn:@"sc_pic"];
            self.xinWenModel.content  = [rs stringForColumn:@"sc_content"];
            self.xinWenModel.url  = [rs stringForColumn:@"sc_url"];
            self.xinWenModel.weburl  = [rs stringForColumn:@"sc_weburl"];
            [_ary addObject:self.xinWenModel];
        }
        [db close];
    }];
    return _ary;
}

- (NSMutableArray *)selectPingLunAll:(NSString *)str{
    __block NSMutableArray *_ary;
    if (_ary == nil) {
        _ary = [[NSMutableArray alloc]init];
    }
    //删除原数据
    [_ary removeAllObjects];
    
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db open];
        FMResultSet *rs = [db executeQuery:str];
        while ([rs next]) {
            self.pingLunModel = [[PingLunModel alloc]init];
            self.pingLunModel.title = [rs stringForColumn:@"pl_title"];
            self.pingLunModel.image  = [rs stringForColumn:@"pl_image"];
            self.pingLunModel.name  = [rs stringForColumn:@"pl_name"];
            self.pingLunModel.content  = [rs stringForColumn:@"pl_content"];
            
            [_ary addObject:self.pingLunModel];
        }
        [db close];
    }];
    return _ary;
}
@end
