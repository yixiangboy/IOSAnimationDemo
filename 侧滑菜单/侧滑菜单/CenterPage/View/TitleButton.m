//
//  TitleButton.m
//  侧滑菜单
//
//  Created by yixiang on 15/7/19.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import "TitleButton.h"

@implementation TitleButton

-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.backgroundColor = [UIColor grayColor];
    }
    
    return self;
}


@end
