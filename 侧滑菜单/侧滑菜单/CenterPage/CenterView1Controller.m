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
    
    
    SWRevealViewController *revealController = self.revealViewController;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
}

@end
