//
//  JHBaseViewController.h
//  SildeLikeQQ
//
//  Created by piglikeyoung on 15/8/21.
//  Copyright (c) 2015年 piglikeyoung. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JHBaseItemSelectDelegate <NSObject>

- (void)selectWithItem:(UIViewController *)vc;

@end

@interface JHBaseViewController : UITabBarController

/**
 *  最后选中的tabItem
 */
@property (nonatomic, weak) UIViewController *lastSelectedViewContoller;

@property (nonatomic, weak) id<JHBaseItemSelectDelegate> mDelegate;

@end
