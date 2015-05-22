//
//  Core.m
//  Core
//
//  Created by xun.liu on 14/11/20.
//  Copyright (c) 2014年 xun.liu. All rights reserved.
//  lx_xi163@163.com

#import "Core.h"
#import "TTAVPlayer.h"

typedef struct _player
{
    int    type;
    void*  player;
}IOSPlayer;

//@interface Core ()
//
//@end
//
//@implementation Core


//创建player
void *player_create(int delay)
{
//    NSString *urlStr = [[NSString alloc] initWithCString:url encoding:NSASCIIStringEncoding];
//    TTAVPlayer *avplayer = [[TTAVPlayer alloc] init];
//    BOOL success =[avplayer videoPlayerCreateWithURL:urlStr];
//    NSLog(@"player : %@",avplayer);
//    if(success) {
//        IOSPlayer *ret = (IOSPlayer *)malloc(sizeof(IOSPlayer));
//        ret->player = (__bridge_retained void *)avplayer;
//        ret->type = 0;
//        return ret;
//    }
//    else {
//        //----------ffmpeg-------------
//        
//    }
    

    TTAVPlayer *avplayer = [[TTAVPlayer alloc] init];
    avplayer.delay = delay;
    NSLog(@"player : %@",avplayer);
    
    IOSPlayer *ret = (IOSPlayer *)malloc(sizeof(IOSPlayer));
    ret->player = (__bridge_retained void *)avplayer;
    ret->type = 0;
    
    return ret;
    
}

int player_prepare(void *ios_player, char *url)
{
    IOSPlayer *player = (IOSPlayer *)ios_player;
    if (player->type == 0) {
        TTAVPlayer *avplayer=(__bridge TTAVPlayer*)(player->player);
        
        NSString *urlStr = [[NSString alloc] initWithCString:url encoding:NSASCIIStringEncoding];
        BOOL success =[avplayer videoPlayerCreateWithURL:urlStr];
        if(success) {
            return 0;
        }
        else {
            return -1;
        }
    }
    else if (player->type == 1) {
        //----------ffmpeg-------------
    }
    
    return 0;
}

void *player_get_view(void *ios_player)
{
    IOSPlayer *player = (IOSPlayer *)ios_player;
    if (player->type == 0) {
        TTAVPlayer *avplayer=(__bridge TTAVPlayer*)(player->player);
        
        return (__bridge void *)[avplayer videoPlayerReceivePlayerView];
    }
    else if (player->type == 1) {
        //----------ffmpeg-------------
    }
    
    return nil;
}

//回调
int player_register_callback(void *ios_player, void *callback, void *opaque)
{
    IOSPlayer *player = (IOSPlayer *)ios_player;
    if (player->type == 0) {
        TTAVPlayer *avplayer=(__bridge TTAVPlayer*)(player->player);
        avplayer.videoPlayerCallback = (VideoPlayerCallback)callback;
        avplayer.opaque = opaque;
    }
    else if (player->type == 1) {
        //----------ffmpeg-------------
    }
    
    return 0;
}

//获取视频总时间
int player_get_duration(void *ios_player, double *duration)
{
    IOSPlayer *player = (IOSPlayer *)ios_player;
    int ret;
    if (player->type == 0) {
        TTAVPlayer *avplayer=(__bridge TTAVPlayer *)(player->player);
        ret=[avplayer videoPlayerReceiveDuration:duration];
    }
    else if (player->type == 1) {
        //----------ffmpeg-------------
    }
    
    
    if(ret) {
        return -1;
    }
    return 0;
}

//---
//播放
void player_play(void *ios_player)
{
    IOSPlayer *player = (IOSPlayer * )ios_player;
    if(player->type == 0) {
        TTAVPlayer *avplayer = (__bridge TTAVPlayer *)(player->player);
        [avplayer videoPlayerPlay];
    }
    else if (player->type == 1) {
        //----------ffmpeg-------------
    }
    else {
        return;
    }
}

//暂停
void player_pause(void *ios_player)
{
    IOSPlayer *player = (IOSPlayer *)ios_player;
    if (player->type == 0) {
        TTAVPlayer *avplayer = (__bridge TTAVPlayer *)(player->player);
        [avplayer videoPlayerPause];
    }
    else if (player->type == 1) {
        //----------ffmpeg-------------
    }
    else {
        
    }
}

//停止
void player_stop(void *ios_player)
{
    IOSPlayer *player = (IOSPlayer *)ios_player;
    if (!player) {
        return;
    }
    
    if (player->type == 0) {
        TTAVPlayer *avplayer = (__bridge TTAVPlayer *)(player->player);
        [avplayer videoPlayerStop];
        avplayer = nil;
        free(player);
    }
    else if (player->type == 1) {
        //----------ffmpeg-------------
    }
    else {
        
    }
    
    
}

//获取当前进度
int player_get_progress(void *ios_player, double *progress)
{
    IOSPlayer *player = (IOSPlayer *)ios_player;
    int ret;
    if (player->type == 0) {
        TTAVPlayer *avplayer = (__bridge TTAVPlayer *)(player->player);
        ret = [avplayer videoPlayerReceiveProgress:progress];
    }
    else if (player->type == 1) {
        //----------ffmpeg-------------
    }

    if (ret) {
        return -1;
    }
    return 0;
}

#warning 有待修改
//控制 播放 进度
void player_set_progress(void *ios_player, double progress)
{
    IOSPlayer *player = (IOSPlayer *)ios_player;
    if (player->type == 0) {
        TTAVPlayer *avplayer = (__bridge TTAVPlayer *)(player->player);
        [avplayer videoPlayerProgressHandle:progress];
    }
    else if (player->type == 1) {
        //----------ffmpeg-------------
    }
}

//获取当前缓冲进度
int player_get_bufferProgress(void *ios_player, double *progress)
{
    IOSPlayer *player = (IOSPlayer *)ios_player;
    int ret;
    if (player->type == 0) {
        TTAVPlayer *avplayer = (__bridge TTAVPlayer *)(player->player);
        ret = [avplayer videoPlayerReceiveBufferProgress:progress];
    }
    else if (player->type == 1) {
        //----------ffmpeg-------------
    }
    
    
    if (ret) {
        return -1;
    }
    return 0;
}

//捕获 某一时间点 图像
void *player_get_captureImage(void *ios_player, double timePoint)
{
    IOSPlayer *player = (IOSPlayer *)ios_player;
    if (player->type == 0) {
        TTAVPlayer *avplayer = (__bridge TTAVPlayer *)(player->player);
        UIImage *captureImage = [avplayer captureImage:timePoint];
        if (captureImage) {
            return (__bridge_retained void *)(captureImage);
        }
    }
    else if (player->type == 1) {
        //----------ffmpeg-------------
    }
    
    return nil;
}

//获取当前音量值
int player_get_currentVolume(void *ios_player, float *volume)
{
    IOSPlayer *player = (IOSPlayer *)ios_player;
    int ret;
    if (player->type == 0) {
        TTAVPlayer *avplayer = (__bridge TTAVPlayer *)(player->player);
        ret = [avplayer videoPlayerReceiveVolume:volume];
    }
    else if (player->type ==1) {
        //----------ffmpeg-------------
    }
    
    
    if (ret) {
        return -1;
    }
    return 0;
}

#warning 有待修改
//控制 音量
void player_set_volume(void *ios_player, float volume)
{
    IOSPlayer *player = (IOSPlayer *)ios_player;
    if (player->type == 0) {
        TTAVPlayer *avplayer = (__bridge TTAVPlayer *)(player->player);
        [avplayer videoPlayerVolumeHandle:volume];
    }
    else if (player->type == 1) {
        //----------ffmpeg-------------
    }
}

int player_get_playerbackSize(void *ios_player, float *width, float *height)
{
    IOSPlayer *player = (IOSPlayer *)ios_player;
    int ret;
    if (player->type == 0) {
        TTAVPlayer *avplayer = (__bridge TTAVPlayer *)(player->player);
        ret = [avplayer videoPlayerPlaybackSizeWithWidth:width height:height];
    }
    
    if (ret) {
        return -1;
    }
    return 0;
}


//@end
