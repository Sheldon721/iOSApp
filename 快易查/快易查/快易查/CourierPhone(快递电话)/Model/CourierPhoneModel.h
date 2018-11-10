//
//  CourierPhoneModel.h
//  快易查
//
//  Created by 刘超正 on 2017/11/18.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourierPhoneModel : NSObject
/** 快递名称 */
@property(nonatomic,strong) NSString *name;
/** 快递代号 */
@property(nonatomic,strong) NSString *type;
/** 首字母 */
@property(nonatomic,strong) NSString *letter;
/** 电话 */
@property(nonatomic,strong) NSString *tel;

@end
