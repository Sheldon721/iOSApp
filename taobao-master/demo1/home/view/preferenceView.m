//
//  preference.m
//  demo1
//
//  Created by pengchao on 2017/7/11.
//  Copyright © 2017年 pengchao. All rights reserved.
//

#import "preferenceView.h"

@implementation preferenceView

+ (preferenceView *)sharedManager
{
    static preferenceView *share = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        share = [[self alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    });
    return share;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

-(void)initViews{
    
    UIView *bgview =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    [bgview setBackgroundColor:RGBA(0, 0, 0, 0.7)];
    
    
    UIButton *likeButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    UIButton *dontlikeButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    likeButton.font =[UIFont systemFontOfSize:14];
    dontlikeButton.font =[UIFont systemFontOfSize:14];
    
    [likeButton setTitle:@"找相似" forState:UIControlStateNormal];
    [dontlikeButton setTitle:@"不喜欢" forState:UIControlStateNormal];
    
    
    [likeButton setBackgroundColor:RGBA(34, 138, 240, 1)];
    [dontlikeButton setBackgroundColor:RGBA(251
                                            , 61, 26, 1)];
    
    [bgview addSubview:likeButton];
    [bgview addSubview:dontlikeButton];
    
    [self addSubview:bgview];
    
    [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0.1);
        make.centerX.equalTo(bgview.superview.mas_centerX).offset(0);
        make.centerY.equalTo(bgview.superview.mas_centerY).offset(0);
        make.height.equalTo(@0.1);
    }];
    
    [likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(likeButton.superview.mas_centerX).offset(0);
        make.width.equalTo(likeButton.superview.mas_width).multipliedBy(0.3);
        make.height.equalTo(likeButton.superview.mas_width).multipliedBy(0.3);
        make.centerY.equalTo(likeButton.superview.mas_centerY).offset(50);
        
    }];
    
    [dontlikeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(dontlikeButton.superview.mas_centerX).offset(0);
        make.width.equalTo(dontlikeButton.superview.mas_width).multipliedBy(0.3);
        make.height.equalTo(dontlikeButton.superview.mas_width).multipliedBy(0.3);
        make.centerY.equalTo(dontlikeButton.superview.mas_centerY).offset(-50);
    }];
    
    self.bgview = bgview;
    self.likeButton = likeButton;
    self.dontlikeButton = dontlikeButton;
    
    
    //添加点击事件
    
    [likeButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    [dontlikeButton addTarget:self action:@selector(dontlikeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //背景添加tap事件
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removePreferenceView)];
    
    [self.bgview addGestureRecognizer:tap];
    
    
    //添加长按手势；
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 0.3;
    
    [self addGestureRecognizer:longPressGr];
    
    
    
    
}

-(void)removePreferenceView{
    
    [self removeFromSuperview];
    
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        [self showButtons];
    }
}

-(void)showButtons{

    __weak typeof(self) weakself=self;
    [UIView animateWithDuration:0.3 animations:^{
        
        [weakself.bgview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakself.superview.mas_centerX).offset(0);
            make.centerY.equalTo(weakself.superview.mas_centerY).offset(0);
        }];
       
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        
        
        [UIView animateWithDuration:0.4 animations:^{
            [weakself.bgview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakself.bgview.superview.mas_top);
                make.bottom.equalTo(weakself.bgview.superview.mas_bottom);
                make.left.equalTo(weakself.bgview.superview.mas_left);
                make.right.equalTo(weakself.bgview.superview.mas_right);
            }];
        }];
        
        [self layoutIfNeeded];
        
        weakself.likeButton.layer.masksToBounds = YES;
       weakself.likeButton.layer.cornerRadius = weakself.likeButton.bounds.size.height/2;
        weakself.dontlikeButton.layer.masksToBounds = YES;
        weakself.dontlikeButton.layer.cornerRadius = weakself.dontlikeButton.bounds.size.height/2;
        
    }];
    
    
}

-(void)likeAction:(UIButton *)button{
    
    if (self.clicklikeButton) {
        self.clicklikeButton();
    }
    
}

-(void)dontlikeAction:(UIButton *)button{
  
    if (self.clickdontLikeButton) {
        self.clickdontLikeButton();
    }
}


@end
