//
//  JHSideViewController.m
//  SildeLikeQQ
//
//  Created by piglikeyoung on 15/8/19.
//  Copyright (c) 2015年 piglikeyoung. All rights reserved.
//

#import "JHSideViewController.h"
#import "JHLeftViewController.h"
#import "JHRightViewController.h"
#import "JHSideViewController.h"
#import "JHBaseViewController.h"
#import "JHNavigationController.h"

@interface JHSideViewController ()<UIGestureRecognizerDelegate, JHLeftViewMenuSelectDelegate, JHBaseItemSelectDelegate>



@property (nonatomic, weak) UIViewController *tableSelectViewController;
@property (nonatomic, weak) JHBaseViewController *baseViewController;
@property (nonatomic, weak) JHLeftViewController *leftViewController;
@property (nonatomic, weak) JHRightViewController *rightViewController;

@property (nonatomic, weak) UIView *currentView;/**< 其实就是rootViewController.view */

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, assign) CGPoint startPanPoint;
@property (nonatomic, assign) CGPoint lastPanPoint;
@property (nonatomic, assign) BOOL panMovingRightOrLeft;/**< true是向右，false是向左 */

@property (nonatomic, strong) UIButton *coverButton;/**< 遮盖 */

@property (nonatomic, assign) CGRect touchRect;/**< 左边可以响应拖动的大小 */
@property (nonatomic, assign) CGRect rightTouchRect;/**< 右边可以响应拖动的大小 */

@end

@implementation JHSideViewController

#pragma mark - lazy Load
/**
 *  手势
 *
 */
- (UIPanGestureRecognizer *)panGestureRecognizer {
    if (!_panGestureRecognizer) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        _panGestureRecognizer.delegate = self;
    }
    
    return _panGestureRecognizer;
}

/**
 *  遮盖
 *
 */
- (UIButton *)coverButton {
    if (!_coverButton) {
        _coverButton = [[UIButton alloc]initWithFrame:self.view.bounds];
        [_coverButton addTarget:self action:@selector(hideSideViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverButton;
}


#pragma mark - Life cycle method
- (instancetype)init {
    self = [super init];
    if (self) {
        _needSwipeShowMenu = YES;
        _leftViewShowWidth = 267;
        _rightViewShowWidth = 0;
        _animationDuration = 0.35;
        _showBoundsShadow = YES;
        
        _panMovingRightOrLeft = NO;
        _lastPanPoint = CGPointZero;
        
        _touchRect = CGRectMake(0, 0, 100, JHScreenH);
        _rightTouchRect = CGRectMake(JHScreenW - 100, 0, 100, JHScreenH);
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        return [self init];
    }
    
    return self;
}



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


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.baseViewController) {
        NSAssert(false, @"you must set rootViewController!!");
    }
}

#pragma mark - JHLeftViewMenuSelectDelegate
/**
 *  左视图菜单选择
 *
 */
- (void)selectMenuWithIndex:(NSIndexPath *)index item:(id)obj {
    // 主视图恢复
    [self hideSideViewController];
    // 创建新的控制器push到导航控制器
    UIViewController *vc =  [[UIViewController alloc] init];
    vc.title = obj;
    vc.view.backgroundColor = JHRandomColor;
    [self.tableSelectViewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - JHBaseItemSelectDelegate
/**
 *  tabBar选择
 *
 */
- (void)selectWithItem:(UIViewController *)vc {
    
    // 当选择不一样的Item时，移除旧的控制器上得手势，添加到新的控制器上
    if (vc != self.tableSelectViewController) {
        [self.tableSelectViewController.view removeGestureRecognizer:self.panGestureRecognizer];
        self.tableSelectViewController = vc;
        [self.tableSelectViewController.view addGestureRecognizer:self.panGestureRecognizer];
    }
}

#pragma mark - Public method
- (void)showShadow:(BOOL)show{
    _currentView.layer.shadowOpacity    = show ? 0.8f : 0.0f;
    if (show) {
        _currentView.layer.cornerRadius = 4.0f;
        _currentView.layer.shadowOffset = CGSizeZero;
        _currentView.layer.shadowRadius = 4.0f;
        _currentView.layer.shadowPath   = [UIBezierPath bezierPathWithRect:_currentView.bounds].CGPath;
    }
}

#pragma mark  ShowOrHideTheView
- (void)willShowLeftViewController{
    // 左视图不存在，结束
    if (!_leftViewController || _leftViewController.view.superview) {
        return;
    }

    _leftViewController.view.frame = self.view.bounds;
    [self.view insertSubview:_leftViewController.view belowSubview:_currentView];
    
    // 右视图存在则移除右视图
    if (_rightViewController && _rightViewController.view.superview) {
        [_rightViewController.view removeFromSuperview];
    }
    
    self.leftViewController.allAnimationView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.leftViewController.allAnimationView.x = -50;
    self.leftViewController.allAnimationView.alpha = 0.0;
}

- (void)willShowRightViewController{
    // 右视图不存在，结束
    if (!_rightViewController || _rightViewController.view.superview) {
        return;
    }
    _rightViewController.view.frame = self.view.bounds;
    [self.view insertSubview:_rightViewController.view belowSubview:_currentView];
    
    // 左视图存在则移除右视图
    if (_leftViewController && _leftViewController.view.superview) {
        [_leftViewController.view removeFromSuperview];
    }
}

- (void)showLeftViewController:(BOOL)animated{
    
    if (!_leftViewController) {
        return;
    }
    
    _touchRect = CGRectMake(0, 0, JHScreenW, JHScreenH);
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    _isShowLeftSide = YES;
    
    [self willShowLeftViewController];
    NSTimeInterval animatedTime=0;
    if (animated) {
        animatedTime = ABS(_leftViewShowWidth - _currentView.frame.origin.x) / _leftViewShowWidth * _animationDuration;
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:animatedTime animations:^{
        [self layoutCurrentViewWithOffset:_leftViewShowWidth];
        [_currentView addSubview:self.coverButton];
        [self showShadow:_showBoundsShadow];
    }];
}

- (void)showRightViewController:(BOOL)animated{
    if (!_rightViewController) {
        return;
    }
    
    _rightTouchRect = CGRectMake(0, 0, JHScreenW, JHScreenH);
    
    _isShowRightSide = YES;
    
    [self willShowRightViewController];
    NSTimeInterval animatedTime = 0;
    if (animated) {
        animatedTime = ABS(_rightViewShowWidth + _currentView.frame.origin.x) / _rightViewShowWidth * _animationDuration;
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:animatedTime animations:^{
        [self layoutCurrentViewWithOffset:-_rightViewShowWidth];
        [_currentView addSubview:self.coverButton];
        [self showShadow:_showBoundsShadow];
    } completion:^(BOOL finished) {
    }];
}

- (void)hideSideViewController:(BOOL)animated{
    _isShowLeftSide = NO;
    _isShowRightSide = NO;
    
    // 左边可响应拖动大小
    _touchRect = CGRectMake(0, 0, 100, JHScreenH);
    // 右边可响应拖动大小
    _rightTouchRect = CGRectMake(JHScreenW - 100, 0, 100, JHScreenH);
    
    [self showShadow:false];
    NSTimeInterval animatedTime = 0;
    if (animated) {
        animatedTime = ABS(_currentView.frame.origin.x / (_currentView.frame.origin.x>0?_leftViewShowWidth:_rightViewShowWidth)) * _animationDuration;
    }
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:animatedTime animations:^{
        [self layoutCurrentViewWithOffset:0];
    } completion:^(BOOL finished) {
        [self.coverButton removeFromSuperview];
        [_leftViewController.view removeFromSuperview];
        [_rightViewController.view removeFromSuperview];
    }];
}
- (void)hideSideViewController{
    [self hideSideViewController:true];
}


#pragma mark UIGestureRecognizerDelegate
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

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

    if (gestureRecognizer == _panGestureRecognizer) {
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint translation = [panGesture translationInView:self.view];
        if ([panGesture velocityInView:self.view].x < 600 && ABS(translation.x)/ABS(translation.y)>1) {
            return YES;
        }
        return NO;
    }
    return YES;
}


- (void)pan:(UIPanGestureRecognizer*)panGesture{
    
    // 开始拖动
    if (panGesture.state == UIGestureRecognizerStateBegan) {

        _startPanPoint = self.currentView.frame.origin;
        
        if (_currentView.x == 0) {
            // 显示阴影
            [self showShadow:_showBoundsShadow];
        }
        CGPoint velocity=[panGesture velocityInView:self.view];
        if(velocity.x > 0){
            if (_currentView.x >= 0) {
                [self willShowLeftViewController];
            }
        }else if (velocity.x<0) {
            if (_currentView.frame.origin.x <= 0) {
                [self willShowRightViewController];
            }
        }
        return;
    }
    CGPoint currentPostion = [panGesture translationInView:self.view];
    CGFloat xoffset = _startPanPoint.x + currentPostion.x;
    if (xoffset>0) {//向右滑
        if (self.leftViewController) {
            xoffset = xoffset > _leftViewShowWidth? _leftViewShowWidth : xoffset;
        }else{
            xoffset = 0;
        }
    }else if(xoffset<0){//向左滑
        if (_rightViewController && _rightViewController.view.superview) {
            xoffset = xoffset<-_rightViewShowWidth?-_rightViewShowWidth:xoffset;
        }else{
            xoffset = 0;
        }
    }
    if (xoffset != _currentView.x) {
        [self layoutCurrentViewWithOffset:xoffset];
    }
    if (_panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (_currentView.x!=0 && _currentView.x != -_rightViewShowWidth) {
            if (_panMovingRightOrLeft && _currentView.x > 20) {
                [self showLeftViewController:true];
            }else if(!_panMovingRightOrLeft && _currentView.x < -20){
                [self showRightViewController:true];
            }else{
                [self hideSideViewController];
            }
        }else if (_currentView.x == 0) {
            [self showShadow:false];
        }
        _lastPanPoint = CGPointZero;
    }else{
        CGPoint velocity = [panGesture velocityInView:self.view];
        if (velocity.x>0) {
            _panMovingRightOrLeft = true;
        }else if(velocity.x<0){
            _panMovingRightOrLeft = false;
        }
    }
}

#pragma mark - 移动的动画方法
/**
 *  重写此方法可以改变动画效果,_currentView就是RootViewController.view
 *
 */
- (void)layoutCurrentViewWithOffset:(CGFloat)xoffset{
    
    if(_leftViewController){
        
        float originScale = (_leftViewShowWidth-xoffset)/_leftViewShowWidth;

        float frameScale = 1.0-originScale*0.5;
        _leftViewController.allAnimationView.transform = CGAffineTransformMakeScale(frameScale, frameScale);
        _leftViewController.allAnimationView.x = -50*originScale;
        _leftViewController.allAnimationView.alpha = 1.0-originScale*0.7;
        //一定要先缩放，再设置坐标，否则坐标会乱，切记
    }
    
    if (_showBoundsShadow) {
        _currentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_currentView.bounds].CGPath;
    }
    if (self.rootViewMoveBlock) {//如果有自定义动画，使用自定义的效果
        self.rootViewMoveBlock(_currentView,self.view.bounds,xoffset);
        return;
    }
    /*平移的动画
     [_currentView setFrame:CGRectMake(xoffset, self.view.bounds.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
     return;
     //*/
    
    //    /*平移带缩放效果的动画
    static CGFloat h2w = 0;
    if (h2w==0) {
        h2w = self.view.frame.size.height/self.view.frame.size.width;
    }
    CGFloat scale = ABS(1200 - ABS(xoffset)) / 1200;

    scale = MAX(0.8, scale);
    _currentView.transform = CGAffineTransformMakeScale(scale, scale);
    
    CGFloat totalWidth=self.view.frame.size.width;
    CGFloat totalHeight=self.view.frame.size.height;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        totalHeight=self.view.frame.size.width;
        totalWidth=self.view.frame.size.height;
    }
    
    if (xoffset>0) {//向右滑的
        [_currentView setFrame:CGRectMake(xoffset, self.view.bounds.origin.y + (totalHeight * (1 - scale) / 2), totalWidth * scale, totalHeight * scale)];
    }else{//向左滑的
        [_currentView setFrame:CGRectMake(self.view.frame.size.width * (1 - scale) + xoffset, self.view.bounds.origin.y + (totalHeight*(1 - scale) / 2), totalWidth * scale, totalHeight * scale)];
    }

}


@end
