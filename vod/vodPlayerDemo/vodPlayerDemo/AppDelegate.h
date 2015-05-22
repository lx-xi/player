//
//  AppDelegate.h
//  vodPlayerDemo4
//
//  Created by xun.liu on 14/12/17.
//  Copyright (c) 2014年 xun.liu. All rights reserved.
//  lx_xi163@163.com

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) int       type;    //类型
@property (nonatomic, strong) NSString  *playerIP;  //自定义IP
@property (nonatomic, assign) BOOL      isSetting;  //是否是设置页

@end
