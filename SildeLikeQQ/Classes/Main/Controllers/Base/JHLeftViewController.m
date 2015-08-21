//
//  JHLeftViewController.m
//  SildeLikeQQ
//
//  Created by piglikeyoung on 15/8/19.
//  Copyright (c) 2015年 piglikeyoung. All rights reserved.
//

#import "JHLeftViewController.h"

static const NSInteger kDefaultHeaderH = 50;/**< 头像的高度 */
static const NSInteger kDefaultHeaderW = kDefaultHeaderH;/**< 头像的宽度 */

static const CGFloat kUserNameFontSize = 18.f;/**< 用户名字体大小 */
static const CGFloat kUserPhoneFontSize = 15.f;/**< 手机字体大小 */

@interface JHLeftViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, weak) UIImageView *userIcon;
@property (nonatomic, weak) UIButton *settingBtn;

@property (nonatomic, strong) NSArray *leftItemArray;

@end

@implementation JHLeftViewController


- (NSArray *)leftItemArray {
    if (!_leftItemArray) {
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"LeftVcItems.plist" ofType:nil];
        _leftItemArray = [NSArray arrayWithContentsOfFile:fullPath];
    }
    
    return _leftItemArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置背景图片
    UIImageView *viewBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back"]];
    viewBg.frame = self.view.bounds;
    viewBg.clipsToBounds = YES;
    [self.view addSubview:viewBg];

    // 创建一个View承载其他View
    UIView *allAnimationView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.allAnimationView = allAnimationView;
    [self.view addSubview:allAnimationView];
    
    // 用户头像
    UIButton *userIcon = [UIButton buttonWithType:UIButtonTypeSystem];
    [allAnimationView addSubview:userIcon];
    [userIcon setBackgroundImage:[UIImage imageNamed:@"defaultHead"] forState:UIControlStateNormal];
    [userIcon setBackgroundImage:[UIImage imageNamed:@"defaultHead"] forState:UIControlStateHighlighted];
    self.userIcon = userIcon;
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kDefaultHeaderW);
        make.height.mas_equalTo(kDefaultHeaderH);
        make.left.equalTo(allAnimationView.mas_left).with.offset(padding * 2);
        make.top.equalTo(allAnimationView.mas_top).with.offset(75);
    }];
    
    // 用户名
    UILabel *userName = [[UILabel alloc] init];
    [allAnimationView addSubview:userName];
    userName.text = @"piglikeyoung";
    userName.font = [UIFont systemFontOfSize:kUserNameFontSize];
    userName.textColor = [UIColor whiteColor];
    CGSize size = [userName.text sizeWithFont:[UIFont systemFontOfSize:kUserNameFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userIcon.mas_right).with.offset(padding);
        make.top.equalTo(userIcon.mas_top);
        make.height.mas_equalTo(size.height);
        make.width.mas_equalTo(size.width + 1);
    }];
    
    // 手机号
    UILabel *phone = [[UILabel alloc] init];
    [allAnimationView addSubview:phone];
    phone.text = @"piglikeyoung@qq.com";
    phone.font = [UIFont systemFontOfSize:kUserPhoneFontSize];
    phone.textColor = [UIColor lightGrayColor];
    size = [phone.text sizeWithFont:[UIFont systemFontOfSize:kUserPhoneFontSize] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userName.mas_left);
        make.bottom.equalTo(userIcon.mas_bottom).offset(-3);
        make.height.mas_equalTo(size.height);
        make.width.mas_equalTo(size.width + 1);
    }];
    
    // 设置
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [allAnimationView addSubview:settingBtn];
    [settingBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [settingBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateHighlighted];
    [settingBtn setTitle:@"设置" forState:UIControlStateNormal];
    [settingBtn setTitle:@"设置" forState:UIControlStateHighlighted];
    [settingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [settingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [settingBtn setTintColor:[UIColor whiteColor]];
    self.settingBtn = settingBtn;
    [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(allAnimationView.mas_left).with.offset(padding * 2);
        make.bottom.equalTo(allAnimationView.mas_bottom).with.offset(- padding * 3);
    }];
    
    // 竖线
    UIView *line = [[UIView alloc] init];
    [allAnimationView addSubview:line];
    line.backgroundColor = [UIColor lightGrayColor];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(16);
        make.left.equalTo(settingBtn.mas_right).offset(padding);
        make.centerY.equalTo(settingBtn.mas_centerY);
    }];
    
    // 一键求助
    UIButton *helpBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [allAnimationView addSubview:helpBtn];
    [helpBtn setTitle:@"一键求助" forState:UIControlStateNormal];
    [helpBtn setTitle:@"一键求助" forState:UIControlStateHighlighted];
    [helpBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [helpBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_right).offset(padding);
        make.centerY.equalTo(settingBtn.mas_centerY);
    }];
    
    // 选项列表
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    [allAnimationView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userIcon.mas_bottom).offset(padding);
        make.bottom.equalTo(settingBtn.mas_top).offset(-padding);
        make.left.equalTo(allAnimationView.mas_left);
        make.right.equalTo(allAnimationView.mas_right);
    }];
    
    
}

- (void)setTableViewShowWidth:(CGFloat)tableViewShowWidth {
    _tableViewShowWidth = tableViewShowWidth;
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(tableViewShowWidth - padding);
        make.top.equalTo(self.userIcon.mas_bottom).offset(padding);
        make.bottom.equalTo(self.settingBtn.mas_top).offset(-padding);
        make.left.equalTo(self.allAnimationView.mas_left);
    }];
}

- (void)dealloc {
    JHLog(@"JHLeftViewController --- dealloc");
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.leftItemArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    cell.textLabel.text = self.leftItemArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(selectMenuWithIndex:item:)]) {
        [self.delegate selectMenuWithIndex:indexPath item:self.leftItemArray[indexPath.row]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}




@end
