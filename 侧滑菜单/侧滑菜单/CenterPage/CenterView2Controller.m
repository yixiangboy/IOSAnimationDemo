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
    self.view.backgroundColor = [UIColor blackColor];
    

    SWRevealViewController *revealController = self.revealViewController;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
}


@end
