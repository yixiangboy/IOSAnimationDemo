//
//  BaseViewController.m
//  侧滑菜单
//
//  Created by yixiang on 15/7/18.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import "BaseViewController.h"
#import "SWRevealViewController.h"

@interface BaseViewController ()

@property (nonatomic , strong) NSArray *operateTitleArray;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

-(void)initData{
    _operateTitleArray = [self operateTitleArray];
}

-(void)initView{
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH ,60)];
    containerView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:containerView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [self controllerTitle];
    [containerView addSubview:label];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if(_operateTitleArray&&_operateTitleArray.count>0){
        NSUInteger row = _operateTitleArray.count%4==0 ? _operateTitleArray.count/4 : _operateTitleArray.count/4+1;
        UIView *operateView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-(row*50+20), SCREEN_WIDTH, row*50+20)];
        [self.view addSubview:operateView];
        for (int i=0; i<_operateTitleArray.count; i++) {
            TitleButton *btn = [[TitleButton alloc] initWithFrame:[self rectForBtnAtIndex:i totalNum:_operateTitleArray.count] withTitle:[_operateTitleArray objectAtIndex:i]];
            btn.tag = i;
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [operateView addSubview:btn];
        }
    }
    //注册该页面可以执行滑动切换
    SWRevealViewController *revealController = self.revealViewController;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
}

-(NSString *)controllerTitle{
    return @"默认标题";
}

/**
 *  获得每个操作按钮的frame
 *
 *  @param index    当前按钮的位置,从0开始
 *  @param totleNum 所有按钮的总数
 *
 *  @return 按钮的frame
 */
-(CGRect)rectForBtnAtIndex : (NSUInteger)index totalNum : (NSUInteger)totleNum{
    //每一行最多显示4个
    NSUInteger maxColumnNum = 4;
    //每个按钮的列间距
    CGFloat columnMargin = 20;
    //每个按钮的行间距
    CGFloat rowMargin = 20;
    //行数
   // NSUInteger row = totleNum/maxColumnNum;
    //每个按钮的宽度
    CGFloat width = (SCREEN_WIDTH - columnMargin*5)/4;
    //每个按钮的高度
    CGFloat height = 30;
    
    //每个按钮的偏移
    CGFloat offsetX = columnMargin+(index%maxColumnNum)*(width+columnMargin);
    CGFloat offsetY = rowMargin+(index/maxColumnNum)*(height+rowMargin);
    
    return CGRectMake(offsetX, offsetY, width, height);
}

-(void)clickBtn : (UIButton *)btn{
    
}

@end
