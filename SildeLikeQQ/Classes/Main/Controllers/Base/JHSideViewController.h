//
//  JHSideViewController.h
//  SildeLikeQQ
//
//  Created by piglikeyoung on 15/8/19.
//  Copyright (c) 2015年 piglikeyoung. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RootViewMoveBlock)(UIView *rootView,CGRect orginFrame,CGFloat xoffset);

@interface JHSideViewController : UIViewController

@property (assign,nonatomic) BOOL needSwipeShowMenu;/**< 是否开启手势滑动出菜单 */

@property (assign,nonatomic) CGFloat leftViewShowWidth;/**< 左侧栏的展示大小 */
@property (assign,nonatomic) CGFloat rightViewShowWidth;/**< 右侧栏的展示大小 */

@property (assign,nonatomic) NSTimeInterval animationDuration;/**< 动画时长 */

@property (assign,nonatomic) BOOL showBoundsShadow;/**< 是否显示边框阴影 */

@property (assign,nonatomic) BOOL isShowLeftSide;/**< 是否显示出了左边栏 */
@property (assign,nonatomic) BOOL isShowRightSide;/**< 是否显示出了右边栏 */

@property (copy,nonatomic) RootViewMoveBlock rootViewMoveBlock;/**< 可在此block中重做动画效果 */

- (void)showLeftViewController:(BOOL)animated;/**< 展示左边栏 */
- (void)showRightViewController:(BOOL)animated;/**< 展示右边栏 */
- (void)hideSideViewController:(BOOL)animated;/**< 恢复正常位置 */

@end
