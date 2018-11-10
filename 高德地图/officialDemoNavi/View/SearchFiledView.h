//
//  SearchFiledView.h
//  SF_GaoDeMAP
//
//  Created by李晓东 on 2017/12/14.
//  Copyright © 2017年 ShouNew.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchFiledView : UIView<UITextFieldDelegate>
//输入框
@property (weak, nonatomic) IBOutlet UITextField *textField;
//输入
@property(nonatomic,copy)void(^inputStrBlock)(void);
//跳转控制器
@property(nonatomic,copy)void(^pushVCBlock)(void);
//点击按钮
- (IBAction)clickUserBtn:(UIButton *)sender;
//创建
+ (instancetype)createFileView;
@end
