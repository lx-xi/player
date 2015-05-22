//
//  TTSlider.m
//  vodPlayerDemo
//
//  Created by xun.liu on 14/12/12.
//  Copyright (c) 2014年 xun.liu. All rights reserved.
//  lx_xi163@163.com

#import "TTSlider.h"
#import <objc/message.h>

#define POINT_OFFSET    (2)

@interface UIImage (TTSlider)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end

@implementation UIImage (TTSlider)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    UIImage *image = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

@interface TTSlider ()
{
    UISlider        *_slider;
    UIProgressView  *_progressView;
    BOOL            _loaded;
    
    id              _target;
    SEL             _action;
}

@end

@implementation TTSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubView];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self loadSubView];
}

- (void)loadSubView
{
    if (_loaded) {
        return;
    }
    
    _loaded = YES;
    
    self.backgroundColor = [UIColor clearColor];
    
    _slider = [[UISlider alloc] initWithFrame:CGRectZero];
    _slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_slider];
    [_slider addTarget:self action:@selector(sliderValueChangeDidBegin:) forControlEvents:UIControlEventTouchDown];
    [_slider addTarget:self action:@selector(sliderValueChangeDidEnd:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchCancel)];

    _progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _progressView.userInteractionEnabled = NO;
    
    [_slider addSubview:_progressView];
    [_slider sendSubviewToBack:_progressView];
    
    _progressView.progressTintColor = [UIColor darkGrayColor];
    _progressView.trackTintColor = [UIColor lightGrayColor];
    _slider.maximumTrackTintColor = [UIColor clearColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _slider.frame = self.bounds;
    CGRect rect = _slider.bounds;
    rect.origin.x = rect.origin.x + POINT_OFFSET;
    rect.size.width = rect.size.width - POINT_OFFSET * 2;
    _progressView.frame = rect;
    _progressView.center = _slider.center;
}

- (void)sliderValueChangeDidBegin:(UISlider *)slider
{
    if (_delegate && [_delegate respondsToSelector:@selector(sliderValueChangeDidBegin:)]) {
        [_delegate sliderValueChangeDidBegin:self];
    }
}

- (void)sliderValueChanged:(UISlider *)slider;
{
    if (_delegate && [_delegate respondsToSelector:@selector(sliderValueChanged:)]) {
        [_delegate sliderValueChanged:self];
    }
}

- (void)sliderValueChangeDidEnd:(UISlider *)slider
{
    if (_delegate && [_delegate respondsToSelector:@selector(sliderValueChangeDidEnd:)]) {
        [_delegate sliderValueChangeDidEnd:self];
    }
}

#pragma mark - 
#pragma mark setting & getting
//value
- (CGFloat)value
{
    return _slider.value;
}

- (void)setValue:(CGFloat)value
{
    _slider.value = value;
}

- (CGFloat)bufferValue
{
    return _progressView.progress;
}

- (void)setBufferValue:(CGFloat)bufferValue
{
    _progressView.progress = bufferValue;
}

//color
- (UIColor *)thumbTintColor
{
    return _slider.thumbTintColor;
}

- (void)setThumbTintColor:(UIColor *)thumbTintColor
{
    [_slider setThumbTintColor:thumbTintColor];
}

- (UIColor *)minimumTrackTintColor
{
    return _slider.minimumTrackTintColor;
}

- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor
{
    [_slider setMinimumTrackTintColor:minimumTrackTintColor];
}

- (UIColor *)middleTrackTintColor
{
    return _progressView.progressTintColor;
}

- (void)setMiddleTrackTintColor:(UIColor *)middleTrackTintColor
{
    _progressView.progressTintColor = middleTrackTintColor;
}

- (UIColor *)maximumTrackTintColor
{
    return _progressView.trackTintColor;
}

- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor
{
    _progressView.trackTintColor = maximumTrackTintColor;
}

//image
- (UIImage *)thumbImage
{
    return _slider.currentThumbImage;
}

- (void)setThumbImage:(UIImage *)thumbImage forState:(UIControlState)state
{
    [_slider setThumbImage:thumbImage forState:state];
}

- (UIImage *)minimumTrackImage
{
    return _slider.currentMinimumTrackImage;
}

- (void)setMinimumTrackImage:(UIImage *)minimumTrackImage
{
    [_slider setMinimumTrackImage:minimumTrackImage forState:UIControlStateNormal];
}

- (UIImage *)middleTrackImage
{
    return _progressView.progressImage;
}

- (void)setMiddleTrackImage:(UIImage *)middleTrackImage
{
    _progressView.progressImage = middleTrackImage;
}

- (UIImage *)maximumTrackImage
{
    return _progressView.trackImage;
}

- (void)setMaximumTrackImage:(UIImage *)maximumTrackImage
{
    [_slider setMaximumTrackImage:[UIImage imageWithColor:[UIColor clearColor] size:maximumTrackImage.size] forState:UIControlStateNormal];
    _progressView.trackImage = maximumTrackImage;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
