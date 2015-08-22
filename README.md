# SildeLikeQQ
一个类似QQ可滑动界面<br/>
![SildeLikeQQ](http://7xl1d6.com1.z0.glb.clouddn.com/Snip20150821_SildeLikeQQ.gif)

##编码
这里只介绍部分代码的编写过程

###界面
创建`JHSideViewController`，这个是主要展示的控制器，包含着`JHLeftViewController`，`JHRightViewController`和`JHBaseViewController`这几个子控制器(JHRightViewController默认不显示，若要显示可自行修改代码)，在`viewDidLoad`中创建上述几个控制器并把View添加到`JHSideViewController`的View上
```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建左视图
    JHLeftViewController *leftViewController = [[JHLeftViewController alloc] init];
    leftViewController.view.frame = self.view.bounds;
    leftViewController.tableViewShowWidth = self.leftViewShowWidth;
    leftViewController.delegate = self;
    [self addChildViewController:leftViewController];
    self.leftViewController = leftViewController;
    
    // 创建右视图
    JHRightViewController *rightViewController = [[JHRightViewController alloc] init];
    leftViewController.view.frame = self.view.bounds;
    [self addChildViewController:rightViewController];
    self.rightViewController = rightViewController;

    // 创建主视图
    JHBaseViewController *baseViewController = [[JHBaseViewController alloc] init];
    [self.view addSubview:baseViewController.view];
    [self addChildViewController:baseViewController];
    self.baseViewController = baseViewController;
    // 拿到当前选中的tabItem
    self.tableSelectViewController = self.baseViewController.lastSelectedViewContoller;
    // 添加手势
    [self.tableSelectViewController.view addGestureRecognizer:self.panGestureRecognizer];
    // 设置代理，选择别的tabItem触发
    baseViewController.mDelegate = self;
    self.currentView = self.baseViewController.view;
    
    // 动画效果可以被自己自定义，具体请看api
}
```

###手势
给`JHBaseViewController`添加拖动手势，当拖动到极限位置还有给`JHBaseViewController`添加一层遮盖`coverButton`防止`JHBaseViewController`界面被点击。因为`JHBaseViewController`是UITabBarController所以在切换Item的时候要把手势切换到Item对应的控制器的View上，这样才能保证界面能够拖动，拖动手势的动画和判断我不在此描述了，各位可浏览代码。
####在下面这个方法里面可以修改右视图也可以拖动响应
```objc
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    // 拖动的位置
    CGPoint location = [touch locationInView:self.view];
    
    // 只响应左滑
    if(CGRectContainsPoint(_touchRect, location)){
        return YES;
    }
    
    // 响应左滑、右滑
//    if(CGRectContainsPoint(_touchRect, location) || CGRectContainsPoint(_rightTouchRect, location)) {
//        return YES;
//    }
    
    return NO;
}
```
