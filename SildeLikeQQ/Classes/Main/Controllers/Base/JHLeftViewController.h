//
//  JHLeftViewController.h
//  SildeLikeQQ
//
//  Created by piglikeyoung on 15/8/19.
//  Copyright (c) 2015年 piglikeyoung. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JHLeftViewMenuSelectDelegate <NSObject>

- (void)selectMenuWithIndex:(NSIndexPath*)index item:(id)obj;

@end

@interface JHLeftViewController : UIViewController

@property (nonatomic,weak) id <JHLeftViewMenuSelectDelegate> delegate;

/**
 *  所有控件存放的View
 */
@property (nonatomic,weak) UIView *allAnimationView;

/**
 *  tableView可以展示的宽度
 */
@property (nonatomic, assign) CGFloat tableViewShowWidth;


@end
