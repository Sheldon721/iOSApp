//
//  QueryCourierModel.h
//  快易查
//
//  Created by 刘超正 on 2017/11/19.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueryCourierModel : NSObject
/** 快递状态 */
@property(nonatomic,strong) NSString *status;
/** 时间 */
@property(nonatomic,strong) NSString *time;

@end
