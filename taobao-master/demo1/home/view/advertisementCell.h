//
//  advertisementCell.h
//  demo1
//
//  Created by pengchao on 2017/7/4.
//  Copyright © 2017年 pengchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface advertisementCell : UITableViewCell
@property (nonatomic,copy) void (^clickIndex)(NSString *clickIndex);
@end
