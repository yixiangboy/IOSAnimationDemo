//
//  TitleButton.h
//  侧滑菜单
//
//  Created by yixiang on 15/7/19.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleButton : UIButton

/**
 *  初始化按钮
 *
 *  @param frame frame
 *  @param title 标题
 *
 *  @return 按钮对象
 */
-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title;

@end
