//
//  CenterView1Controller.m
//  侧滑菜单
//
//  Created by yixiang on 15/7/13.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import "CenterView1Controller.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"

@implementation CenterView1Controller

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 100, 20)];
    [leftBtn setTitle:@"左中切换" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    leftBtn.layer.borderWidth = 1;
    [self.view addSubview:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 20, 100, 20)];
    [rightBtn setTitle:@"右中切换" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    rightBtn.layer.borderWidth=1;
    [self.view addSubview:rightBtn];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 100, 100, 100)];
    label.text = @"界面1";
    label.font = [UIFont systemFontOfSize:22];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    //注册该页面可以执行滑动切换
    SWRevealViewController *revealController = self.revealViewController;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    // 注册该页面可以执行点击切换
    [leftBtn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
}

@end
