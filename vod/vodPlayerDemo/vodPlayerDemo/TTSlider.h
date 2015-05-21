//
//  TTSlider.h
//  vodPlayerDemo
//
//  Created by xun.liu on 14/12/12.
//  Copyright (c) 2014年 xun.liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTSliderDelegate;

@interface TTSlider : UIControl

@property (nonatomic, assign) id<TTSliderDelegate>delegate;

@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) CGFloat bufferValue;

@property (nonatomic, strong) UIColor *thumbTintColor;
@property (nonatomic, strong) UIColor *minimumTrackTintColor;
@property (nonatomic, strong) UIColor *middleTrackTintColor;
@property (nonatomic, strong) UIColor *maximumTrackTintColor;

@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, strong) UIImage *minimumTrackImage;
@property (nonatomic, strong) UIImage *middleTrackImage;
@property (nonatomic, strong) UIImage *maximumTrackImage;

- (void)setThumbImage:(UIImage *)thumbImage forState:(UIControlState)state;

@end

@protocol TTSliderDelegate <NSObject>

- (void)sliderValueChangeDidBegin:(TTSlider *)slider;
- (void)sliderValueChanged:(TTSlider *)slider;
- (void)sliderValueChangeDidEnd:(TTSlider *)slider;

@end
