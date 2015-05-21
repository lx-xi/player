//
//  TabBarViewController.m
//  vodPlayerDemo4
//
//  Created by xun.liu on 14/12/25.
//  Copyright (c) 2014年 xun.liu. All rights reserved.
//

#import "TabBarViewController.h"
#import "TTNavigationViewController.h"
#import "TTRootViewController.h"
#import "TTSettingViewController.h"


@interface TabBarViewController ()<UINavigationBarDelegate>
{
    UIButton *_item_left;
    UIButton *_item_right;
    
    UIView *_tabbarView;
}

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViewControllers];
    [self setupTabbar];
}

- (void)setupViewControllers
{
    //创建子控制器
    TTRootViewController *root = [[TTRootViewController alloc] init];
    TTSettingViewController *setting = [[TTSettingViewController alloc] init];
    
    //存储三级控制器
    NSArray *viewCtrls = @[root, setting];
    
    //存储二级控制器
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:viewCtrls.count];
    for (int i=0; i<viewCtrls.count; i++) {
        UIViewController *viewController = viewCtrls[i];
        viewController.hidesBottomBarWhenPushed = NO;
        
        //创建二级导航控制器
        TTNavigationViewController *nav = [[TTNavigationViewController alloc] initWithRootViewController:viewController];
        [viewControllers addObject:nav];
    }
    
    self.viewControllers = viewControllers;
}

- (void)setupTabbar
{
    self.tabBar.hidden = YES;
    
    //自定义tabbar背景
    _tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-49, kScreenWidth, 49)];
    _tabbarView.backgroundColor = [UIColor whiteColor];
    _tabbarView.userInteractionEnabled = YES;
    [self.view addSubview:_tabbarView];
    
    //选中图片
    
    //tabbar按钮
    NSArray *imgArr = @[@"btn_home_sel.png", @"channel_icon_nal.png"];
    float width = kScreenWidth/imgArr.count;
    
    _item_left = [UIButton buttonWithType:UIButtonTypeCustom];
    _item_left.tag = 0;
    _item_left.frame = CGRectMake(width*0, 0, width, 49);;
    [_item_left addTarget:self action:@selector(tabbarItemSeleced:) forControlEvents:UIControlEventTouchUpInside];
    [_item_left setImage:[UIImage imageNamed:imgArr[0]] forState:UIControlStateNormal];
    [_tabbarView addSubview:_item_left];
    
    _item_right = [UIButton buttonWithType:UIButtonTypeCustom];
    _item_right.tag = 1;
    _item_right.frame = CGRectMake(width*1, 0, width, 49);;
    [_item_right addTarget:self action:@selector(tabbarItemSeleced:) forControlEvents:UIControlEventTouchUpInside];
    [_item_right setImage:[UIImage imageNamed:imgArr[1]] forState:UIControlStateNormal];
    [_tabbarView addSubview:_item_right];
    
//    for (int i=0; i<imgArr.count; i++) {
//        CGRect frame = CGRectMake(width*i, 0, width, 49);
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.tag = i;
//        button.frame = frame;
//        [button addTarget:self action:@selector(tabbarItemSeleced:) forControlEvents:UIControlEventTouchUpInside];
//        [button setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:imgArr_h[i]] forState:UIControlStateHighlighted];
//        [_tabbarView addSubview:button];
//    }
}

- (void)tabbarItemSeleced:(UIButton *)button
{
    //切换子控制器
    self.selectedIndex = button.tag;
    
    for (int i=0; i<_tabbarView.subviews.count; i++) {
        UIButton *item = (UIButton *)[_tabbarView viewWithTag:button.tag];
        if (item == _item_right) {
            [_item_right setImage:[UIImage imageNamed:@"channel_icon_sel.png"] forState:UIControlStateNormal];
            [_item_left setImage:[UIImage imageNamed:@"btn_home_nal.png"] forState:UIControlStateNormal];
        }
        else {
            [_item_right setImage:[UIImage imageNamed:@"channel_icon_nal.png"] forState:UIControlStateNormal];
            [_item_left setImage:[UIImage imageNamed:@"btn_home_sel.png"] forState:UIControlStateNormal];
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{

}

//是否显示工具栏
- (void)hiddenTabbar:(BOOL)hidden
{
    if (hidden) {
        CGRect frame = _tabbarView.frame;
        frame.origin.x = -kScreenWidth;
        _tabbarView.frame = frame;
    }
    else {
        CGRect frame = _tabbarView.frame;
        frame.origin.x = 0;
        _tabbarView.frame = frame;
    }
    
    self.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations
{
//    return [self.viewControllers.lastObject supportedInterfaceOrientations];
    return UIInterfaceOrientationMaskPortrait;
}

//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
