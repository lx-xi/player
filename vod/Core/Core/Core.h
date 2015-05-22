//
//  Core.h
//  Core
//
//  Created by xun.liu on 14/11/20.
//  Copyright (c) 2014年 xun.liu. All rights reserved.
//  lx_xi163@163.com

#import <Foundation/Foundation.h>

//@interface Core : NSObject


/**
 *    @brief  创建player句柄
 *    @param  url  播放源
 *    @return void* IOSPlayer
 */
void *player_create(int delay);

/**
 *    @brief  等待player创建
 *    @param  url  播放源
 *    @return 0 成功
 */
int player_prepare(void *ios_player, char *url);

/**
 *    @brief  获取playerView
 *    @param  *ios_player IOSPlayer
 *    @return void* playerView
 */
void *player_get_view(void *ios_player);


/**
 *    @brief  播放情况回调
 *    @param  *ios_player IOSPlayer；*callback 回调；
 *    @return 0 成功
 ******
 *    callback（void *opaque, int result, int type）
 *    result:回调返回值
 *    type: 2，进度回调； 3，缓冲回调； 4，视频播放完成； 5，rate
 */
int player_register_callback(void *ios_player, void *callback, void *opaque);


/**
 *    @brief  获取视频总时间
 *    @param  *ios_player IOSPlayer； duration 获取时间指针
 *    @return 0 成功
 */
int player_get_duration(void *ios_player, double *duration);

//---
/**
 *    @brief  播放
 *    @param  *ios_player IOSPlayer
 *    @return
 */
void player_play(void *ios_player);


/**
 *    @brief  暂停
 *    @param  *ios_player IOSPlayer
 *    @return
 */
void player_pause(void *ios_player);


/**
 *    @brief  停止
 *    @param  *ios_player IOSPlayer
 *    @return
 */
void player_stop(void *ios_player);


/**
 *    @brief  控制 播放 进度
 *    @param  *ios_player IOSPlayer； progress seek到的位置
 *    @return
 */
void player_set_progress(void *ios_player, double progress);

//
/**
 *    @brief  捕获 某一时间点 图像
 *    @param  *ios_player IOSPlayer； timePoint capture的时间点
 *    @return void* 获取图片
 */
void *player_get_captureImage(void *ios_player, double timePoint);


/**
 *    @brief  获取当前音量值
 *    @param  *ios_player IOSPlayer； volume 音量指针
 *    @return 0 成功
 */
int player_get_currentVolume(void *ios_player, float *volume);


/**
 *    @brief  控制 音量
 *    @param  *ios_player IOSPlayer； volume 音量
 *    @return
 */
void player_set_volume(void *ios_player, float volume);


/**
 *    @brief  获取当前播放视频的宽和高
 *    @param  *ios_player IOSPlayer； width 宽度指针；height高度指针
 *    @return 0 成功
 */
int player_get_playerbackSize(void *ios_player, float *width, float *height);


//@end













