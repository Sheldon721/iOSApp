//
//  LrcModel.h
//  云音乐
//
//  Created by 李晓东 on 2017/9/26.
//  Copyright © 2017年 李晓东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LrcModel : NSObject
@property (nonatomic,strong)NSString *text;//歌词
@property (nonatomic,assign)NSTimeInterval time;//时间
@end
