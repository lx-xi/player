//
//  TTCommon.h
//  TTVideoHD
//
//  Created by xun.liu on 14-10-30.
//  Copyright (c) 2014年 xun.liu. All rights reserved.
//

#ifndef TTVideoHD_TTCommon_h
#define TTVideoHD_TTCommon_h

#import "UIView+ViewController.h"
#import "AppDelegate.h"
#import "SandboxHelper.h"

//获取物理屏幕的尺寸
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

//通过三色值获取颜色对象
#define COLORWITHRGB(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//获取系统版本
#define SYSTEMVERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//视频接口
#define video_url_haiyao               @"http://27.221.18.143/6973F6985124383A8E8A98665F/030008010054828BF45AC20182ECB0409DFE3D-9363-D8CE-72B6-F6A3455164D6.mp4"//@"http://vf1.mtime.cn/Video/2012/04/23/mp4/120423212602431929.mp4"
#define video_url_yishengsuoai         @"http://godmusic.bs2dl.yy.com/godmusic_1428683534114_h264.mp4"
#define video_url_pingfandelu          @"http://godmusic.bs2dl.yy.com/godmusic_1427949106436_h264.mp4"

#define PLAYER_IP           @"playerIP"    //类型
#define PLAYER_URL          @"playerURL"   //自定义URL
#define ISSETTING           @"isSetting"   //是否是设置页

#endif
