//
//  JHBaseViewController.m
//  SildeLikeQQ
//
//  Created by piglikeyoung on 15/8/21.
//  Copyright (c) 2015年 piglikeyoung. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JHNavigationController.h"

@interface JHBaseViewController ()<UITabBarControllerDelegate>

@property (nonatomic, weak) UIViewController *home;
@property (nonatomic, weak) UIViewController *message;
@property (nonatomic, weak) UIViewController *profile;

@end

@implementation JHBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    self.view.backgroundColor = JHRandomColor;
    
    // 添加子控制器
    [self addAllChildVcs];
}

/**
 *  添加所有的子控制器
 */
- (void)addAllChildVcs
{
    // 添加子控制器
    UIViewController *home = [[UIViewController alloc] init];
    [self addOneChlildVc:home title:@"首页" imageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected"];
    self.home = home;
    self.lastSelectedViewContoller = home;
    
    UIViewController *message = [[UIViewController alloc] init];
    [self addOneChlildVc:message title:@"消息" imageName:@"tabbar_message_center" selectedImageName:@"tabbar_message_center_selected"];
    self.message = message;
    
    UIViewController *discover = [[UIViewController alloc] init];
    [self addOneChlildVc:discover title:@"发现" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discover_selected"];
    
    UIViewController *profile = [[UIViewController alloc] init];
    [self addOneChlildVc:profile title:@"我" imageName:@"tabbar_profile" selectedImageName:@"tabbar_profile_selected"];
    self.profile = profile;
}

/**
 *  添加一个子控制器
 *
 *  @param childVc           子控制器对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)addOneChlildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    
    
    // 设置标题
    // 相当于同时设置了tabBarItem.title和navigationItem.title
    childVc.title = title;
    
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    
    // 设置tabBarItem的普通文字颜色
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[UITextAttributeTextColor] = [UIColor blackColor];
    textAttrs[UITextAttributeFont] = [UIFont systemFontOfSize:10];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置tabBarItem的选中文字颜色
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[UITextAttributeTextColor] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    
    // 在iOS7中, 会对selectedImage的图片进行再次渲染为蓝色
    // 要想显示原图, 就必须得告诉它: 不要渲染
    if (iOS7) {
        // 声明这张图片用原图(别渲染)
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    childVc.tabBarItem.selectedImage = selectedImage;
    
    // 添加为tabbar控制器的子控制器
    JHNavigationController *nav = [[JHNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UINavigationController *)viewController {
    // 拿到栈顶的控制器，即点击了TabBar的哪个控制器
    UIViewController *vc = [viewController.viewControllers firstObject];
    
    self.lastSelectedViewContoller = vc;
    
    if ([self.mDelegate respondsToSelector:@selector(selectWithItem:)]) {
        [self.mDelegate selectWithItem:vc];
    }
}


@end
