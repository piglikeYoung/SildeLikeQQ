//
//  JHRightViewController.m
//  SildeLikeQQ
//
//  Created by piglikeyoung on 15/8/20.
//  Copyright (c) 2015年 piglikeyoung. All rights reserved.
//

#import "JHRightViewController.h"

@interface JHRightViewController ()

@end

@implementation JHRightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置背景图片
    UIImageView *viewBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baseBgImg"]];
    viewBg.frame = self.view.bounds;
    viewBg.clipsToBounds = YES;
    [self.view addSubview:viewBg];
}



@end
