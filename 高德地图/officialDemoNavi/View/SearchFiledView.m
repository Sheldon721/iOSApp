//
//  SearchFiledView.m
//  SF_GaoDeMAP
//
//  Created by李晓东 on 2017/12/14.
//  Copyright © 2017年 ShouNew.com. All rights reserved.
//

#import "SearchFiledView.h"

@implementation SearchFiledView

+ (instancetype)createFileView{
    
    return [[[NSBundle mainBundle]loadNibNamed:@"SearchFiledView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    //添加代理
    self.textField.delegate = self;
}

//field代理  self.inputStrBlock();
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //跳转搜索
    self.inputStrBlock();
    [textField resignFirstResponder];
    return NO;
}
//创建
- (IBAction)clickUserBtn:(UIButton *)sender {
    
    self.pushVCBlock();
}
@end
