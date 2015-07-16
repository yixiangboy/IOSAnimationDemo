//
//  CenterView2Controller.m
//  侧滑菜单
//
//  Created by yixiang on 15/7/14.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import "CenterView2Controller.h"
#import "SWRevealViewController.h"


@interface CenterView2Controller ()

@end

@implementation CenterView2Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];//蓝绿色
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 100, 100, 100)];
    label.text = @"界面2";
    label.font = [UIFont systemFontOfSize:22];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    //注册该页面可以执行滑动切换
    SWRevealViewController *revealController = self.revealViewController;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
}


@end
