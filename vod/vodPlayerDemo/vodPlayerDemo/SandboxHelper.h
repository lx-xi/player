//
//  SandboxHelper.h
//  vodPlayerDemo
//
//  Created by xun.liu on 15/3/31.
//  Copyright (c) 2015年 xun.liu. All rights reserved.
//  lx_xi163@163.com

/*
 方法1、可以设置显示隐藏文件，然后在Finder下直接打开。设置查看隐藏文件的方法如下：打开终端，输入命名
 (1)显示Mac隐藏文件的命令：defaults write com.apple.finder AppleShowAllFiles -bool true
 (2)隐藏Mac隐藏文件的命令：defaults write com.apple.finder AppleShowAllFiles -bool false
 (3)输完单击Enter键，退出终端，重新启动Finder就可以了 重启Finder：鼠标单击窗口左上角的苹果标志-->强制退出-->Finder-->
    现在能看到资源库文件夹了。
 打开资源库后找到/Application Support/iPhone Simulator/文件夹。这里面就是模拟器的各个程序的沙盒目录了。
 
 方法2、这种方法更方便，在Finder上点->前往->前往文件夹，输入/Users/username/Library/Application Support/iPhone Simulator/  前往。
 */

#import <Foundation/Foundation.h>

@interface SandboxHelper : NSObject

+ (NSString *)homePath;             // 程序主目录，可见子目录(3个):Documents、Library、tmp
+ (NSString *)appPath;              // 程序目录，不能存任何东西
+ (NSString *)docPath;              // 文档目录，需要ITUNES同步备份的数据存这里，可存放用户数据
+ (NSString *)libPrefPath;          // 配置目录，配置文件存这里
+ (NSString *)libCachePath;         // 缓存目录，系统永远不会删除这里的文件，ITUNES会删除
+ (NSString *)tmpPath;              // 临时缓存目录，APP退出后，系统可能会删除这里的内容
+ (BOOL)hasLive:(NSString *)path;   // 判断目录是否存在，不存在则创建

@end
