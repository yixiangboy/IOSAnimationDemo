# IOSAnimationDemo
IOS动画总结

##一、简介
侧滑菜单已经成为app一个极常用的设计，不管是事务类，效率类还是生活类app。侧滑菜单因Path 2.0和Facebook为开发者熟知，国内目前也有很多流行app用到了侧滑菜单，比如QQ、网易邮箱、知乎等等。<br/>IOS官方并没有提供类似于侧滑栏之类的组件，所以我们需要自己写一个侧滑栏控件，为了不要重复造轮子，我在github上找到了一个使用简单方便，新手容易入手的侧滑菜单控件，地址：[https://github.com/John-Lluch/SWRevealViewController/tree/master/](https://github.com/John-Lluch/SWRevealViewController/tree/master/)<br/>
下面我们就是使用上面的控件，来做一个侧滑栏的小Demo，来教大家快速入门侧滑栏控件。<br/>Demo界面演示如下：<br/>
![演示图片](http://img.my.csdn.net/uploads/201507/16/1437045093_8931.gif)
<br/>
##二、使用说明
###第一步：导入SWRevealViewController.h和SWRevealViewController.m文件

###第二步：编写中间显示界面CenterViewController
在viewDidLoad方法中设置SWRevealViewController中的panGestureRecognizer方法，即可实现在主界面上滑动就可以出现左侧或者右侧菜单。设置revealToggle:方法就可以实现点击进行左边菜单和中间界面的切换。设置rightRevealToggle:方法就可以实现右边菜单和中间界面的切换。下面就是中间界面的相关代码：

```
//注册该页面可以执行滑动切换
SWRevealViewController *revealController = self.revealViewController;
[self.view addGestureRecognizer:revealController.panGestureRecognizer];

// 注册该页面可以执行点击切换
[leftBtn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
[rightBtn addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
```

###第三步、编写左侧菜单栏LeftViewController
左侧菜单栏是由一个UITableView组成的，我们在每个cell的点击方法中执行 [revealViewController pushFrontViewController:viewController animated:YES];切换中间界面的操作。代码如下：
```
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
[revealViewController pushFrontViewController:viewController animated:YES];

}
```
###第四步、编写右侧菜单栏RightViewController
这里主要演示左侧菜单栏，这里就不做过多描述。就以一个简单的ViewController代替。
###第五步、在AppDelegate.m文件中的- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions方法中配置以上界面，可以分别设置左侧菜单栏、右侧菜单栏和中间首页。
详见代码注释：

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

//左侧菜单栏
LeftViewController *leftViewController = [[LeftViewController alloc] init];

//首页
CenterView1Controller *centerView1Controller = [[CenterView1Controller alloc] init];

//右侧菜单栏
RightViewController *rightViewController = [[RightViewController alloc] init];

SWRevealViewController *revealViewController = [[SWRevealViewController alloc] initWithRearViewController:leftViewController frontViewController:centerView1Controller];
revealViewController.rightViewController = rightViewController;

//浮动层离左边距的宽度
revealViewController.rearViewRevealWidth = 230;
//    revealViewController.rightViewRevealWidth = 230;

//是否让浮动层弹回原位
//mainRevealController.bounceBackOnOverdraw = NO;
[revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];

self.window.rootViewController = revealViewController;
self.window.backgroundColor = [UIColor whiteColor];
[self.window makeKeyAndVisible];
return YES;
}
```

<br/>
##三、总结
接下来准备使用这个界面作为主框架，写一系列关于IOS动画的总结 和 facebook开源动画项目pop动画的使用的博客。敬请期待。

### 四、下载地址
github下载地址：[https://github.com/yixiangboy/IOSAnimationDemo](https://github.com/yixiangboy/IOSAnimationDemo)<br/>
如果觉得对你还有些用，给一颗star吧。你的支持是我继续的动力。<br/>
博客地址：[http://blog.csdn.net/yixiangboy](http://blog.csdn.net/yixiangboy)
<br/>
###博主的话
以前看过很多别人的博客，学到不少东西。现在准备自己也开始写写博客，希望能够帮到一些人。
我的联系方式：[我的微博](http://weibo.com/5612984599/profile?topnav=1&wvr=6)