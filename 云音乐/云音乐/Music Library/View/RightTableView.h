//
//  RightTableView.h
//  云音乐
//
//  Created by 李晓东 on 2017/9/21.
//  Copyright © 2017年 李晓东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightTableView : UITableView

+ (instancetype)initWithRightTableViewFrame:(CGRect)frame andDelegate:(id<UITableViewDelegate,UITableViewDataSource>)delegate;
@end
