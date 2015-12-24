##一、简介
IOS 动画主要是指Core Animation框架。官方使用文档地址为：[Core Animation Guide](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreAnimation_guide/Introduction/Introduction.html)。<br/>Core Animation是IOS和OS X平台上负责图形渲染与动画的基础框架。Core Animation可以作用与动画视图或者其他可视元素，为你完成了动画所需的大部分绘帧工作。你只需要配置少量的动画参数（如开始点的位置和结束点的位置）即可使用Core Animation的动画效果。Core Animation将大部分实际的绘图任务交给了图形硬件来处理，图形硬件会加速图形渲染的速度。这种自动化的图形加速技术让动画拥有更高的帧率并且显示效果更加平滑，不会加重CPU的负担而影响程序的运行速度。

##二、Core Animation类图以及常用字段
Core Animation类的继承关系图
![coreAnimation.png](http://img.my.csdn.net/uploads/201507/23/1437617562_3190.png)

**常用属性**
duration : 动画的持续时间
beginTime : 动画的开始时间
repeatCount : 动画的重复次数
autoreverses : 执行的动画按照原动画返回执行
timingFunction : 控制动画的显示节奏系统提供五种值选择，分别是：

- kCAMediaTimingFunctionLinear 线性动画
- kCAMediaTimingFunctionEaseIn 先慢后快（慢进快出）
- kCAMediaTimingFunctionEaseOut 先块后慢（快进慢出）
- kCAMediaTimingFunctionEaseInEaseOut 先慢后快再慢
- kCAMediaTimingFunctionDefault 默认，也属于中间比较快

delegate ： 动画代理。能够检测动画的执行和结束。

```
@interface NSObject (CAAnimationDelegate)
 - (void)animationDidStart:(CAAnimation *)anim;
 - (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
@end
```
path：关键帧动画中的执行路径
type  ： 过渡动画的动画类型，系统提供了四种过渡动画。
 - kCATransitionFade   渐变效果
 - kCATransitionMoveIn  进入覆盖效果
 - kCATransitionPush  推出效果
 - kCATransitionReveal   揭露离开效果
subtype : 过渡动画的动画方向
 - kCATransitionFromRight   从右侧进入
 - kCATransitionFromLeft    从左侧进入
 - kCATransitionFromTop  从顶部进入
 - kCATransitionFromBottom  从底部进入

##三、IOS动画的调用方式
###第一种：UIView 代码块调用

```
    _demoView.frame = CGRectMake(0, SCREEN_HEIGHT/2-50, 50, 50);
    [UIView animateWithDuration:1.0f animations:^{
        _demoView.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT/2-50, 50, 50);
    } completion:^(BOOL finished) {
        _demoView.frame = CGRectMake(SCREEN_WIDTH/2-25, SCREEN_HEIGHT/2-50, 50, 50);
    }];
```
###第二种：UIView [begin commit]模式
    _demoView.frame = CGRectMake(0, SCREEN_HEIGHT/2-50, 50, 50);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    _demoView.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT/2-50, 50, 50);
    [UIView commitAnimations];
###第三种：使用Core Animation中的类

```
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"position"];
    anima.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, SCREEN_HEIGHT/2-75)];
    anima.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT/2-75)];
    anima.duration = 1.0f;
    [_demoView.layer addAnimation:anima forKey:@"positionAnimation"];
```
##四、IOS动画的使用
###4.1：基础动画（CABaseAnimation）
**重要属性**
**fromValue** ： keyPath对应的初始值
**toValue** ： keyPath对应的结束值<br/>
基础动画主要提供了对于CALayer对象中的可变属性进行简单动画的操作。比如：位移、透明度、缩放、旋转、背景色等等。
效果演示：
![baseAnimation](http://img.my.csdn.net/uploads/201507/23/1437633205_7098.gif)
位移动画代码演示：

```
    //使用CABasicAnimation创建基础动画
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"position"];
    anima.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, SCREEN_HEIGHT/2-75)];
    anima.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT/2-75)];
    anima.duration = 1.0f;
    //anima.fillMode = kCAFillModeForwards;
    //anima.removedOnCompletion = NO;
    [_demoView.layer addAnimation:anima forKey:@"positionAnimation"];
```
**注意点**
如果fillMode=kCAFillModeForwards和removedOnComletion=NO，那么在动画执行完毕后，图层会保持显示动画执行后的状态。但在实质上，图层的属性值还是动画执行前的初始值，并没有真正被改变。
###4.2：关键帧动画（CAKeyframeAnimation）
CAKeyframeAnimation和CABaseAnimation都属于CAPropertyAnimatin的子类。CABaseAnimation只能从一个数值（fromValue）变换成另一个数值（toValue）,而CAKeyframeAnimation则会使用一个NSArray保存一组关键帧。
**重要属性**
**values**  ：  就是上述的NSArray对象。里面的元素称为”关键帧”(keyframe)。动画对象会在指定的时间(duration)内，依次显示values数组中的每一个关键帧
**path**  ：  可以设置一个CGPathRef\CGMutablePathRef,让层跟着路径移动。path只对CALayer的anchorPoint和position起作用。如果你设置了path，那么values将被忽略。
**keyTimes**  ：  可以为对应的关键帧指定对应的时间点,其取值范围为0到1.0,keyTimes中的每一个时间值都对应values中的每一帧.当keyTimes没有设置的时候,各个关键帧的时间是平分的。<br/>
效果演示：
![关键帧动画](http://img.my.csdn.net/uploads/201507/23/1437633206_1436.gif)
圆形路径动画代码演示：

```
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT/2-100, 200, 200)];
    anima.path = path.CGPath;
    anima.duration = 2.0f;
    [_demoView.layer addAnimation:anima forKey:@"pathAnimation"];
```
**说明**：CABasicAnimation可看做是最多只有2个关键帧的CAKeyframeAnimation<br/>
###4.3：组动画（CAAnimationGroup）
CAAnimation的子类，可以保存一组动画对象，将CAAnimationGroup对象加入层后，组中所有动画对象可以同时并发运行。
**重要属性**
**animations** : 用来保存一组动画对象的NSArray
效果演示：
![组动画](http://img.my.csdn.net/uploads/201507/23/1437633206_5730.gif)
组动画代码演示：

```
    CAKeyframeAnimation *anima1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue *value0 = [NSValue valueWithCGPoint:CGPointMake(0, SCREEN_HEIGHT/2-50)];
    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/3, SCREEN_HEIGHT/2-50)];
    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/3, SCREEN_HEIGHT/2+50)];
    NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH*2/3, SCREEN_HEIGHT/2+50)];
    NSValue *value4 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH*2/3, SCREEN_HEIGHT/2-50)];
    NSValue *value5 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT/2-50)];
    anima1.values = [NSArray arrayWithObjects:value0,value1,value2,value3,value4,value5, nil];
    
    //缩放动画
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:0.8f];
    anima2.toValue = [NSNumber numberWithFloat:2.0f];
    
    //旋转动画
    CABasicAnimation *anima3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    anima3.toValue = [NSNumber numberWithFloat:M_PI*4];
    
    //组动画
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = [NSArray arrayWithObjects:anima1,anima2,anima3, nil];
    groupAnimation.duration = 4.0f;
    
    [_demoView.layer addAnimation:groupAnimation forKey:@"groupAnimation"];
```
###4.4：过渡动画（CATransition）
CAAnimation的子类，用于做过渡动画或者转场动画，能够为层提供移出屏幕和移入屏幕的动画效果。
**重要属性**
**type**：动画过渡类型<br/>
Apple 官方的SDK其实只提供了四种过渡效果。 
- kCATransitionFade   渐变效果
 - kCATransitionMoveIn  进入覆盖效果
 - kCATransitionPush  推出效果
 - kCATransitionReveal   揭露离开效果
 私有API提供了其他很多非常炫的过渡动画，比如@"cube"、@"suckEffect"、@"oglFlip"、 @"rippleEffect"、@"pageCurl"、@"pageUnCurl"、@"cameraIrisHollowOpen"、@"cameraIrisHollowClose"等。
 **注意点**
 私有api，不建议开发者们使用。因为苹果公司不提供维护，并且有可能造成你的app审核不通过。
 
**subtype**：动画过渡方向

 - kCATransitionFromRight   从右侧进入
 - kCATransitionFromLeft    从左侧进入
 - kCATransitionFromTop  从顶部进入
 - kCATransitionFromBottom  从底部进入

**startProgress**：动画起点(在整体动画的百分比)
**endProgress**：动画终点(在整体动画的百分比)

效果演示：
![过渡动画](http://img.my.csdn.net/uploads/201507/23/1437633231_2716.gif)

###4.5：综合案例
####4.5.1 ： 仿Path菜单效果
效果演示：
![仿Path菜单效果](http://img.my.csdn.net/uploads/201507/23/1437635877_5788.gif)

动画解析：
1、点击红色按钮，红色按钮旋转。（旋转动画）
2、黑色小按钮依次弹出，并且带有旋转效果。（位移动画、旋转动画、组动画）
3、点击黑色小按钮，其他按钮消失，被点击的黑色按钮变大变淡消失。（缩放动画、alpha动画、组动画）
**博主的话**：代码过多，这里不做演示。文章最后提供代码下载地址。

####4.5.2： 仿钉钉菜单效果
效果演示：
![仿钉钉菜单效果](http://img.my.csdn.net/uploads/201507/23/1437633205_7266.gif)
看上去挺炫的，其实实现很简单，就是位移动画+缩放动画。

####4.5.3： 点赞烟花效果动画
效果演示：
![点赞烟花效果动画](http://img.my.csdn.net/uploads/201507/23/1437633205_2517.gif)<br/>
这里其实只有按钮变大效果使用的缩放动画。烟花效果 使用的是一种比较特殊的动画--粒子动画。
一个粒子系统一般有两部分组成：
1、CAEmitterCell：可以看作是单个粒子的原型（例如，一个单一的粉扑在一团烟雾）。当散发出一个粒子，UIKit根据这个发射粒子和定义的基础上创建一个随机粒子。此原型包括一些属性来控制粒子的图片，颜色，方向，运动，缩放比例和生命周期。
2、CAEmitterLayer：主要控制发射源的位置、尺寸、发射模式、发射源的形状等等。
以上两个类的属性还是比较多的，这里就不细讲了。大家可以google一下，详细的了解吧。

##五、总结
任何复杂的动画其实都是由一个个简单的动画组装而成的，只要我们善于分解和组装，我们就能实现出满意的效果。动画其实也不是那么难。
<br/>
##六、下载地址
github下载地址：[https://github.com/yixiangboy/IOSAnimationDemo](https://github.com/yixiangboy/IOSAnimationDemo)<br/>
如果觉得对你还有些用，给一颗star吧。你的支持是我继续的动力。<br/>
个人博客地址：[http://blog.csdn.net/yixiangboy](http://blog.csdn.net/yixiangboy)
<br/>
##七、博主的话
**我的联系方式：**
微博：[新浪微博](http://weibo.com/5612984599/profile?topnav=1&wvr=6)<br>
博客：[http://blog.csdn.net/yixiangboy ](http://blog.csdn.net/yixiangboy)<br>
github：[https://github.com/yixiangboy](https://github.com/yixiangboy)<br>
