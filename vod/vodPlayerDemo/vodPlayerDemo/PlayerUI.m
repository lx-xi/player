//
//  PlayerUI.m
//  PlayerUI
//
//  Created by xun.liu on 14/11/28.
//  Copyright (c) 2014年 xun.liu. All rights reserved.
//  lx_xi163@163.com

#import "PlayerUI.h"
#import "Core.h"
#import "TTSlider.h"

#define kBlackColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
#define COLORWITHRGB(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

void callback (void *opaque, int result, int type);

@interface PlayerUI ()<TTSliderDelegate, UIAlertViewDelegate>
{
    void *_player;
//    void *_captureimage;
    
    UIView *_bottomView;
    UIView *_rightView;
    UIButton *_fullscreenButton;
    UIButton *_videoOverButton;
    UIButton *_playButton;
    UILabel *_durationLabel;
    UILabel *_currentTimeLabel;
    TTSlider *_slider;
    
    BOOL _isBig;
    BOOL _isSeeking;
    int  _rate;
    BOOL _isHide;
}
@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, assign) double duration;  //视频总时长
@property (nonatomic, assign) double currentTime;  //视频当前进度
@property (nonatomic, strong) UIActivityIndicatorView *activity;  //菊花
@property (nonatomic, strong) UIView *activityBgView;   //菊花背景

@property (nonatomic, assign)int playerHeight;  //playback 高
@property (nonatomic, assign)int playerWidth;   //playback 宽


@end

@implementation PlayerUI

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }

    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc----PlayerUI");
    _playerView = nil;
}

- (id)initWithFrame:(CGRect)frame URL:(NSString *)urlString
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupViews];
        
        [self activityStartAnimating];
        [self setupPlayer:urlString];
        
    }
    return self;
}

- (void)setUrlString:(NSString *)urlString
{
    if (_urlString != urlString) {
        _urlString = urlString;
    }
    
    [self videoStop];
    [self setupPlayer:_urlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //异步操作代码块
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //回到主线程操作代码块
            
        });
    });
}

- (void)setupPlayer:(NSString *)urlString
{
    _urlString = urlString;
    char *url = (char *)[_urlString cStringUsingEncoding:NSASCIIStringEncoding];
    if (_player) {
        _player = nil;
    }
    
    //创建
    _player = player_create(10);
    player_register_callback(_player, callback, (__bridge void *)self);
    
    //等待
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int ret = player_prepare(_player, url);
        
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (ret != 0) {
                NSLog(@"视频加载失败");
                _playbackState = TTPlaybackStateFailed;
                _slider.value = 0.0;
                [self activityStopAnimating];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
                [self hiddenSideView];
            }
            else {
                
                _playerView = (__bridge UIView *)(player_get_view(_player));
                
//                player_set_progress(_player, 2);
                
                if (!_playerView) {
                    NSLog(@"视频加载失败");
                    [self videoStop];
                    _playbackState = TTPlaybackStateFailed;
                    _slider.value = 0.0;
                    [self activityStopAnimating];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网路" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    
                    [self hiddenSideView];
                    
                    return;
                }
                
                _playerView.frame = self.bounds;
                
                [self insertSubview:_playerView atIndex:0];
                
                
                //play
                player_play(_player);
                [_playButton setImage:[UIImage imageNamed:@"btn_play_nal.png"] forState:UIControlStateNormal];
                _playbackState = TTPlaybackStatePlaying;
                
                //获取视频总时间
                player_get_duration(_player, &_duration);
                _durationLabel.text = [self convertTime:_duration append:nil];
                _slider.value = 8.0/_duration;
                
                //获取当前音量值
                float volume;
                player_get_currentVolume(_player, &volume);
                NSLog(@"current volume is %f", volume);
                
                //获取playback宽高
                float height;
                float width;
                player_get_playerbackSize(_player, &width, &height);
                _playerHeight = height;
                _playerWidth = width;
                
                //允许seek
                _slider.userInteractionEnabled = YES;
                
                [self activityStopAnimating];
            }
            
        });
    });
}

//---------------
- (void)twoTapAction:(UITapGestureRecognizer *)tap
{
    _isBig = !_isBig;
    [self setNeedsLayout];
}

#pragma mark -
#pragma mark setup views
- (void)setupViews
{
    _duration = 0.0;
    _currentTime = 0.0;
    _isBig = NO;
    _isSeeking = NO;
    _isHide = NO;
    
    self.backgroundColor = [UIColor blackColor];
    
    //bottom View
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = kBlackColor;
    [self addSubview:_bottomView];
    
    _slider = [[TTSlider alloc] init];
    _slider.userInteractionEnabled = NO;
//    _slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _slider.delegate = self;
    _slider.value = 0.0f;
    _slider.bufferValue = 0.0f;
    [_slider setThumbImage:[UIImage imageNamed:@"slider_thumb.png"] forState:UIControlStateNormal];
    [_slider setMinimumTrackImage:[UIImage imageNamed:@"slider_progress.png"]];
    _slider.middleTrackImage = [UIImage imageNamed:@"slider_buffer.png"];
    _slider.maximumTrackImage = [UIImage imageNamed:@"slider_bg_shu.png"];
    
    _slider.middleTrackTintColor = COLORWITHRGB(255, 213, 171, 1);
//    _slider.maximumTrackTintColor = COLORWITHRGB(199, 199, 199, 1);
//    _slider.minimumTrackTintColor = COLORWITHRGB(254, 127, 0, 1);
    [_bottomView addSubview:_slider];
    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setImage:[UIImage imageNamed:@"btn_play_nal.png"] forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_playButton];
    
    _currentTimeLabel = [[UILabel alloc] init];
    _currentTimeLabel.text = [self convertTime:_currentTime append:@"/"];
    _currentTimeLabel.textAlignment = NSTextAlignmentRight;
    _currentTimeLabel.font = [UIFont systemFontOfSize:13.0];
    _currentTimeLabel.textColor = [UIColor whiteColor];
    _currentTimeLabel.backgroundColor = [UIColor clearColor];
    [_bottomView addSubview:_currentTimeLabel];
    
    _durationLabel = [[UILabel alloc] init];
    _durationLabel.text = [self convertTime:_currentTime append:nil];
    _durationLabel.font = [UIFont systemFontOfSize:13.0];
    _durationLabel.textColor = [UIColor whiteColor];
    _durationLabel.backgroundColor = [UIColor clearColor];
    [_bottomView addSubview:_durationLabel];
    
    //right View
    _rightView = [[UIView alloc] init];
    _rightView.backgroundColor = [UIColor clearColor];
    [self addSubview:_rightView];
    
    _fullscreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fullscreenButton setImage:[UIImage imageNamed:@"btn_fullScreen_nal.png"] forState:UIControlStateNormal];
    [_fullscreenButton addTarget:self action:@selector(fullscreenAction:) forControlEvents:UIControlEventTouchUpInside];
    [_rightView addSubview:_fullscreenButton];
    
    _videoOverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_videoOverButton setImage:[UIImage imageNamed:@"btn_videoOver_nal.png"] forState:UIControlStateNormal];
    [_videoOverButton addTarget:self action:@selector(videoOverAction) forControlEvents:UIControlEventTouchUpInside];
    [_rightView addSubview:_videoOverButton];
    
    //UIActivityIndicatorView
    [self setupActivityView];
    
    
    //隐藏边栏
    [self performSelector:@selector(hiddenSideView) withObject:@10 afterDelay:10];
    
    //添加单击隐藏或显示侧边栏手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    //添加双击等比放大手势
    UITapGestureRecognizer *twoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoTapAction:)];
    twoTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:twoTap];
    [tap requireGestureRecognizerToFail:twoTap];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self];
    float subY = self.frame.size.height-_bottomView.frame.size.height-10;
    BOOL flag = ((point.y < subY) && (point.y != 0)) ? YES : NO;
    if (!_isHide && flag) {
        _rightView.alpha = 0;
        _bottomView.alpha = 0;
        _isHide = YES;
    }
    else if (_isHide) {
        _rightView.alpha = 1;
        _bottomView.alpha = 1;
        _isHide = NO;
        //隐藏边栏
        if (!_isSeeking) {
            //取消上一次的performe延时
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenSideView) object:@10];
            //开启新的延时
            [self performSelector:@selector(hiddenSideView) withObject:@10 afterDelay:10];
        }
    }
}

- (void)hiddenSideView
{
    [UIView animateWithDuration:1.0 animations:^{
        _rightView.alpha = 0;
        _bottomView.alpha = 0;
    } completion:^(BOOL finished) {
        _isHide = YES;
    }];
}

#pragma mark -
#pragma mark layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    //bottom
    _bottomView.frame = CGRectMake(0, self.frame.size.height-42, self.frame.size.width, 42);
    _playButton.frame = CGRectMake(0, 0, 47, _bottomView.frame.size.height);
    _slider.frame = CGRectMake(_playButton.frame.size.width+5, 12, self.frame.size.width-180, 20);
    _currentTimeLabel.frame = CGRectMake(_slider.frame.origin.x+_slider.frame.size.width+5, 10, 42, 21);
    _durationLabel.frame = CGRectMake(_currentTimeLabel.frame.origin.x+_currentTimeLabel.frame.size.width, 10, 38, 21);
    
    //right
    _rightView.frame = CGRectMake(self.frame.size.width-42, self.frame.size.height-132, 42, 90);
    _fullscreenButton.frame = CGRectMake(0, 0, _rightView.bounds.size.width, _rightView.bounds.size.width);
    _videoOverButton.frame = CGRectMake(0, _fullscreenButton.frame.origin.y+_fullscreenButton.frame.size.height+5, _rightView.bounds.size.width, _rightView.bounds.size.width);
    
    [_fullscreenButton setImage:[UIImage imageNamed:@"btn_notFullscreen_nal.png"] forState:UIControlStateNormal];
    
    if (!_isBig) {
        _playerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    else {
        
        if (_playerHeight>0 && _playerWidth>0) {
            CGRect frame = _playerView.frame;
            frame.size.width = self.frame.size.height*_playerWidth / _playerHeight;
            frame.size.height = self.frame.size.height;
            _playerView.frame = frame;
            _playerView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
            NSLog(@"%@", NSStringFromCGRect(frame));
        }
    }

    //UIActivityIndicatorView
    _activityBgView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
}

#pragma mark -
#pragma mark video player callback
void callback (void *opaque, int result, int type)
{
    PlayerUI *playerUI = (__bridge PlayerUI *)opaque;
    [playerUI callbackAction:type result:result];
}


- (void)callbackAction:(int)type result:(int)result
{
    if (type == 1) {
        if (result == 1) {
            NSLog(@"AVPlayerStatusFailed");
        }
        else if (result == 2) {
            NSLog(@"AVPlayerStatusUnknown");
        }
        
        _playbackState = TTPlaybackStateFailed;
        [self activityStopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"视频加载失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        [self hiddenSideView];
    }
    else if (type == 2) {   //实时获取当前播放进度
        _currentTime = result/1000.0;
        double progress = _duration * _slider.value;
        if (progress > _currentTime) {
            return;
        }
        
        if (_duration != 0 && !_isSeeking) {
            _slider.value = _currentTime/_duration;
            if (_slider.value == 1) {
                _currentTime = _duration;
            }
            _currentTimeLabel.text = [self convertTime:_currentTime append:@"/"];
        }
    }
    else if (type == 3) {  //实时获取当前缓冲进度
        if (_duration != 0) {
            _slider.bufferValue = (result/1000)/_duration;
        }
    }
    else if (type == 4) {  //播放完成
        player_pause(_player);
        _playbackState = TTPlaybackStateFinished;
        _playButton.selected = YES;
        [_playButton setImage:[UIImage imageNamed:@"btn_pause_nal.png"] forState:UIControlStateNormal];
        [self activityStopAnimating];
    }
    else if (type == 5) {
        //result = 0：播放停了     result = 1：播放正常
        NSLog(@"rate =  %d", result);
        _rate = result;
        if (result == 0) {
            if (_playbackState == TTPlaybackStatePlaying || _playbackState ==  TTPlaybackStatePaused) {
                [self activityStartAnimating];
            }
        }
        else if (result == 1) {
            [self activityStopAnimating];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark -
#pragma mark button action
- (void)fullscreenAction:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(fullScreenAction)]) {
        [_delegate fullScreenAction];
    }
}

- (void)videoOverAction
{
    [self videoStop];
    [self gobackAction];
}

- (void)videoStop
{
    player_stop(_player);
    _slider.userInteractionEnabled = NO;
    [_playButton setImage:[UIImage imageNamed:@"btn_pause_nal.png"] forState:UIControlStateNormal];
    _playbackState = TTPlaybackStateStopped;
    
    [_playerView removeFromSuperview];
    _player = nil;
}

- (void)playAction:(UIButton *)sender
{
    if (!_player) {
        return;
    }
    
    if (_playButton.selected) {
        player_play(_player);
        [_playButton setImage:[UIImage imageNamed:@"btn_play_nal.png"] forState:UIControlStateNormal];
        _playbackState = TTPlaybackStatePlaying;
    }
    else {
        player_pause(_player);
        [self activityStopAnimating];
        [_playButton setImage:[UIImage imageNamed:@"btn_pause_nal.png"] forState:UIControlStateNormal];
        _playbackState = TTPlaybackStatePaused;
    }
    
    sender.selected = !sender.selected;
}

#pragma mark -
#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

}

- (void)gobackAction
{
//    [self.viewController.navigationController popViewControllerAnimated:YES];
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark TTSliderDelegate
- (void)sliderValueChangeDidBegin:(TTSlider *)slider
{
    NSLog(@"slider change begin");
    if (_playbackState != TTPlaybackStateFinished) {
        _isSeeking = YES;
    }
}

- (void)sliderValueChanged:(TTSlider *)slider
{
    NSLog(@"Slider value=%f, bufferValue=%f", slider.value, slider.bufferValue);
    [self tapAction:nil];

    double progress = _duration * slider.value;
//    player_set_progress(_player, progress);
    _currentTime = progress;
    _currentTimeLabel.text = [self convertTime:_currentTime append:@"/"];
}

- (void)sliderValueChangeDidEnd:(TTSlider *)slider
{
    //seek
    double progress = _duration * slider.value;
    player_set_progress(_player, progress);
    _currentTime = progress;
    _currentTimeLabel.text = [self convertTime:_currentTime append:@"/"];
    
    NSLog(@"slider change end");
    _isSeeking = NO;
    
    //取消上一次的performe延时
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenSideView) object:@10];
    //开启新的延时
    [self performSelector:@selector(hiddenSideView) withObject:@10 afterDelay:10];
}



#pragma mark -
#pragma mark Kit
- (NSString *)convertTime:(CGFloat)second append:(NSString *)append
{
    NSMutableString *str = [NSMutableString string];
    int m = second/60;
    if (m <= 9) {
        [str appendFormat:@"0%d",m];
    }
    else {
        [str appendFormat:@"%d",m];
    }
    
    int s = (int)second%60;
    if (s <= 9) {
        [str appendFormat:@":0%d",s];
    }
    else {
        [str appendFormat:@":%d",s];
    }
    
    if (append) {
        [str appendString:append];
    }
    
    return str;
}

#pragma mark -
#pragma mark UIActivityIndicatorView
- (void)setupActivityView
{
    _activityBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    _activityBgView.layer.cornerRadius = 2;
    _activityBgView.layer.masksToBounds = YES;
    _activityBgView.backgroundColor = [UIColor blackColor];
    _activityBgView.alpha = 0.5;
    [self insertSubview:_activityBgView atIndex:0];
    
    _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activity.center = _activityBgView.center;
    [_activityBgView addSubview:_activity];
}

- (void)activityStartAnimating
{
    _activityBgView.hidden = NO;
    [_activity startAnimating];
}

- (void)activityStopAnimating
{
    _activityBgView.hidden = YES;
    [_activity stopAnimating];
}


@end
