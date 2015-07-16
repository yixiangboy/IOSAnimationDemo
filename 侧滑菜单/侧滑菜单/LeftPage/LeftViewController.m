//
//  LeftViewController.m
//  侧滑菜单
//
//  Created by yixiang on 15/7/13.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import "LeftViewController.h"
#import "SWRevealViewController.h"
#import "CenterView1Controller.h"
#import "CenterView2Controller.h"

@interface LeftViewController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) NSArray *menuArray;

@end

@implementation LeftViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initData];
    [self initView];
}

-(void)initData{
    _menuArray = [NSArray arrayWithObjects:@"界面1",@"界面2", nil];
}

-(void)initView{
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _menuArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *TABLE_VIEW_ID = @"table_view_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TABLE_VIEW_ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TABLE_VIEW_ID];
    }
    cell.textLabel.text = [_menuArray objectAtIndex:indexPath.row];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SWRevealViewController *revealViewController = self.revealViewController;
    UIViewController *viewController;
    
    switch (indexPath.row) {
        case 0:
            viewController = [[CenterView1Controller alloc] init];
            break;
        case 1:
            viewController = [[CenterView2Controller alloc] init];
            break;
            
        default:
            break;
    }
    //调用pushFrontViewController进行页面切换
    [revealViewController pushFrontViewController:viewController animated:YES];
    
}

@end
