//
//  PlayerUI.h
//  PlayerUI
//
//  Created by xun.liu on 14/11/28.
//  Copyright (c) 2014年 xun.liu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TTPlaybackState) {
    TTPlaybackStateStopped = 0,  //播放停止状态
    TTPlaybackStatePlaying,      //正在播放状态
    TTPlaybackStatePaused,       //暂停播放状态
    TTPlaybackStateFinished,     //播放完成状态
    TTPlaybackStateFailed,       //播放失败状态(视频损坏或无法识别)
};


@protocol PlayerUIDelegate <NSObject>

- (void)fullScreenAction;

@end

@class Core;
@interface PlayerUI : UIView

@property (nonatomic, assign) id<PlayerUIDelegate>delegate;
@property (nonatomic, assign) TTPlaybackState playbackState;
@property (nonatomic, strong) NSString *urlString;

- (id)initWithFrame:(CGRect)frame URL:(NSString *)urlString;

- (void)videoStop;

@end
